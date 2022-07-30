extends BTLeaf

func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	# TODO add asserts?
	agent.move_to_player_last_seen_position()
	return succeed()
