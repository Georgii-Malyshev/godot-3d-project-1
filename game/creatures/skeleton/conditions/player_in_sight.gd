extends BTConditional

# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.


# The condition is checked BEFORE ticking. So it should be in _pre_tick.
func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert("sees_player" in agent)
	verified = agent.sees_player
