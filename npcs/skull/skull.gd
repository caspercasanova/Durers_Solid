extends Node3D
"""
https://blog.rubenwardy.com/2022/07/17/game-ai-for-colonists/

Command AI
worker_state- build next highest prior- ity building
	resource_nodes
	offensive
	defensive 
	storage
	communications - request next order
	
gather_state - navigate to gold -> gather gold -> return gold to storage
explore_state - perform sortie and cache last scene enemy location and return to base 
attack_state - 
	- last known attack enemy command center
	- last known attack enemy resource node
	- move to last known enemy position 
defense_state - need to research this 
	- if CC under 25% return all troops to base area?
	- if CC under 50% return heavy units to base area?
	- if CC under 90% return light units to base area?
retrieve pilot
	- 
	


gold: int = 100
workers = []

Unit AI: 
	Run To Location
	Get Orders 
		- Goes to Communications array and gets updates Blackboard
	Attack
		- Player Spotted? 
			- Run cover
				- Attack
				- Blind Fire
			- Player close?
				- Fire Weapon 
				- Melee 
		- Find high ground 
		- Unit is in frame
		- last scene frame for .5s 
	Panic 
		- navigate to CC_Area and roam 
		- if health == 100 panic = false
	Wander
	Patrol - Walk
	Reload
	Link_Up
		- if !current squad 
		
	under_fire - attack or find cover
	in_dark - use flash light
	is_dying - 5 seconds 
		- call for medic - checks for medic in area and extends the is is_dying for 10 seconds
	is_zombie
		- find nearest enemy 
		- find last sound
		- go catatonic
	is_pilot - chance on spawned from a helicopter 
		- returns to base
	needs_radio:
	can_assist 
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
