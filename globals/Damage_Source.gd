extends Node
class_name Damage_Source


# _could make this entire file a flat entity ....

# [] apply physics to items
# [] apply affixs to items: burning box & acid bullets



# REMEMBER DAMAGE_SOURCE is super generic and should remain so, mold things around it 
# https://www.youtube.com/watch?v=oIrvZDDWxhU

# https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/server/baseentity.cpp#L1444
# Inflictor is the weapon or rocket (or player) that is dealing the damage.
# Weapon is the weapon that did the attack.
# For hitscan weapons, it'll be the same as the inflictor. For projectile weapons, the projectile 
# is the inflictor, and this contains the weapon that created the projectile.
# Attacker is the character who originated the attack (like a player or an AI).
var inflictor : Object = null 
var weapon : Weapon_Types = 0
# damage_source_stat might be a better option to cover here?
var attacker : Object = null
var damage : float = 0.0
var base_damage : float = 0.0
var max_damage : float = 0.0
var damage_bonus : float = 0.0
var damage_force : Vector3 = Vector3(0, 0, 0)
var damage_position : Vector3 = Vector3(0, 0, 0)
var damage_type : Damage_Types = 0
var damage_custom : int = 0
# interesting?
var damage_stats : int = 0
# probably dont need this, ammos themselves update the damage? but maybe needed for the size of the object?
var ammo_type : AmmoType = null
var player_penetration_count : int = 0
var damaged_other_players : int = 0
var reported_position : Vector3 = Vector3(0, 0, 0)
var force_friendly_fire : bool = false
var phys_pushscale = 1
var mass: int = 0;


func _init(
	_inflictor: Object = null,
	_weapon: Weapon_Types = 0,
	_attacker: Object = null,
	_damage: float = 0.0,
	_base_damage: float = 0.0,
	_max_damage: float = 0.0,
	_damage_bonus: float = 0.0,
	_damage_force: Vector3 = Vector3(0, 0, 0),
	_damage_position: Vector3 = Vector3(0, 0, 0),
	_damage_type: Damage_Types = Damage_Types.GENERIC,
	_damage_custom : int= 0,
	_damage_stats: int = 0,
	_ammo_type: AmmoType = null,
	_player_penetration_count: int = 0 ,
	_damaged_other_players: int = 0,
	_reported_position: Vector3 = Vector3(0,0,0),
	_force_friendly_fire: bool = false,
	_phys_pushscale: int = 1,
	_mass: int = 0,
) -> void:
	inflictor = _inflictor
	weapon = _weapon
	attacker = _attacker
	damage = _damage
	base_damage = _base_damage
	max_damage = _max_damage
	damage_bonus = _damage_bonus
	damage_force = _damage_force
	damage_position = _damage_position
	damage_type = _damage_type
	damage_custom = _damage_custom
	damage_stats = _damage_stats
	ammo_type = _ammo_type
	player_penetration_count = _player_penetration_count
	damaged_other_players = _damaged_other_players
	reported_position = _reported_position
	force_friendly_fire = _force_friendly_fire
	phys_pushscale = _phys_pushscale
	mass = _mass
	return



#print("Inflictor: ", p_inflictor)
#print("Attacker: ", p_attacker)
#print("Weapon: ", p_weapon)
#print("Damage Force: ", damage_force)
#print("Damage Position: ", damage_position)
#print("Damage Amount: ", fl_damage)
#print("Damage Type: ", bits_damage_type)
#print("Kill Type: ", i_kill_type)
#print("Reported Position: ", reported_position)


