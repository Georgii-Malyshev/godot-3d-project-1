extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	   # TODO add assert?
	   agent.turn_to_player()
	   return succeed()
