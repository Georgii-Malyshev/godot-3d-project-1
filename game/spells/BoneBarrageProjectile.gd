extends "res://game/spells/AbstractProjectile.gd"

# for random spread
var phi_for_x: float
var phi_for_y: float

var pierce_counter: int = 0


func _ready():
	velocity = 25.0
	damage = 25
	projectile_expire_time = 1.2
	DestroyTimer.set_wait_time(projectile_expire_time)
	DestroyTimer.start()
	
	# rotate projectile for random spread
	phi_for_x = rand_range(-0.01, 0.01)
	phi_for_y = rand_range(-0.01, 0.01)
	global_transform.rotated(Vector3(1, 0, 0), phi_for_x)  # rotate projectile on X axis
	global_transform.rotated(Vector3(1, 0, 0), phi_for_y)  # rotate projectile on Y axis


func _process(delta):
	
	# make sure that inheriting projectiles have started DestroyTimer so they don't travel indefinitely
	assert(not DestroyTimer.is_stopped())
	
	# move projectile on a Z axis in a straight line 
	# and add previously generated random deviations for random spread
	translation += (
		(global_transform.basis.z * velocity * delta) 
		+ (global_transform.basis.x * phi_for_x) 
		+ (global_transform.basis.y * phi_for_y)
	)


func _on_Projectile_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		pierce_counter += 1
		if (pierce_counter > 3):  # can pierce no more than three bodies
			destroy()
