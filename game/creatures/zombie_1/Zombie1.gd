extends KinematicBody


# stats
var max_health : int = 100
var current_health : int = 100
var movement_speed : float = 0.5
var attackDamage : int = 5
var attackRate : float = 1.0
var attackDistance : float = 0.5

var gravity : float =  18.0

# pathfinding
var path = []
var path_node_index = 0

# components
onready var nav : Node = get_parent()  # get navigation node  # TODO decouple from parent?
# TODO get rid of absolute node path and don't use node that is higher up in the hierarchy
onready var player : Node = get_node("/root/Main/Player")
onready var timer1 : Timer = get_node("Timer")
onready var timer2 : Timer = get_node("Timer2")


# Called when the node enters the scene tree for the first time.
func _ready():
	timer1.set_wait_time(attackRate)
	timer1.start()


func _on_Timer_timeout():
	# try attacking the player if he's within attack distance
	if translation.distance_to(player.translation) <= attackDistance:
		attack()


func _physics_process(delta):
	
	var direction : Vector3
	
	# apply gravity
	direction.y -= gravity * delta
	
	if path_node_index < path.size():  # if current node isn't the last one on the path
		direction = direction + (path[path_node_index] - global_transform.origin)
		
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


func _on_Timer2_timeout():  # TODO rename Timer and Timer2 to something explanatory
	update_path_to(player.global_transform.origin)
