extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert("attack_range" in agent)
	assert("distance_to_player" in agent)
	verified = (agent.distance_to_player <= agent.attack_range)
