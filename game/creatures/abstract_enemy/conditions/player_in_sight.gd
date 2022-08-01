extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert("sees_player" in agent)
	verified = agent.sees_player
