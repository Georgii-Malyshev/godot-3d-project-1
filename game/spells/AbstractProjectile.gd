extends Area

# Don't use this abstract scene directly; you must extend it, then override 
# _ready() function and at least start projectile's DestroyTimer in it: 
#
# 	func _ready():
#		DestroyTimer.start()
#
#
# When extending, you can override parent's varible values like so (notice the order of operations): 
#	func _ready():
#		velocity = 24.0
#		damage = 15
#		projectile_expire_time = 1.0
#		$DestroyTimer.set_wait_time(projectile_expire_time)
#		DestroyTimer.start()

# Stats
var velocity: float = 6.0
var damage: int = 15
# has no effect unless used to explicitly override DestroyTimer's wait_time (see comment above)
var projectile_expire_time: float = 3.0

# Components
var shooting_actor: Node setget set_shooting_actor, get_shooting_actor
onready var DestroyTimer: Timer = $DestroyTimer


func set_shooting_actor(node: Node) -> void:
	shooting_actor = node


func get_shooting_actor() -> Node:
	return shooting_actor


func _process(delta) -> void:
	# make sure that inheriting projectiles have started DestroyTimer so they don't travel indefinitely
	assert(not DestroyTimer.is_stopped())
	# move projectile forwards in a straight line
	translation += global_transform.basis.z * velocity * delta


func _on_Projectile_body_entered(body: Node):
	# TODO use physics layers to stop projectile from going through walls
	if (
		body != shooting_actor
		and body.has_method("take_damage")
	):
		body.take_damage(damage)
		destroy()


func destroy():
	queue_free()
