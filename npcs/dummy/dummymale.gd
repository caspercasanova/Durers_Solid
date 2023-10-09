class_name Dummy extends CharacterBody3D

# https://docs.cryengine.com/display/CEPROG/Behavior+Tree+Blackboard
# https://www.youtube.com/watch?v=rdUgf6r7w2Q
# https://github.com/ValveSoftware/source-sdk-2013/blob/master/sp/src/game/server/hl2/npc_combine.cpp
@export_category('Dummy')
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var condition_label := %ConditionLabel
@onready var action_label := %ActionLabel
@onready var debugging_sprite = %"Action Debugger"
@onready var audio_stream_player: AudioStreamPlayer3D = %AudioStreamPlayer3D
@onready var weapon_parent: Node3D = %Weapon
@onready var area_of_operation: Area3D = %AreaOfOperation

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
# base npc
# https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/ai_basenpc.h#L2713

# https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/ai_basenpc.h#L1092
# solve audio emiters /  signals
# Import Health Resource 
@export_category('Dummy Stats')
@export var debugging = false 
@export var movement_speed: float = 30
@export var acceleration = 10;
@export var jump_velocity: float = 4.5
@export var max_health := 100
#implement mechanics either sprint or shield for this
@export var max_energy := 100
# determine AI cowers and other things
@export var max_chaos := 100 
@export var max_zombification := 100 

@export var melee_range: int = 1;
@export var melee_damage: int = 10


# need to find this once a better model comes
var radius = '902371-23712-37123-98173-1973-1298371-39-13871-39871-3981273'

# because of a bug that occurs with _frame or something. 
# fixable once i learn more about godot loading and preloading
# should bake mesh and wait a second before loading to the map
var navigation_is_synced = false 

var current_health = max_health: set = set_health, get = get_health;
func set_health(new_health):
	current_health = new_health
func get_health():
	return current_health


var current_ammo : int = 10
var ammo_is_low = false


# figure this out 
var current_weapon = null


enum Alert_State {
	IDLE,
	SUSPICIOUS,
	ALERT,
	CHASE,
	ATTACKING,
	RETREATING,
	PANICED
}
var alert_state: Alert_State = Alert_State.IDLE: set = set_alert_state, get = get_alert_state
func set_alert_state(new_state: Alert_State):
	alert_state = new_state
func get_alert_state():
	return alert_state

enum Postures {
	SITTING,
	WALKING,
	CROUCHED,
	RUNNING,
	JUMPING,
	CLIMBING,
	FALLING,
	FLYING,
}
var current_posture: Postures= Postures.SITTING: set = set_posture, get = get_posture;
func set_posture(posture: Postures):
	current_posture = posture
func get_posture():
	return current_posture


var is_in_vehicle := false;

###################################
# Make actions to disable other future actions
###################################



# spatial awareness / short term memory
# creatively clear these
# ENEMY MEMORIES
# clear this after combat sesssion
# this should ephemeral in nature
var homebase = Vector3(0, 0, 0)
var weapons_in_the_area = {}
var group_in_area = {
	"weapon": weapons_in_the_area,
}
var rally_points_in_area = {}
var outposts_in_area = {}
var current_orders = {}

# Senses
# check can see, hear, or knows
var enemy = null
var last_known_location: Vector3 = Vector3(0, 0, 0);
var last_seen_location: Vector3 = Vector3(0, 0, 0);
var last_heard_location: Vector3 = Vector3(0, 0, 0)
var time_last_seen := 0;
var time_first_seen := 0;
var time_last_reacquired := 0;
var timeValidEnemy := 0;
var time_last_received_damage_from = 0;
var hearing_sensitivity = 1.0
var ignore_all_sound = false 

# changes based on class?
enum Target_Priorities {}
# Targeting and Awareness
var current_target : Node = null
# might just mkae this a timer always incrementing
var time_since_last_attack: int = 0;
var time_since_last_damage_taken: int = 0;

# edit these, there are duplicates
var enemy_occluder: Object # The entity my enemy is hiding behind.
var sum_damage: float # How much consecutive damage I've received
var last_damage_time: float # Last time I received damage
var last_player_damage_time: float # Last time I received damage from the player
var last_saw_player_time: float # Last time I saw the player
var last_attack_time: float # Last time that I attacked my current enemy
var last_enemy_time: float
var next_weapon_search_time: float # Next time to search for a better weapon
var is_pending_weapon: String # The NPC should create and equip this weapon.
var ignore_unseen_enemies: bool



