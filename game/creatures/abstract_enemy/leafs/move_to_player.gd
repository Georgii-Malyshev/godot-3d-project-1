extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	assert(agent.has_method("move_to_player"))
	agent.move_to_player()
	return succeed()
