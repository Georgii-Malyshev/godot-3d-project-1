extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert("chasing" in agent)
	verified = agent.chasing