# cover systems

# Function to find a cover position for an entity
func find_cover_pos(entity: Object, result: Vector3) -> bool:
	# Your GDScript logic here
	return false

# Function to find a cover position within a radius for an entity
func find_cover_pos_in_radius(entity: Object, goal_pos: Vector3, cover_radius: float, result: Vector3) -> bool:
	# Your GDScript logic here
	return false

# Function to find a cover position based on a sound
func find_cover_pos_from_sound(sound: Object, result: Vector3) -> bool:
	# Your GDScript logic here
	return false

# Function to check if a cover location is valid
func is_valid_cover(cover_location: Vector3, hint: Object) -> bool:
	# Your GDScript logic here
	return false

# Function to check if a shoot position is valid
func is_valid_shoot_position(cover_location: Vector3, node: Object, hint: Object) -> bool:
	# Your GDScript logic here
	return false

# Function to test a shoot position
func test_shoot_position(shoot_pos: Vector3, target_pos: Vector3) -> bool:
	# Your GDScript logic here
	return false

# Function to check if a position is a cover position
func is_cover_position(threat: Vector3, position: Vector3) -> bool:
	# Your GDScript logic here
	return false

# Function to get the cover radius
func cover_radius() -> float:
	return 1024.0  # Default cover radius

# Function to get the maximum tactical lateral movement
func max_tactical_lateral_movement() -> float:
	return 0.0  # Replace with your desired value


func NotifyFriendsOfDamage():
	# look this up on github
	return




# Group Dynamics - Roles and Tactics
var current_role: String = 'implement this type'




# DEBUGGING methods eventually move these 
func _on_condition_label_draw(condition  = "null") -> void:
	condition_label.text = condition
	pass # Replace with function body.

func _on_action_label_draw(action = "null") -> void:
	action_label.text = action
	pass # Replace with function body.

func update_debug_text(condition, action):
	_on_condition_label_draw(condition)
	_on_action_label_draw(action)


func _ready() -> void:
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	print(navigation_agent)
	# navigation_agent.path_desired_distance = 0.5
	# navigation_agent.target_desired_distance = 0.5
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	navigation_is_synced = true
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	


func _physics_process(_delta):
	# can eventually add the -y when flying 
	# plus parachute action
	return

func set_navigation_agent_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

var num_of_consecutive_nav_path_failures := 0: set = set_num_of_consecutive_nav_path_failures, get = get_num_of_consecutive_nav_path_failures;
func set_num_of_consecutive_nav_path_failures(pathfails):
	num_of_consecutive_nav_path_failures = pathfails
func get_num_of_consecutive_nav_path_failures():
	return num_of_consecutive_nav_path_failures

func find_spot_for_NPC_in_radius(startPos: Vector3, radius: float, npc: Node, outOfPlayerViewcone: bool = false) -> Vector3:
	# gpt generated, not tested
	var result: Vector3 = Vector3.ZERO
	# Implement the logic to find the spot here
	# You can use RayCast2D or other collision detection methods to check for valid spots
	
	# For demonstration, let's assume we find a spot 2 units away from the start position
	result = startPos + Vector3(randf(), randf(), randf()).normalized() * radius
	return result
	



func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()


func move_to_target(delta) -> bool:
	if !navigation_is_synced:
		return false
		
	if navigation_agent.is_navigation_finished():
		return true
	

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
	
	if(!debugging):
		print('Can reach target:  ', navigation_agent.is_target_reachable())
		print('Navigation target:  ', navigation_agent.target_position)
		print("Distance to target:  ", navigation_agent.distance_to_target())
		print('Next_path_position:  ', next_path_position )
		print('Global Position:  ', global_position)
		print('Current Velocity ', new_velocity)
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
	return false


func _on_area_of_operation_body_entered(body: Node3D) -> void:
	if(!navigation_is_synced):
		return	
	if body.is_in_group("weapon"):
		print('Added a body to the weapons array')
		weapons_in_the_area[body.get_instance_id()] = true
		print(weapons_in_the_area)


func _on_area_of_operation_body_exited(body: Node3D) -> void:
	if(!navigation_is_synced):
		return
	if body.is_in_group("weapon") && weapons_in_the_area.has(body.get_instance_id()):
		print('Erasing a weapon in the area')
		weapons_in_the_area.erase(body.get_instance_id())
		print(weapons_in_the_area)
	






func is_alive():
	return current_health > 0

