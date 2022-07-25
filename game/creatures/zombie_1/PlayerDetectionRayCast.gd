extends RayCast

var target : Player = null
var collider : Object = null


func _physics_process(_delta: float) -> void:
	if is_colliding():
		collider = get_collider()
		if collider is Player:
			target = collider
