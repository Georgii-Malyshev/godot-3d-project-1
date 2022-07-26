extends BTConditional

# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.

# If you want to know the result of the condition, store in the blackboard
# during _pre_tick().

# The condition is checked BEFORE ticking. So it should be in _pre_tick.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	# TODO replace with actual condition checking
	assert("sees_player" in agent)
	verified = agent.sees_player
	print(verified)
