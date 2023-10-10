extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.attack_target()
	actor._on_action_label_draw('Attacking Target  ')
	return SUCCESS

