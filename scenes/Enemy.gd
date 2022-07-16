extends KinematicBody


# stats
var maxHp : int = 30
var currentHp : int = 30
var moveSpeed : float = 1.0
var damage : int = 5
var attackRate : float = 1.0
var attackDistance : float = 2.0

# components
onready var player : Node = get_node("/root/MainScene/Player")
onready var timer : Timer = get_node("Timer")


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(attackRate)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	# try attacking the player if he's within attack distance
	if translation.distance_to(player.translation) <= attackDistance:
		attack()


func _physics_process(delta):
	# calculate direction to the player
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	
	# move towards the player
	move_and_slide(dir * moveSpeed, Vector3.UP)


func attack():
	player.take_damage(damage)


func take_damage(damage):
	currentHp -= damage
	if currentHp <= 0:
		die()


func die():
	player.increase_kills_total(1)
	queue_free()