func light_damage_taken():
	return current_health <= max_health * 0.8

func medium_damage_taken():
	return current_health <= max_health * 0.6
	
func heavy_damage_taken():
	return current_health <= max_health * 0.30

func critical_damage_taken():
	return current_health <= max_health * 0.10

func react_to_damage_taken():
	pass



func get_active_weapon():
	if(!self.has_weapon()):
		print('error: get_active_weapon i dont have a weapon')
	return weapon_parent.get_child(0)

func set_active_weapon(weapon: Node3D):
	pass

func has_weapon():
	return weapon_parent.get_child_count() > 0

func number_of_items_in_ao(group):
	return group_in_area[group].size()
	
func pick_up_weapon(weapon: Node3D):
	weapon_parent.add_child(weapon)
	current_weapon = weapon
	current_weapon.global_position = weapon_parent.global_position
	return 

func drop_weapon():
	#spawn weapon into battle field ? 
	weapon_parent.remove_children()
	current_weapon = null;
	return 



func take_damage(damage: float, attacker: Node) ->void:
	current_health -= damage
#	https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/baseentity.cpp#L1444
	if current_health <= 0:
		if attacker.has_method("killed_unit"):
			attacker.killed_unit()
		else: 
			print('Attacker does not have the method: "killed_unit"', attacker)
		die()



func spawn_gibs():
	pass 

func die() -> void:
	queue_free()


func is_in_range(pos1: Vector3, pos2: Vector3, threshold: float) -> bool:
	return pos1.distance_to(pos2) <= threshold

func attack_range():
	# this is a value derived by the weapon being held
	# no weapon = 1 meter range for melee
	pass

func should_attack_target() -> bool:
	# Define the conditions for attacking a target (e.g., when in close range)
	return false

func perform_melee():
	print("I am Performing Melee")
	# if melee hits play hit sounds
	# play miss sound
	return

func should_melee() -> bool: 
	if !target_node_is_close(current_target, melee_range): 
		return false
	if current_ammo != 0: 
		return false
	return true

func shoot_at_target(target: Node3D):
	print('Shoooting')
	pass





func get_all_current_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("I collided with ", collision.get_collider().name)

func target_node(target_node: Node) -> void:
	target_node = target_node
	return 


func find_cover():
	# get nearby cover nodes
	# run to cover node
	# take cover
	print("I am running to cover")
	print("I am in cover")
	return 

# dont like this function, should be AO instead of entire tree
func find_nearest_node_of_type(target_type: String, max_distance: float = 99999.0):
	# Iterate through all nodes in the scene
	var max_d = max_distance
	var nearest_distance = 0
	var nearest_node = null
	
	for node in get_tree().get_nodes_in_group(target_type):
			var distance = global_transform.origin.distance_to(node.global_transform.origin)
	
			# Update the nearest node if a closer one is found
			if distance < max_d:
				nearest_distance = distance
				nearest_node = node
				
	# Check if a nearest node was found
	if nearest_node:
		print("Nearest node of type ", target_type, " is: ", nearest_node)
	else:
		print("No node of type ", target_type, " found.")



# Function to check if the target node is close based on a distance threshold
func target_node_is_close(target_node: Node, distance_threshold: float) -> bool:
	if(!target_node): 
		return false
	var distance = self.global_transform.origin.distance_to(target_node.global_transform.origin)
	if distance <= distance_threshold:
		return true
	else:
		return false



# helper navigation functions
func should_chase_current_target() -> bool:
	# Define the conditions for chasing a target (e.g., when a player is nearby)
	if !current_target:
		return false
	var should = target_node_is_close(current_target, 10)
	return should

func chase_target(target: Node3D, delta: float) -> void:
	# Implement logic to chase the target (e.g., move towards the target's position)
	# a move to target?  
	pass


func target_valid():
	# this seems like a debugging method
	# Implement logic to check if the target is valid (e.g., check if the target is a player)
	# return is_instance_valid(target)
	pass

func get_random_vector(xrange = 5.0, yrange = 5.0, zrange = 5.0) -> Vector3:
	return Vector3(randf_range(-xrange, xrange), randf_range(-yrange, yrange), randf_range(-zrange, zrange))


func attack_target(target: Node3D) -> void:
	# Implement logic to attack the target (e.g., reduce the target's health)
	if target.has_method("take_damage"):
		target.take_damage(melee_damage)
	else: 
		print('This enemy doesnt have a take_damage method')
	pass

