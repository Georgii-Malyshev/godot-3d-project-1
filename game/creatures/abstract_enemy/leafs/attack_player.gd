extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	assert(agent.has_method("attack"))
	agent.attack()
	return succeed()
