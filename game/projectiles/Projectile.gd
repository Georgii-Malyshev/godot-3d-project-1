extends Area


var velocity : float = 6.0
var damage : int = 15


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move projectile forwards in a straight line
	translation += global_transform.basis.z * velocity * delta


# Called when the collider enters another node's collider
func _on_Projectile_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()


func destroy():
	queue_free()
