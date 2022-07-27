extends KinematicBody

# stats
var max_health: int = 100
var current_health: int = 100
var movement_speed: float = 2.5
var attack_range: float = 3.0

# pathfinding
var path: Array = []
var path_node_index: int = 0

# behavior tree-related
var sees_player: bool = false
var distance_to_player: float = 99999

# components
onready var nav: Node = get_parent()  # TODO decouple from parent?
# TODO decouple from player?
onready var player: Node = get_node(GlobalVars.get_player_node_path())


func _turn_to_player():
	# TODO make it a slow turn, not an instant transformation
	look_at(GlobalVars.get_player_global_position(), Vector3.UP)


func _check_if_player_is_in_sight() -> bool:
	
	var ray_cast : Node = $LineOfSightRayCast
	var fov_overlapping_bodies: Array = $FieldOfViewArea.get_overlapping_bodies()
	
	# check if player is inside FoV area
	for body in fov_overlapping_bodies:
		if body is Player:
			
			# Check if player is in line of sight (not blocked by bodies)

			# adjust position to cast ray to, taking into account the player's height
			var player_height_adjustment := Vector3(0, 1.8, 0)
			var player_global_position_adjusted := (GlobalVars.get_player_global_position() + player_height_adjustment)
			
			# convert position to cast ray to to coordinates relative to the raycast node itself
			var player_local_position_adjusted : Vector3 = ray_cast.to_local(player_global_position_adjusted)
			
			ray_cast.set_enabled(true)
			ray_cast.set_cast_to(player_local_position_adjusted)
			
			if ray_cast.is_colliding():
				var collider: Object = ray_cast.get_collider()
				if collider is Player:
					return true
			else:
				# player is not in sight, exit function
				return false
	
	# player is not in FOV area, disable ray cast
	ray_cast.set_enabled(false)
	return false

func _move_within_attack_range_to_player() -> void:
	_move_on_path()


func _physics_process(delta : float) -> void:
	sees_player = _check_if_player_is_in_sight()
	var ray_cast : Node = $LineOfSightRayCast  # TODO delete after debug
	#print(ray_cast.is_enabled())  # TODO delete after debug
	distance_to_player = _calculate_distance_to_player()


func _calculate_distance_to_player() -> float:
	# TODO consider using global_transform.origin of current node
	return translation.distance_to(GlobalVars.get_player_global_position())


func _move_on_path() -> void:
	var delta: float = get_physics_process_delta_time()
	
	# reset movement direction vector
	var direction : Vector3 = Vector3.ZERO
	
	# apply gravity
	direction.y -= GlobalVars.get_global_gravity() * delta
	
	if path_node_index < path.size():  # if current node isn't the last one on the path
		var pathfinding_direction : Vector3 = (path[path_node_index] - global_transform.origin)
		# Enemies that don't fly can't move "deliberately" on Y axis, 
		# so discard the Y of their "intended" direction of movement
		pathfinding_direction.y = 0
		direction = direction + pathfinding_direction 
		
		# if close to current node, start using the next node on the path
		if direction.length() < 1:
			path_node_index += 1
		else:
			# move towards the current node along the direction vector
			move_and_slide_with_snap(direction.normalized() * movement_speed, Vector3.DOWN, Vector3.UP)


func _update_path_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node_index = 0


func _attack_player():
	pass  # TODO implement attack mechanics


func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()


func die():
	queue_free()


# TODO rename Timer to something explanatory, use signals only through signal bus
func _on_Timer_timeout():
	_update_path_to(GlobalVars.get_player_global_position())
