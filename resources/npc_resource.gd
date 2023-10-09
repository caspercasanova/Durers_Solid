extends Resource
class_name Enemy_Resource


enum NPC_TYPE {
	Test,
	Gatherer,
	Trooper, 
	Sniper,
	Engineer,
	Pilot, 
	Commando,
	Commander,
}

# Define the AI type for this resource
var npc_type: NPC_TYPE = NPC_TYPE.Test

enum BUILDINGS {
	HEAD_QUARTERS,
	Factory,
	TOWER,
	BARRACKS,
}



# Colors for different AI types
@export var colors = {
	NPC_TYPE.Test: Color(1, 0, 0), # Grey 
	NPC_TYPE.Gatherer: Color(1, 0, 0),  # Pink
	NPC_TYPE.Trooper: Color(0, 1, 0),  # White
	NPC_TYPE.Sniper: Color(1, 0, 0),  # Green
	NPC_TYPE.Engineer: Color(1, 0, 0),  # Blue
	NPC_TYPE.Pilot: Color(1, 1, 0), # Blue
	NPC_TYPE.Commando: Color(1, 0, 0), # Red
	NPC_TYPE.Commander: Color(0, 0, 1)  # Yellow
}

@export var buildings: BUILDINGS



"""
# Weapon properties
@export var damage: int = 10
@export var fire_rate: float = 1.0  # Shots per second
@export var max_ammo: int = 30

# Internal ammo count
var ammo_count: int = max_ammo

# Timer for controlling the fire rate
var fire_timer: Timer

func _init():
	fire_timer = Timer.new()
	fire_timer.one_shot = false
	fire_timer.wait_time = 1.0 / fire_rate  # Calculate wait time based on fire rate
	fire_timer.connect("timeout", self, "_on_fire_timer_timeout")
	add_child(fire_timer)

func _on_fire_timer_timeout():
	ammo_count -= 1
	if ammo_count <= 0:
		ammo_count = 0
		fire_timer.stop()  # Stop firing if out of ammo

# Function to fire the weapon
func fire():
	if ammo_count > 0 and not fire_timer.is_inside_tree():
		# Perform firing logic here, e.g., deal damage to a target
		fire_timer.start()

# Function to reload the weapon
func reload():
	ammo_count = max_ammo

# Function to check if the weapon has ammo
func has_ammo() -> bool:
	return ammo_count > 0

# Function to get the current ammo count
func get_ammo_count() -> int:
	return ammo_count
"""
