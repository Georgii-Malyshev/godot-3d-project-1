extends BTLeaf


func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	   # TODO add assert?
	   # TODO consider "best practice" ways to run agent's action
	   agent.attack_player()  # TODO generalize agent's attack behavior (decouple it from player)?
	   return succeed()  # TODO succeed only when action has finished
