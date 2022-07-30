extends Area

var velocity : float = 6.0
var damage : int = 15


func _process(delta):
	# move projectile forwards in a straight line
	translation += global_transform.basis.z * velocity * delta


func _on_Projectile_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()


func destroy():
	queue_free()
