extends "res://game/spells/AbstractProjectile.gd"

var pierce_counter: int = 0


func _ready():
	velocity = 25.0
	damage = 15
	projectile_expire_time = 1
	DestroyTimer.set_wait_time(projectile_expire_time)
	DestroyTimer.start()


func _on_Projectile_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		pierce_counter += 1
		if (pierce_counter > 3):  # can pierce no more than three bodies
			destroy()
