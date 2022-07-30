extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert("agitated" in agent)
	verified = agent.agitated
