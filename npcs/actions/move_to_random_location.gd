extends ActionLeaf

func get_new_random_Vec3() -> Vector3:
	return Vector3(randi_range(-10, 10), 0.5, randi_range(-10, 10))


func before_run(actor, blackboard):
	if(!actor.navigation_is_synced):
		return
	var rand_vec = get_new_random_Vec3()

	actor.navigation_agent.set_target_position(rand_vec)
	actor.update_debug_text('Todo', 'Action: Moving to random')
	return 


func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var delta = blackboard.get_value("delta", 0.0)
	var finished = actor.move_to_target(delta)
	
	
	if finished:
		return SUCCESS
	
	return RUNNING