func target_is_visible(target: Node3D) -> bool:
	# Implement logic to check if the target is visible
	return true

func target_is_in_range(target: Node3D) -> bool:
	# Implement logic to check if the target is in attack range
	return true

func move_towards_target():
	# Implement logic to move towards the target
	pass

func perform_attack():
	# Implement the attack logic
	pass



func reload_weapon(next_magazine_ammo: int):
	# get weapon 
	# perform reload anim
	current_ammo += next_magazine_ammo
	return

func should_reload_weapon():
	if alert_state < Alert_State.ATTACKING && ammo_is_low:
		return true
		
	# use a hueristic for #of enemies nearby and
	return false
		

func should_retreat() -> bool:
	# Define the conditions for retreating
	# no orders || local units 
	return current_orders.length == 0 

func can_retreat(max_retreat_distance: float):
	return outposts_in_area.size() > 0

func retreat():
	# get nearest outpost location
	print('I am retreating')
	set_navigation_agent_target(homebase)
	return

func panic(): 
	#play panic and screen animations
	drop_weapon()
	retreat()



func create_drop_zone(location: Vector3) :
	# this will be were different items can be dropped by helicopters
	# return an RID
	# just a different flight path than landing zone
	return  

func delete_drop_zone() -> void:
	return
	
func create_landing_zone(location: Vector3):
	# this will be for evac of high value personel 
	# return an RID
	return 
	
func delete_landing_zone() -> void:
	return

func create_area_of_interest() -> Area3D:
	# create area of interest when unit dies, or some some discovery is made
	return 
func delete_area_of_interest() -> void:
	return 


func get_up():
	pass

func get_pushed(force: int):
	pass

func get_thrown(force: int):
	pass

func pick_up_item():
	pass
	
func use_item():
	pass

func drop_item():
	pass

func inspect_random_nearby_item():
	pass

func sit_on_chair():
	pass

func killed_unit():
	# play random kill sound:
	# tally one KIA 
	pass

func healed_unit():
	# play a sound
	# Lets get back in there
	# tally one 
	pass





const AUTO_AIM_2_DEGREES = 0.0348994967025
const AUTO_AIM_5_DEGREES = 0.08715574274766
const AUTO_AIM_8_DEGREES = 0.1391731009601
const AUTO_AIM_10_DEGREES = 0.1736481776669
const AUTO_AIM_20_DEGREES = 0.3490658503989

# Useful cosines
const DOT_1_DEGREE = 0.9998476951564
const DOT_2_DEGREE = 0.9993908270191
const DOT_3_DEGREE = 0.9986295347546
const DOT_4_DEGREE = 0.9975640502598
const DOT_5_DEGREE = 0.9961946980917
const DOT_6_DEGREE = 0.9945218953683
const DOT_7_DEGREE = 0.9925461516413
const DOT_8_DEGREE = 0.9902680687416
const DOT_9_DEGREE = 0.9876883405951
const DOT_10_DEGREE = 0.9848077530122
const DOT_15_DEGREE = 0.9659258262891
const DOT_20_DEGREE = 0.9396926207859
const DOT_25_DEGREE = 0.9063077870367
const DOT_30_DEGREE = 0.866025403784
const DOT_45_DEGREE = 0.707106781187