# this would do side effects from bullets 
#func add_multi_damage(info: Damage_Source, entity: Object) -> void:
#	if entity == null:
#		return
#
#	if entity != g_multi_damage.target:
#		apply_multi_damage()
#		g_multi_damage.init(
#			entity,
#			info.get_inflictor(),
#			info.get_attacker(),
#			info.get_weapon(),
#			Vector3(0, 0, 0),
#			Vector3(0, 0, 0),
#			Vector3(0, 0, 0),
#			0.0,
#			info.get_damage_type(),
#			info.get_damage_custom()
#		)
#
#	g_multi_damage.add_damage_type(info.get_damage_type())
#	g_multi_damage.set_damage(g_multi_damage.get_damage() + info.get_damage())
#	g_multi_damage.set_damage_force(g_multi_damage.get_damage_force() + info.get_damage_force())
#	g_multi_damage.set_damage_position(info.get_damage_position())
#	g_multi_damage.set_reported_position(info.get_reported_position())
#	g_multi_damage.set_max_damage(max(g_multi_damage.get_max_damage(), info.get_damage()))
#	g_multi_damage.set_ammo_type(info.get_ammo_type())
#
#	if g_multi_damage.get_player_penetration_count() == 0:
#		g_multi_damage.set_player_penetration_count(info.get_player_penetration_count())
#
#	var has_physics_force_damage = not g_game_rules.damage_no_physics_force(info.get_damage_type())
#
#	if has_physics_force_damage and g_multi_damage.get_damage_type() != DMG_GENERIC:
#		if g_multi_damage.get_damage_force() == Vector3(0, 0, 0) or g_multi_damage.get_damage_position() == Vector3(0, 0, 0):
#			var warning_count = 0
#
#			if warning_count < 10:
#				if g_multi_damage.get_damage_force() == Vector3(0, 0, 0):
#					print("AddMultiDamage: g_multi_damage.get_damage_force() == Vector3(0, 0, 0)")
#				if g_multi_damage.get_damage_position() == Vector3(0, 0, 0):
#					print("AddMultiDamage: g_multi_damage.get_damage_position() == Vector3(0, 0, 0)")
#
#				warning_count += 1
#






# possibly move these to the character instead
static func fromBullet(bullet: Damage_Source.Bullet, vec_bullet_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0) -> Damage_Source:
	# we shouldnt instiate a new bullet i dont think. 
	var dmg_src = Damage_Source.new()
	
	# data mutation but its fine
	calculate_bullet_damage_force(dmg_src, bullet, vec_force_origin, vec_force_origin, fl_scale)
	
	
	return dmg_src

static func fromMelee() -> Damage_Source:
	return Damage_Source.new()

static func fromProjectileWeapon() -> Damage_Source:
	return Damage_Source.new()

static func fromBlast() -> Damage_Source:
	return Damage_Source.new()

static func fromRayCastWeapon() -> Damage_Source:
	return Damage_Source.new()

static func fromPhysicsWeapon() -> Damage_Source:
	return Damage_Source.new()

static func fromSpell() -> Damage_Source:
	return Damage_Source.new()


# PLAYER / NPC SHIT
func take_damage(damage_source: Damage_Source):
	return

func react_to_damage(damage_source: Damage_Source):
	return
	
	


class Bullet extends RigidBody3D:
	var bullet_type: Bullet_Types = Bullet_Types.STANDARD
	var projectile_weapon: Projectile_Weapons = Projectile_Weapons.SEMI_AUTO_SECONDARY
	var size: Vector3
	var origin: Vector3
	var attacker: Object
#	func _init(_bullet_type):
#		bullet_type = _bullet_type
#		pass
	# return ammo sizes for all projectile weapons
	func get_projectile_weapon_defs(projectile_weapon: Projectile_Weapons) -> Vector3:
		match projectile_weapon:
			Projectile_Weapons.SEMI_AUTO_SECONDARY:
				return Vector3(1, 1, 1)
			Projectile_Weapons.AUTO_SECONDARY:
				return Vector3(2, 2, 2)
			Projectile_Weapons.AR:
				return Vector3(3, 3, 3)
			Projectile_Weapons.SMG:
				return Vector3(4, 4, 4)
			Projectile_Weapons.LMG:
				return Vector3(5, 5, 5)
			Projectile_Weapons.MMG:
				return Vector3(6, 6, 6)
			Projectile_Weapons.HMG:
				return Vector3(7, 7, 7)
			Projectile_Weapons.SHOTGUN:
				return Vector3(8, 8, 8)
			Projectile_Weapons.SNIPER:
				return Vector3(9, 9, 9)
			Projectile_Weapons.BAZOOKA:
				return Vector3(10, 10, 10)
			Projectile_Weapons.MINIGUN:
				return Vector3(11, 11, 11)
			Projectile_Weapons.CANNON:
				return Vector3(12, 12, 12)
			Projectile_Weapons.MORTAR:
				return Vector3(13, 13, 13)
			_:
				return Vector3(0, 0, 0)



class Blast extends Area3D:
	var size: Vector3
	var origin: Vector3
	var attacker: Object
	var explosive_device: Explosive_Devices = Explosive_Devices.SMOKE_GRENADE

class Rocket:
	var rocket_type: Rocket_Types = Rocket_Types.STANDARD


