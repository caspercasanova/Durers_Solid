extends ActionLeaf


# add global group type
# weapon / enemy 
@export var group = "null"

func tick(actor: Node, blackboard: Blackboard) -> int:
		
	var delta = blackboard.get_value("delta", 0.0)
	var finished = actor.move_to_target(delta)
	
	if actor.number_of_items_in_ao(group) > 0:
		print('group entered AO')
		return SUCCESS
	
	if finished:
		return SUCCESS
	
	return RUNNING