"""

FLOT - Forward Line of Own Troops: This is an imaginary line that represents the most forward positions of friendly forces on the battlefield.

MLR - Main Line of Resistance: This is a line that indicates the primary defensive position of a military unit.

LOC - Line of Contact: This term is used to describe the line that separates opposing military forces in close proximity to each other, especially in a fluid battlefield situation.

FOB - Forward Operating Base: A FOB is a secured forward military position where troops and equipment are stationed for operations in a specific area.

COP - Combat Outpost: Similar to a FOB, a COP is a smaller, temporary military position used for combat operations.

AO - Area of Operations: This term refers to a designated geographic area where military operations are conducted.

AOI - Area of Interest: This is a broader geographic area that military planners and commanders are concerned with, which may include the AO and surrounding regions.

MOA - Military Operations Area: In the context of aviation and airspace, this term designates a specific airspace area where military aircraft conduct training or operational activities.

LZ - Landing Zone: A designated area where helicopters or other aircraft can land troops or equipment.

DZ - Drop Zone: An area where airborne troops or supplies are airdropped from aircraft.







get random area next to node
   var screenSize = get_viewport().get_visible_rect().size
   var rng = RandomNumberGenerator.new()
   var rng2 = RandomNumberGenerator.new()
   var rng3 = RandomNumberGenerator.new()
   var rng4 = RandomNumberGenerator.new()
   var rndX = rng.randi_range(0, screenSize.x)
   var rndY = rng.randi_range(0, screenSize.y)
   var rndX2 = rng2.randi_range(0, screenSize.x)
   var rndY2 = rng2.randi_range(0, screenSize.y)
   var rndX3 = rng3.randi_range(0, screenSize.x)
   var rndY3 = rng3.randi_range(0, screenSize.y)
   var rndX4 = rng.randi_range(0, screenSize.x)
   var rndY4 = rng.randi_range(0, screenSize.y)

   $Area2D.position = Vector2(rndX, rndY)
   $Area2D2.position = Vector2(rndX2, rndY2)
   $Area2D3.position = Vector2(rndX3, rndY3)
   $Area2D.position = Vector2(rndX4, rndY4)

func _on_Timer_timeout():

   var rng = RandomNumberGenerator.new()
   var nextToggleSeconds = rng.randi_range(5, 15) 

   $Area2D.visible = !$Area2D.visible # switch visibility
   $Area2D2.visible = !$Area2D2.visible
   $Area2D3.visible = !$Area2D3.visible
   $Area2D3.visible = !$Area2D4.visible
   $Timer.start(nextToggleSeconds)



# Shooter

# Behvaior Tree Functions
func reload_weapon():
	# Implement logic to reload the weapon
	ammo_count = 10  # Assuming a magazine size of 10


func shoot_at_target(target: Node):
	# Implement logic to shoot at the target
	ammo_count -= 1
	# You may need to implement shooting mechanics here


func should_chase_target() -> bool:
	# Define the conditions for chasing the target
	return target_is_visible() and not target_is_in_range()

func should_attack_target() -> bool:
	# Define the conditions for attacking the target
	return target_is_visible() and target_is_in_range()



func ammo_is_low() -> bool:
	# Implement logic to check if the AI's ammo is low
	return false


# Medic
enum AIState { IDLE, HEAL, FOLLOW, RETREAT }
func should_heal_target() -> bool:
	# Define the conditions for healing the target
	return target_is_visible() and target_needs_healing()

func should_follow_target() -> bool:
	# Define the conditions for following the target
	return target_is_visible() and not target_needs_healing()


func target_needs_healing() -> bool:
	# Implement logic to check if the target needs healing
	return true

func heal_target():
	# Implement healing logic
	pass

func follow_target():
	# Implement logic to follow the target
	pass



# Commander Unit 
var units_under_command : Array = []
enum AIState { IDLE, MOVE_TO_POSITION, ATTACK_ENEMY }
func should_move_to_position() -> bool:
	# Define the conditions for moving to a position
	return not at_destination()

func should_attack_enemy() -> bool:
	# Define the conditions for attacking enemies
	return enemy_units_detected()

func at_destination() -> bool:
	# Implement logic to check if units have reached the destination
	return true

func move_units_to_position(target_position: Vector2):
	# Implement logic to issue movement orders to units
	pass

func enemy_units_detected() -> bool:
	# Implement logic to detect enemy units
	return true

func attack_enemy_units():
	# Implement logic to issue attack orders to units
	pass







# Define your Engineer variables here
enum AIState { IDLE, REPAIR, CONSTRUCT }
var target_building : Building = null
var target_location : Vector2 = Vector2(0, 0)

func should_repair() -> bool:
	# Define the conditions for repairing a building
	return target_building_needs_repair()

func should_construct() -> bool:
	# Define the conditions for constructing a building
	return target_location_valid()

func target_building_needs_repair() -> bool:
	# Implement logic to check if the target building needs repair
	return true

func target_location_valid() -> bool:
	# Implement logic to check if the target location for construction is valid
	return true

func repair_building(building: Building):
	# Implement logic to repair the target building
	pass

func construct_building(location: Vector2):
	# Implement logic to construct a building at the specified location
	pass


# sniper class
enum AIState { IDLE, SEARCH_FOR_TARGET, AIM_AT_TARGET, SHOOT_TARGET }
func should_search_for_target() -> bool:
	# Define the conditions for searching for a target
	return not found_valid_target()

func should_aim_at_target() -> bool:
	# Define the conditions for aiming at a target
	return found_valid_target() and not should_shoot_target()

func should_shoot_target() -> bool:
	# Define the conditions for shooting at a target
	return found_valid_target() and is_target_in_sight()

func found_valid_target() -> bool:
	# Implement logic to check if a valid target is found
	return target != null  # You may need more complex logic here

func no_valid_target() -> bool:
	# Implement logic to check if there's no valid target
	return not found_valid_target()

func search_for_targets():
	# Implement logic to move or search for targets
	pass

func aim_at_target(target: Node):
	# Implement logic to aim at the target
	pass

func shoot_at_target(target: Node):
	# Implement logic to shoot at the target
	pass

func is_target_in_sight() -> bool:
	# Implement logic to check if the target is in the sniper's line of sight
	return true  # You may need to implement raycasting or other methods


## radio man 
enum AIState { IDLE, MOVE_TO_POSITION, CALL_FOR_SUPPORT }
var support_position : Vector2 = Vector2(0, 0)


func should_move_to_position() -> bool:
	# Define the conditions for moving to a support position
	return not at_destination()

func should_call_for_support() -> bool:
	# Define the conditions for calling for support
	return support_needed()

func at_destination() -> bool:
	# Implement logic to check if the radioman has reached the destination
	return true

func move_to_position(position: Vector2):
	# Implement logic to move to the specified position
	pass

func support_needed() -> bool:
	# Implement logic to check if support is needed
	return true

func call_for_support():
	# Implement logic to call for support, such as sending a signal or message
	pass



# Pilot Class 

enum AIState { IDLE, TAKEOFF, FLY_TO_TARGET, ATTACK_TARGET, LAND }
# Define your AI's variables here
var current_state : AIState = AIState.IDLE
var target : Node = null
var target_position : Vector3 = Vector3(0, 0, 0)

func _process(delta):
	# Call the behavior tree here
	update_behavior_tree()

func update_behavior_tree():
	match current_state:
		AIState.IDLE:
			if should_takeoff():
				current_state = AIState.TAKEOFF
			else:
				# Perform idle actions
				pass

		AIState.TAKEOFF:
			if should_fly_to_target():
				current_state = AIState.FLY_TO_TARGET
			elif at_target_altitude():
				current_state = AIState.IDLE
			else:
				# Perform takeoff actions
				perform_takeoff()

		AIState.FLY_TO_TARGET:
			if should_attack_target():
				current_state = AIState.ATTACK_TARGET
			elif not target_valid():
				current_state = AIState.IDLE
			else:
				# Fly to the target
				fly_to_target(target_position)

		AIState.ATTACK_TARGET:
			if not target_valid():
				current_state = AIState.IDLE
			else:
				# Attack the target
				attack_target(target)

		AIState.LAND:
			if at_target_altitude():
				current_state = AIState.IDLE
			else:
				# Perform landing actions
				perform_landing()

func should_takeoff() -> bool:
	# Define the conditions for taking off
	return not at_target_altitude()

func should_fly_to_target() -> bool:
	# Define the conditions for flying to a target
	return target_valid() and not should_attack_target()

func should_attack_target() -> bool:
	# Define the conditions for attacking a target
	return target_valid()

func at_target_altitude() -> bool:
	# Implement logic to check if the pilot is at the target altitude
	return true

func perform_takeoff():
	# Implement logic to perform takeoff actions
	pass

func fly_to_target(target_position: Vector3):
	# Implement logic to fly to the specified target position
	pass

func target_valid() -> bool:
	# Implement logic to check if the target is valid
	return target != null

func attack_target(target: Node):
	# Implement logic to attack the target
	pass

func perform_landing():
	# Implement logic to perform landing actions
	pass




# Commando
enum AIState { IDLE, INFILTRATE, SABOTAGE, ESCAPE }

var current_state : AIState = AIState.IDLE
var target : Node = null
var escape_point : Vector2 = Vector2(0, 0)


func should_infiltrate() -> bool:
	# Define the conditions for infiltration
	return not target_valid()

func should_sabotage() -> bool:
	# Define the conditions for sabotage
	return target_valid()

func should_escape() -> bool:
	# Define the conditions for escape
	return sabotage_complete()

func infiltrate_target():
	# Implement logic to infiltrate the target area
	pass

func sabotage_target(target: Node):
	# Implement logic to sabotage the target
	pass

func escape_to_point(point: Vector2):
	# Implement logic to escape to the designated point
	pass

func target_valid() -> bool:
	# Implement logic to check if the target is valid
	return target != null

func sabotage_complete() -> bool:
	# Implement logic to check if sabotage is complete
	return true


"""