class Projectile_Weapon extends RigidBody3D: 
	var projectile_weapon: Projectile_Weapons = Projectile_Weapons.SEMI_AUTO_SECONDARY
	
class Physics_Weapon:
	var physics_weapon: Physics_Weapons = Physics_Weapons.FLAME_THROWER

class Ray_Cast_Weapon:
	var ray_cast_weapon: Ray_Cast_Weapons = Ray_Cast_Weapons.CHAOS_GUN

class Melee_Weapon:
	var melee_weapon: Melee_Weapons = Melee_Weapons.FIST


enum Weapon_Types {
	Projectile_Weapons, # projectile -> bullets
	Phyics_Weapons,     # physics weap -> trail effect
	Ray_Cast_Weapons,   # raycast -> different ray types
	Melee_Weapons,      # melee -> raw damage 
	none = -1,          # idk the use yet?
	debug = -2          # debuggin
}



# https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/shared/basecombatweapon_shared.h#L283
# https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/physics_impact_damage.h#L54
# https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/shared/takedamageinfo.h#L24
# https://www.youtube.com/watch?v=oIrvZDDWxhU
enum Damage_Types {
	GENERIC = 0,
	CRUSH,  #	crushed by falling or moving object.
			#	NOTE: It's assumed crush damage is occurring as a result of physics collision,
			#	so no extra physics force is generated by crush damage.
			#	DON'T use DMG_CRUSH when damaging entities unless it's the result of a physics collision.
			#	You probably want DMG_CLUB instead.
	BULLET, # shot
	SLASH,  # slash, clawed, stabbed
	BURN,	# heat burned
	VEHICLE, # hit by vehicle
	FALL,	# fell to floor
	BLAST,  # explosive blast
	CLUB,   # crowbar headbut punch
	SHOCK,  # electric shock
	SONIC, 	# sound pulse shockwave
	ENERGYBEAM, # high energy
	PREVENT_PHYSICS_FORCE, # prevent physics force
	NEVERGIB, # 
	ALWAYSGIB, # 
	DROWN, # drown - heals over time like drowning damage
	PARALYZE, # slows affected down
	NERVEGAS, # nerve toxins
	POISON,   # blood poisoning - heals over time like drowning damage
	RADIATION, # radiation exposure
	DROWNRECOVER, # drowning recovery 
	ACID, # toxic chemicals or acid burns
	SLOWBURN, # in an oven
	REMOVE_NO_RAGDOLL, # with this bit OR'd in, no ragdoll will be created, and the target will be quietly removed. use this to kill an entity that you've already got a server-side ragdoll for
	PHYSGUN, # Hit by manipulator. Usually doesn't do any damage.
	PLASMA, # Shot by Cremator
	DISSOLVE, # dissolving 
	BLAST_SURFACE, # A blast on the surface of water that cannot harm things underwater
	DIRECT,
	BUCKSHOT, # not quite a bullet. Little, rounder, different
};


enum Equipment {
	RADIO,
	GRAPPLE_GUN,
	PARACHUTE, 
	MED_KIT,
	ARMOR_KIT,
	AMMO_POUCH, 
	RANGE_FINDER,
	LAPTOP,
	FLASHLIGHT,
	EXOSKELETON, # would be dope
}

enum Melee_Weapons {
	FIST, 
	BITE,
	BOWIE_KNIFE,
	TWO_BY_FOUR,
	WEAPON, # Used for every weapon
	NONE = -1,
}

# Need to investigat this
# just different color ray casts for prototyping 
enum Ray_Cast_Weapons {
	LAZER_RIFLE,
	CHAOS_GUN,
	ZOMBIE_GUN,
	DEATH_RAY,
}


# Can have cooldown and charge up weapons too
enum Physics_Weapons {
	FLAME_THROWER,
	ELECTRO_CURVE_GUN,
	GRAVITY_GUN,
	FREEZE_GUN,
	HEALTH_THROWER,
}

# BRO TRACERS THAT SPAWN ITEMS???? SHEESH
# https://x.com/garrynewman/status/1710361924033016060?s=20
# need to implement this shit it would be sickkkkkkkkk
# could be useful for energy weapons variants? 
enum TracerTypes {
	TRACER_NONE,
	TRACER_LINE,
	TRACER_RAIL,
	TRACER_BEAM,
	TRACER_LINE_AND_WHIZ
}


