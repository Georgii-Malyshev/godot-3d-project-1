extends Area


var speed : float = 20.0
var damage : int = 15


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move projectile forwards
	translation += global_transform.basis.z * speed * delta


# Called when the collider enters another node's collider
func _on_Projectile_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		destroy()


func destroy():
	queue_free()
