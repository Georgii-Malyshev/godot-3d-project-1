extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert(agent.has_method("get_attack_range"))
	assert(agent.has_method("get_distance_to_player"))
	verified = (agent.get_distance_to_player() <= agent.get_attack_range())
