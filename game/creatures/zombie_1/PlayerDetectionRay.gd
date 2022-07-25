extends RayCast

var collider: Object = null


func _cast_ray_to_player() -> void:
	self.set_enabled(true)
	var player_local_position : Vector3 = to_local(GlobalVars.get_player_global_position())
	var player_height_adjustment := Vector3(0, 1.8, 0)
	self.set_cast_to(player_local_position + player_height_adjustment)

	if is_colliding():
		collider = get_collider()
		if collider is Player:
			SignalBus.emit_signal(
				"player_detected_by_ray", self, collider.translation
				)


func _disable_ray_cast_to_player() -> void:
	self.set_enabled(false)
