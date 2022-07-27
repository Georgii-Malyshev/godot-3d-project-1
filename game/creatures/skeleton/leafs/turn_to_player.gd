extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	   # TODO add assert?
	   # TODO consider "best practice" ways to run agent's action
	   agent._turn_to_player()
	   return succeed()  # TODO succeed only when action has finished
