extends Node
# This is a kind of a "namespace" containig variables that must be accessible
# anywhere in the game using respective getters and setters. 

# Should be added to the project's AutoLoad. 

# Should be called from within the code like so:
# gravity = GlobalVars.get_global_gravity()


# Global gravity to be used where project's default_gravity doesn't apply
# (such as for KinematicBody etc.)
var global_gravity : float = 18.0 setget set_global_gravity, get_global_gravity


func set_global_gravity(value):
	# don't allow changing global gravity
	print("Attempt to change global_gravity value, ignoring.")

func get_global_gravity():
	return global_gravity
