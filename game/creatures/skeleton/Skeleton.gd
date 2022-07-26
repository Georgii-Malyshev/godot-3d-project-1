extends KinematicBody

# stats
var max_health: int = 100
var current_health: int = 100
var movement_speed: float = 2
var attackDamage: int = 25
var attackRate: float = 1.0
var attackDistance: float = 1

# pathfinding
var path: Array = []
var path_node_index: int = 0

# behavior tree-related
var sees_player: bool = false

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


func turn_to_player():
	look_at(GlobalVars.get_player_global_position(), Vector3.UP)


func _check_if_player_is_in_sight() -> void:
	sees_player = false
	# check if player is inside FoV area
	var ray_cast = $LineOfSightRayCast
	var fov_overlapping_bodies: Array = $FieldOfViewArea.get_overlapping_bodies()
	for body in fov_overlapping_bodies:
		if body is Player:
			# check if player is in line of sight (not blocked by bodies)
			
			var player_height_adjustment := Vector3(0, 1.8, 0)
			var player_global_position_adjusted := (GlobalVars.get_player_global_position() + player_height_adjustment)
			var player_local_position_adjusted : Vector3 = ray_cast.to_local(player_global_position_adjusted)
			
			ray_cast.set_enabled(true)
			ray_cast.set_cast_to(player_local_position_adjusted)
			
			if ray_cast.is_colliding():
				var collider: Object = ray_cast.get_collider()
				if collider is Player:
					sees_player = true
			break
		else:
			# don't check line of sight if player isn't in FoV area
			ray_cast.set_enabled(false)


func _on_Timer_timeout():
	if translation.distance_to(GlobalVars.get_player_global_position()) <= attackDistance:
		print(self.get_name() + " attacks player!")  # TODO delete after debug
		attack()


func _physics_process(delta : float) -> void:
	_check_if_player_is_in_sight()
	_move_on_path(delta)


func _move_on_path(delta : float) -> void:
	# reset movement direction vector
	var direction : Vector3 = Vector3.ZERO
	
	# apply gravity
	direction.y -= GlobalVars.get_global_gravity() * delta
	
	if path_node_index < path.size():  # if current node isn't the last one on the path
		var pathfinding_direction : Vector3 = (path[path_node_index] - global_transform.origin)
		# Enemies that don't fly can't move "deliberately" on Y axis, 
		# so discard the Y of their "intended" direction of movement
		pathfinding_direction.y = 0
		direction = direction + pathfinding_direction 
		
		# if close to current node, start using the next node on the path
		if direction.length() < 1:
			path_node_index += 1
		else:
			# move towards the current node along the direction vector
			move_and_slide_with_snap(direction.normalized() * movement_speed, Vector3.DOWN, Vector3.UP)


func _update_path_to(target_pos):
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
	_update_path_to(player.global_transform.origin)