enum Projectile_Weapons {
	SEMI_AUTO_SECONDARY,
	AUTO_SECONDARY,
	AR,
	SMG,
	LMG,
	MMG,
	HMG,
	SHOTGUN,
	SNIPER,
	BAZOOKA,
	MINIGUN,  # Probably not going to implement, super heavy machine gun
	CANNON,
	MORTAR,
}


# use for more of the gun resources 
enum Bullet_Types {
	STANDARD, # white fastest 
	ARMOR_PIERCING, # red less ammo + slower rate of fire think bolter now 
	EXPLOSIVE, # orange,
	ELECTRO, # electricblue stun
	FREEZING, # cyan slows movement
	ACID, # green melts environment 
	HOMING, # purple halo
	CHAOS, # black
	PHOSPHORUS, # dred breaks apart and does crazy spread damage  
}

var Bullet_Colors: Dictionary = {
	Bullet_Types.STANDARD: Color(0, 0, 0),
	Bullet_Types.ARMOR_PIERCING: Color(0.86274510622025, 0, 0),
	Bullet_Types.EXPLOSIVE: Color(0.989566385746, 0.61193192005157, 0),
	Bullet_Types.ELECTRO: Color(0.10098717361689, 0, 0.81833463907242),
	Bullet_Types.FREEZING : Color(0.33625048398972, 0.68618524074554, 0.78548473119736),
	Bullet_Types.ACID: Color(0.20146605372429, 0.56874758005142, 0),
	Bullet_Types.HOMING: Color(0.61960786581039, 0.09411764889956, 0),
	Bullet_Types.CHAOS: Color(0.00858727283776, 0.02839913405478, 0.03608712926507),
}

var Bullet_Damage_Types: Dictionary= {
	Bullet_Types.STANDARD: Damage_Types.BULLET,
	Bullet_Types.ARMOR_PIERCING: Damage_Types.BULLET,
	Bullet_Types.EXPLOSIVE: Damage_Types.BULLET,
	Bullet_Types.ELECTRO: Damage_Types.BULLET,
	Bullet_Types.FREEZING: Damage_Types.BULLET,
	Bullet_Types.ACID: Damage_Types.BULLET,
	Bullet_Types.HOMING: Damage_Types.BULLET,
	Bullet_Types.CHAOS: Damage_Types.BULLET
}



enum Rocket_Types {
	STANDARD,
	ROCKET,
	HOMING_MISSILE,
	SWARM_ROCKET,
}

#grenades are the same as dumb bombs kinda
enum Explosive_Devices {
	SMOKE_GRENADE,
	FRAGMENT_GRENADE,
	PUSH_PULL_GRENADE,
	DUMB_BOMB,
	C4,
	TNT,
	NAPALM_GRENADE,
	GAS_GRENADE,
}






# Note: Returns the ammo name, 
# or the classname of the object, 
# or the model name in the case of physgun ammo.
func get_projectile_type(projectile_name: String = "Unknown") -> String:

	if Bullet_Types[projectile_name] :
		# Get the ammo name from the ammo definition
		return projectile_name
	
	if inflictor != null:
		# Get the classname of the inflictor
		projectile_name = inflictor.get_classname()
		
		# Check for physgun ammo (assuming "prop_physics" as the class name)
		if projectile_name == "prop_physics":
			projectile_name = str(inflictor.get_model_name())
	
	return projectile_name


#can change this to a getter for impulse scale variable
static func calc_impulse_scale(target_mass: float, desired_speed: float) -> float:
	return target_mass * desired_speed


static func calc_damage_force(size: Vector3, damage: float = 1) -> float:
	var force = damage * (32 * 32 * 72.0) / (size.x * size.y * size.z) * 5
	print('Damage Force:  ', force)
	if force > 1000.0:
		force = 1000.0

	return force



func calculate_explosive_damage_force(dmg_src: Damage_Source, vec_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0):
	
	# Set the damage position in the info object
	dmg_src.damage_position = vec_force_origin
	
	# Constants
	var clamp_force = calc_impulse_scale(75, 400)
	
	# Calculate an impulse large enough to push a 75kg object 4 in/sec per point of damage
	var force_scale = dmg_src.base_damage * calc_impulse_scale(75, 4)
	
	# Clamp the force if it exceeds the clamping force
	if force_scale > clamp_force:
		force_scale = clamp_force
	
	# Fudge blast forces to introduce variability
	force_scale *= randf_range(0.85, 1.15)

	# Calculate the force vector
	var vec_force = vec_dir.normalized() * force_scale * phys_pushscale

	# Apply the final scaling factor
	vec_force *= fl_scale

	# Set the damage force in the info object
	dmg_src.damage_force = vec_force
	pass



