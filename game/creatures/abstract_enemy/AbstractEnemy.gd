extends KinematicBody
class_name Creature

# stats
var max_health: int = 100
var movement_speed: float = 2.1
var attack_range: float = 3.0

# state
var current_health: int = max_health setget set_current_health, get_current_health
var distance_to_player: float = 999999
var sees_player: bool = false
var chasing: bool = false
var active_effects: Dictionary = {}

# pathfinding
var current_target_position: Vector3 = Vector3.ZERO
var current_path: Array = []
var currently_toggled_path_node_index: int = 0

# components
onready var nav: Node = get_parent()  # TODO decouple from parent?


func set_current_health(value: int) -> void:
# warning-ignore:narrowing_conversion
	current_health = clamp(value, 0, max_health)


func get_current_health() -> int:
	return current_health


func _physics_process(_delta : float) -> void:
	
	# behavior tree-related
	sees_player = _check_if_player_is_in_sight()
	# TODO calculate only when necessary?
	distance_to_player = _calculate_distance_to_player()
	
	# apply gravity
	var direction: Vector3 = Vector3.ZERO
	direction.y -= GlobalVars.get_global_gravity() * _delta
	move_and_slide_with_snap(direction.normalized(), Vector3.DOWN, Vector3.UP)


func _calculate_distance_to_player() -> float:
	# TODO consider using global_transform.origin of current node
	return translation.distance_to(GlobalVars.get_player_global_position())


func _check_if_player_is_in_sight() -> bool:
	
	var ray_cast : Node = $LineOfSightRayCast
	var fov_overlapping_bodies: Array = $FieldOfViewArea.get_overlapping_bodies()
	
	# check if player is inside FoV area
	for body in fov_overlapping_bodies:
		if body is Player:
			
			# Check if player is in line of sight (not blocked by bodies)

			# adjust position to cast ray to, taking into account the player's height
			var player_global_position: Vector3 = GlobalVars.get_player_global_position()
			var player_height_adjustment := Vector3(0, 1.8, 0)
			var player_global_position_adjusted := (player_global_position + player_height_adjustment)
			
			# convert position to cast ray to to coordinates relative to the raycast node itself
			var player_local_position_adjusted: Vector3 = ray_cast.to_local(player_global_position_adjusted)
			
			ray_cast.set_enabled(true)
			ray_cast.set_cast_to(player_local_position_adjusted)
			
			if ray_cast.is_colliding():
				var collider: Object = ray_cast.get_collider()
				if collider is Player:
					chasing = true
					$ChasingTimer.start()
					return true
			else:
				# player is not in sight, exit function
				return false
	
	# player is not in FOV area, disable ray cast
	ray_cast.set_enabled(false)
	return false


func _move_to_current_target_position() -> void:
	
	if $RecalculateCurrentPathTimer.is_stopped():
		$RecalculateCurrentPathTimer.start()
		_recalculate_current_path()
	
	_move_on_current_path()


func _move_on_current_path() -> void:
	
	# reset movement direction vector
	var direction : Vector3 = Vector3.ZERO
	
	# if current node isn't the last one on the path
	if currently_toggled_path_node_index < current_path.size():
		var pathfinding_direction : Vector3 = (
			current_path[currently_toggled_path_node_index] - global_transform.origin
		)
		# Enemies that don't fly can't move "deliberately" on Y axis, 
		# so discard the Y of their "intended" direction of movement
		pathfinding_direction.y = 0
		direction = direction + pathfinding_direction 
		
		# if close to current node, start using the next node on the path
		if direction.length() < 1:
			currently_toggled_path_node_index += 1
		else:
			# move towards the current node along the direction vector
			move_and_slide_with_snap(direction.normalized() * movement_speed, Vector3.DOWN, Vector3.UP)


func _recalculate_current_path() -> void:
	current_path = nav.get_simple_path(global_transform.origin, current_target_position)
	currently_toggled_path_node_index = 0


func _on_RecalculateCurrentPathTimer_timeout():
	_recalculate_current_path()


func _on_ChasingTimer_timeout():
	chasing = false


func turn_to_player():
	# TODO make it a slow turn, not an instant transformation
	look_at(GlobalVars.get_player_global_position(), Vector3.UP)


func move_to_player() -> void:
	current_target_position = GlobalVars.get_player_global_position()
	_move_to_current_target_position()


func attack_player():
	pass  # Your custom attack mechanics go here


func take_damage(damage):
	set_current_health(current_health - damage)
	if current_health == 0:
		die()


func die():
	# Your custom death mechanics go here
	queue_free()
