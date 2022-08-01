extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	assert(agent.has_method("turn_to_player"))
	agent.turn_to_player()
	return succeed()
