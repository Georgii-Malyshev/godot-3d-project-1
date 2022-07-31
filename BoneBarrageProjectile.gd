extends "res://game/spells/AbstractProjectile.gd"


func _ready():
	velocity = 24.0
	damage = 15
	projectile_expire_time = 0.6
	DestroyTimer.set_wait_time(projectile_expire_time)
	DestroyTimer.start()
