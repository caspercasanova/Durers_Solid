extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:	
	var array_of_weapons = actor.weapons_in_the_area.keys()
	if array_of_weapons.size() > 0:
		var random_weapon = array_of_weapons[randi() % array_of_weapons.size()]
		actor.set_navigation_agent_target(instance_from_id(random_weapon).global_position)
		blackboard.set_value("nearby_weapon", random_weapon)
		return SUCCESS
	print('No Weapon in area')
	return FAILURE

