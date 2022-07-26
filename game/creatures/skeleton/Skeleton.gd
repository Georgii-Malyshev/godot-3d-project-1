extends KinematicBody


# stats
var max_health: int = 100
var current_health: int = 100
var movement_speed: float = 2
var attackDamage: int = 5
var attackRate: float = 1.0
var attackDistance: float = 1

# pathfinding
var path: Array = []
var path_node_index: int = 0

# components
onready var nav: Node = get_parent()  # TODO decouple from parent?
# TODO decouple from player?
onready var player: Node = get_node(GlobalVars.get_player_node_path())

onready var timer1: Timer = $Timer
onready var timer2: Timer = $Timer2


func _ready():
	SignalBus.connect("player_detected_by_ray", self, "_on_player_detected_by_ray")
	
	timer1.set_wait_time(attackRate)
	timer1.start()


func _check_if_player_is_in_sight() -> void:
	
	# check if player is inside FoV and range
	var fov_overlapping_bodies: Array = $FieldOfViewArea.get_overlapping_bodies()
	for body in fov_overlapping_bodies:
		if body is Player:
			# check if player is in line of sight (not blocked by obstacles)
			$FieldOfViewArea/PlayerDetectionRay._cast_ray_to_player()
			break
		else:
			# only cast line-of-sight checking ray if player is actually in FoV and range
			$FieldOfViewArea/PlayerDetectionRay._disable_ray_cast_to_player()


func _on_player_detected_by_ray(signaling_node: Node, collision_position: Vector3) -> void:
	# check if a signal is initially coming from this node's FoV
	if signaling_node.get_parent().get_parent().get_name() == self.get_name():
		look_at(collision_position, Vector3.UP)


func _on_Timer_timeout():
	if translation.distance_to(GlobalVars.get_player_global_position()) <= attackDistance:
		print(self.get_name() + " attacks player!")  # TODO delete after debug
		attack()


func _physics_process(_delta : float) -> void:

	_check_if_player_is_in_sight()
	
	# Movement
	
	# reset movement direction vector
	var direction : Vector3 = Vector3.ZERO
	
	# apply gravity
	direction.y -= GlobalVars.get_global_gravity() * _delta
	
	if path_node_index < path.size():  # if current node isn't the last one on the path
		var pathfinding_direction : Vector3 = (path[path_node_index] - global_transform.origin)
		# Enemies that don't fly can't move "deliberately" on Y axis, 
		# so discard the Y of their "intended" direction of movement
		pathfinding_direction.y = 0
		direction = direction + pathfinding_direction 
		
		if direction.length() < 0.5:
			path_node_index += 1  # start using the next node in the path
		else:
			# move towards the current node along the direction vector
			move_and_slide_with_snap(direction.normalized() * movement_speed, Vector3.DOWN, Vector3.UP)


func update_path_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node_index = 0


func attack():
	player.take_damage(attackDamage)


func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()


func die():
	queue_free()


# TODO rename Timer and Timer2 to something explanatory, use signals only through signal bus
func _on_Timer2_timeout():
	update_path_to(player.global_transform.origin)


func _on_FieldOfViewArea_body_exited(fieldOfViewArea: Node, body: Node) -> void:

	if fieldOfViewArea.get_parent().get_name() == self.get_name():
		if body is Player:
			$FieldOfViewArea/PlayerDetectionRay._disable_ray_cast_to_player()