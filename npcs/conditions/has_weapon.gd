extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.has_weapon():
		print('Actor has a weapon')
		return SUCCESS
		
	print('Actor doesnt have a weapon')
	return FAILURE