# -----------------------------------------------------------------------------
#  Purpose: Fill out a takedamageinfo with a damage force for a bullet impact
# -----------------------------------------------------------------------------
static func calculate_bullet_damage_force(damage_source: Damage_Source, bullet: Bullet, vec_bullet_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0) -> Damage_Source:
#	if(debugging):
#		print('Vectors direcion & Force origin', vec_bullet_dir, vec_force_origin)
	
	damage_source.damage_type = Damage_Types.BULLET
	damage_source.attacker = bullet.attacker
	damage_source.damage = 1000
	# << ======    ammo type is an enum? 
	damage_source.damage_position = vec_force_origin
	
	# Calculate the force vector
	var vec_force = vec_bullet_dir.normalized() * calc_damage_force(Vector3(1,1,1)) # could add bullet damage as a param here
	
	# Apply scaling factors
	vec_force *= damage_source.phys_pushscale
	vec_force *= fl_scale
	
	# Set the damage force in the info object
	damage_source.damage_force = vec_force
	
	assert(vec_force != Vector3(0, 0, 0), 'Assert that the force vector is not equal to vec3_origin')

	return damage_source
	



	
func calculate_melee_damage_force(dmg_src: Damage_Source, vec_melee_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0):
	# Set the damage position in the info object
	dmg_src.set_damage_position(vec_force_origin)

	# Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
	var fl_force_scale = dmg_src.get_base_damage() * calc_impulse_scale(75, 4)	

	# Calculate the force vector
	var vec_force = vec_melee_dir.normalized() * fl_force_scale	

	# Apply scaling factors
	vec_force *= phys_pushscale
	vec_force *= fl_scale	

	# Set the damage force in the info object
	dmg_src.set_damage_force(vec_force)

func guess_damage_force(info: Damage_Source, vec_force_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0):
	# Implement the logic for GuessDamageForce here
	# You can access info, vec_force_dir, vec_force_origin, and fl_scale as parameters
	# and modify them as needed within this function
	
	var damage_type = info.get_damage_type()
	
	if damage_type.DMG_BULLET:
		calculate_bullet_damage_force(info, Bullet.new(), vec_force_dir, vec_force_origin, fl_scale)
	elif damage_type.DMG_BLAST:
		calculate_explosive_damage_force(info, vec_force_dir, vec_force_origin, fl_scale)
	else:
		calculate_melee_damage_force(info, vec_force_dir, vec_force_origin, fl_scale)







# ammo isnt bullet info entirely
enum AMMO_FLAGS  {
	INFINITE_AMMO,
	AMMO_FORCE_DROP_IF_CARRIED,
	AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER,
} 

class AmmoType:
	var name: String = ""
	var damage_type: Damage_Types = 0
	var tracer_type: TracerTypes = 0
	var min_splash_size: int = 0
	var max_splash_size: int = 0
	var flags: AMMO_FLAGS = 0
	# Values for player/NPC damage and carrying capability
	# If the integers are set, they override the CVars
	var player_damage: int = 0 # CVar for player damage amount
	var NPC_damage: int = 0 # CVar for NPC damage amount
	var max_carry: int = 0 # CVar for maximum number can carry
	var physics_force_impulse: float = 0.0
	var debug = false
	var MAX_AMMO_TYPES = 0
	# Constructor
	func _init( 
		_name: String,
		_damage_type: int,
		_tracer_type: int,
		_flags: int,
		_min_splash_size: int,
		_max_splash_size: int,
		_player_damage: int = 0,
		_NPC_damage: int = 0,
		_max_carry: int = 0,
		_physics_force_impulse: float = 0.0
	):
		name = _name
		damage_type = _damage_type
		tracer_type = _tracer_type
		min_splash_size = _min_splash_size
		max_splash_size = _max_splash_size
		flags = _flags
		player_damage = _player_damage
		NPC_damage = _NPC_damage
		max_carry = _max_carry
		physics_force_impulse = _physics_force_impulse



	# 175 AI_Lands
	# [node name="dummy_ai" parent="dummymale" instance=ExtResource("9_8xtbk")]
	# actor_node_path = NodePath("..")

	# [node name="dummy_ai" parent="dummymale" node_paths=PackedStringArray("blackboard") instance=ExtResource("9_8xtbk")]
	# actor_node_path = NodePath("..")
	# blackboard = NodePath("@Node@18404")
	
