extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	assert(agent.has_method("attack_player"))
	agent.attack_player()
	return succeed()
