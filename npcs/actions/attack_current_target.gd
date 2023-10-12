extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var npc := actor as Dummy
	is_instance_of(npc, Dummy)
	npc.attack_target()
	npc._on_action_label_draw('Attacking Target  ')
	return SUCCESS

