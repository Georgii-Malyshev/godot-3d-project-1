extends RayCast

var collider : Object = null


func _cast_ray_to_player() -> void:
	var player_local_position : Vector3 = to_local(GlobalVars.get_player_global_position())
	#var player_height_adjustment := Vector3(0, 1.8, 0)
	#self.set_cast_to(player_local_position + player_height_adjustment)
	self.set_enabled(true)
	self.set_cast_to(player_local_position)

	# check if player is in line of sight
	# TODO shouldn't this check be done every frame while the ray is active?
	if is_colliding():
		collider = get_collider()
		if collider is Player:
			print("Ray hit the player")  # TODO call respective logic


func _stop_ray_casting_to_player() -> void:
	self.set_enabled(false)
