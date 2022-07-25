extends KinematicBody


# stats
var max_health : int = 100
var current_health : int = 100
var movement_speed : float = 2
var attackDamage : int = 5
var attackRate : float = 1.0
var attackDistance : float = 0.5

# pathfinding
var path = []
var path_node_index = 0

# components
onready var nav : Node = get_parent()  # get navigation node  # TODO decouple from parent?
# TODO get rid of absolute node path and don't use node that is higher up in the hierarchy
onready var player : Node = get_node("/root/Main/Player")

onready var timer1 : Timer = $Timer
onready var timer2 : Timer = $Timer2


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# for player detection
	SignalBus.connect("fieldOfViewArea_body_entered", self, "_on_FieldOfViewArea_body_entered")
	SignalBus.connect("fieldOfViewArea_body_exited", self, "_on_FieldOfViewArea_body_exited")
	
	timer1.set_wait_time(attackRate)
	timer1.start()


func _on_Timer_timeout():
	# try attacking the player if he's within attack distance
	if translation.distance_to(player.translation) <= attackDistance:
		attack()


func _process(_delta : float) -> void:
	look_at(player.translation, Vector3.UP)


func _physics_process(_delta : float) -> void:

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


func _on_FieldOfViewArea_body_entered(fieldOfViewArea: Node, body: Node) -> void:

	# check if singal is initially coming from this node's field of view
	if fieldOfViewArea.get_parent().get_name() == self.get_name():
		if body is Player:
			$FieldOfViewArea/PlayerDetectionRay._cast_ray_to_player()


func _on_FieldOfViewArea_body_exited(fieldOfViewArea: Node, body: Node) -> void:

	# check if singal is initially coming from this node's field of view
	if fieldOfViewArea.get_parent().get_name() == self.get_name():
		if body is Player:
			$FieldOfViewArea/PlayerDetectionRay._stop_ray_casting_to_player()
