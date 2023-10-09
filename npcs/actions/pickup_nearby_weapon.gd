extends ActionLeaf



func before_run(actor, blackboard):
	if(!actor.navigation_is_synced):
		return
		
	actor.update_debug_text('Todo', 'Action: Pickng Up Nearby Weapon')
	return 


func tick(actor: Node, blackboard: Blackboard) -> int:
	var delta = blackboard.get_value("delta", 0.0)
	var weapon = blackboard.get_value("nearby_weapon")
	if(!weapon):
		print('Failed omg')
		return FAILURE
		
	var finished = actor.move_to_target(delta)
	
	if finished:
		actor.pick_up_weapon(instance_from_id(weapon))
		blackboard.erase_value("nearby_weapon")
		return SUCCESS
	
	return RUNNING

