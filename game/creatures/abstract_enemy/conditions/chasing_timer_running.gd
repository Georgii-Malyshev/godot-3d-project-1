extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert(agent.has_method("get_is_chasing"))
	verified = agent.get_is_chasing()
