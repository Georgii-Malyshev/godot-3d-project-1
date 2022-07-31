extends Node
# This is a kind of a "namespace" containig variables that must be accessible
# anywhere in the game using respective getters and setters. 

# Should be added to the project's AutoLoad. 

# Should be called from within the code like so:
# gravity = GlobalVars.get_global_gravity()


# Global gravity to be used where project's default_gravity doesn't apply
# (such as for KinematicBody etc.)
var global_gravity : float = 18.0 setget set_global_gravity, get_global_gravity
var player_node_path : NodePath = "/root/Main/Player" setget set_player_node_path, get_player_node_path
var player_global_position : Vector3 =  Vector3.ZERO setget set_player_global_position, get_player_global_position


func set_global_gravity(_value: float) -> void:
	print("Attempt to change global_gravity value, ignoring.")


func get_global_gravity() -> float:
	return global_gravity


func set_player_node_path(_value: NodePath) -> void:
	print("Attempt to set player_node_path, ignoring")


func get_player_node_path() -> NodePath:
	return player_node_path


func set_player_global_position(_value: Vector3) -> void:
	print("Attempt to set player_global_position, ignoring")


func get_player_global_position() -> Vector3:
	return get_node(player_node_path).global_transform.origin
