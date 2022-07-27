extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	# TODO add asserts?
	# TODO consider "best practice" ways to run agent's action
	# TODO generalize agent's move behavior (decouple it from player)   
	agent.move_to_player()
	return succeed()
