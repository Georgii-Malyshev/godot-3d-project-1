extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	   # TODO add assert?
	   agent.attack_player()
	   return succeed()
