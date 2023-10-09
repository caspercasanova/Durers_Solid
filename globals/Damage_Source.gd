extends Node
#https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/shared/takedamageinfo.h#L24
class_name Damage_Source

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
	AIRBOAT, # Hit by the airboat's gun
	DISSOLVE, # dissolving 
	BLAST_SURFACE, # A blast on the surface of water that cannot harm things underwater
	DIRECT,
	BUCKSHOT, # not quite a bullet. Little, rounder, different.
};

enum Bullet_Types {
	CARBINE,
	SMG,
	M1911,
	SNIPER,
	RIFLE,
}

# Create an example Ammo_t Dictionary
var ammo = {
	"pName": "",
	"nDamageType": 0,
	"eTracerType": 0,
	"physicsForceImpulse": 0.0,
	"nMinSplashSize": 0,
	"nMaxSplashSize": 0,
	"nFlags": 0,
	"pPlrDmg": 0,
	"pNPCDmg": 0,
	"pMaxCarry": 0,
	"pPlrDmgCVar": null,
	"pNPCDmgCVar": null,
	"pMaxCarryCVar": null
}

# Constants for AmmoTracer_t
const TRACER_NONE = 0
const TRACER_LINE = 1
const TRACER_RAIL = 2
const TRACER_BEAM = 3
const TRACER_LINE_AND_WHIZ = 4

# Constants for AmmoFlags_t
const AMMO_FORCE_DROP_IF_CARRIED = 1
const AMMO_INTERPRET_PLRDAMAGE_AS_DAMAGE_TO_PLAYER = 2

# Example usage:
var tracerType = TRACER_LINE
var ammoFlags = AMMO_FORCE_DROP_IF_CARRIED


# Constants for ammo type indices
const MAX_AMMO_TYPES = 32
const USE_CVAR = -1

class AmmoType:
	var pName: String = ""
	var nDamageType: int = 0
	var eTracerType: int = 0
	var nMinSplashSize: int = 0
	var nMaxSplashSize: int = 0
	var nFlags: int = 0
	var pPlrDmg: int = 0
	var pNPCDmg: int = 0
	var pMaxCarry: int = 0
	var pPlrDmgCVar: String = ""
	var pNPCDmgCVar: String = ""
	var pMaxCarryCVar: String = ""
	var physicsForceImpulse: float = 0.0




# Assign values to the Dictionary
#ammo["pName"] = "Example Ammo"
#ammo["nDamageType"] = 42
#ammo["eTracerType"] = 1
#ammo["physicsForceImpulse"] = 5.0
#ammo["nMinSplashSize"] = 10
#ammo["nMaxSplashSize"] = 20
#ammo["nFlags"] = 3
#ammo["pPlrDmg"] = 20
#ammo["pNPCDmg"] = 30
#ammo["pMaxCarry"] = 100
#ammo["pPlrDmgCVar"] = null
#ammo["pNPCDmgCVar"] = null
#ammo["pMaxCarryCVar"] = null

# Accessing values in the Dictionary
var ammo_name = ammo["pName"]
var damage_type = ammo["nDamageType"]
# Access other fields similarly...


# Inflictor is the weapon or rocket (or player) that is dealing the damage.
# Weapon is the weapon that did the attack.
# For hitscan weapons, it'll be the same as the inflictor. For projectile weapons, the projectile 
# is the inflictor, and this contains the weapon that created the projectile.

func set_damage_info(p_inflictor, p_attacker, p_weapon, damage_force, damage_position, fl_damage, bits_damage_type, i_kill_type = 0, reported_position = null):
	# Implement the logic for your Set-like function here
	# You can access the parameters and perform any required operations
	# For example, you can print them for demonstration purposes:
	
	print("Inflictor: ", p_inflictor)
	print("Attacker: ", p_attacker)
	print("Weapon: ", p_weapon)
	print("Damage Force: ", damage_force)
	print("Damage Position: ", damage_position)
	print("Damage Amount: ", fl_damage)
	print("Damage Type: ", bits_damage_type)
	print("Kill Type: ", i_kill_type)
	print("Reported Position: ", reported_position)




#disover this value in world
var phys_pushscale = 1

# This can help a bit 
# https://www.youtube.com/watch?v=oIrvZDDWxhU

var _inflictor : Object = null : set = setInflictor, get = getInflictor
var _weapon : Object = null: set = setWeapon, get = getWeapon
var _attacker : Object = null: set = setAttacker, get = getAttacker
var _damage : float = 0.0: set = setDamage, get = getDamage
var _maxDamage : float = 0.0: set= setMaxDamage,get = getMaxDamage
var _damageBonus : float = 0.0: set= setDamageBonus, get=  getDamageBonus
var _baseDamage : float = 0.0: set= setBaseDamage, get = getBaseDamage
var _damageForce : Vector3 = Vector3(0, 0, 0): set= setDamageForce, get = getDamageForce
var _damagePosition : Vector3 = Vector3(0, 0, 0): set= setDamagePosition, get = getDamagePosition
var _reportedPosition : Vector3 = Vector3(0, 0, 0): set= setReportedPosition, get = getReportedPosition
var _damageType : int = 0: set= setDamageType,get = getDamageType
var _damageCustom : int = 0: set= setDamageCustom,get= getDamageCustom
var _damageStats : int = 0: set= setDamageStats, get=getDamageStats
var _ammoType : int = 0: set= setAmmoType, get=getAmmoType
var _playerPenetrationCount : int = 0: set= setPlayerPenetrationCount, get =getPlayerPenetrationCount
var _damagedOtherPlayers : int = 0: set= setDamagedOtherPlayers, get =getDamagedOtherPlayers
var _forceFriendlyFire : bool = false: set= setForceFriendlyFire, get=getForceFriendlyFire


func setInflictor(inflictor: Object):
	_inflictor = inflictor
	
func getInflictor():
	return _inflictor 

func fromInflictor() -> Damage_Source:
	return Damage_Source.new()


func setWeapon(weapon: Object):
	_weapon = weapon

func getWeapon():
	return _weapon 

func setAttacker(value: Object) -> void:
	_attacker = value

func getAttacker() -> Object:
	return _attacker

func setDamage(value: float) -> void:
	_damage = value

func getDamage() -> float:
	return _damage

func setMaxDamage(value: float) -> void:
	_maxDamage = value

func getMaxDamage() -> float:
	return _maxDamage

func setDamageBonus(value: float) -> void:
	_damageBonus = value

func getDamageBonus() -> float:
	return _damageBonus

func setBaseDamage(value: float) -> void:
	_baseDamage = value

func getBaseDamage() -> float:
	return _baseDamage

func setDamageForce(value: Vector3) -> void:
	_damageForce = value

func getDamageForce() -> Vector3:
	return _damageForce

func setDamagePosition(value: Vector3) -> void:
	_damagePosition = value

func getDamagePosition() -> Vector3:
	return _damagePosition

func setReportedPosition(value: Vector3) -> void:
	_reportedPosition = value

func getReportedPosition() -> Vector3:
	return _reportedPosition

func setDamageType(value: int) -> void:
	_damageType = value

func getDamageType() -> int:
	return _damageType

func setDamageCustom(value: int) -> void:
	_damageCustom = value

func getDamageCustom() -> int:
	return _damageCustom

func setDamageStats(value: int) -> void:
	_damageStats = value

func getDamageStats():
	return _damageStats
func setAmmoType(ammoType):
	_ammoType = ammoType
func getAmmoType():
	return _ammoType
	
func setPlayerPenetrationCount(playerPenetrationCount):
	_playerPenetrationCount = playerPenetrationCount
func getPlayerPenetrationCount():
	return _playerPenetrationCount
func setDamagedOtherPlayers(damagedOtherPlayers):
	_damagedOtherPlayers = damagedOtherPlayers 
func getDamagedOtherPlayers():
	return _damagedOtherPlayers
func setForceFriendlyFire(forceFriendlyFire):
	_forceFriendlyFire = forceFriendlyFire 
func getForceFriendlyFire():
	return _forceFriendlyFire





# https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/physics_impact_damage.h#L54
# func impulse_scale(fl_target_mass: float, fl_desired_speed: float) -> float:
# 	return fl_target_mass * fl_desired_speed
	

# func calculate_explosive_damage_force(info: Damage_Source, vec_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0):
# 	# Implement the logic for CalculateExplosiveDamageForce here
# 	# You can access info, vec_dir, vec_force_origin, and fl_scale as parameters
# 	# and modify them as needed within this function
	
# 		# Set the damage position in the info object
# 	info.set_damage_position(vec_force_origin)
	
# 	# Constants
# 	var fl_clamp_force = impulse_scale(75, 400)
	
# 	# Calculate an impulse large enough to push a 75kg object 4 in/sec per point of damage
# 	var fl_force_scale = info.get_base_damage() * impulse_scale(75, 4)
	
# 	# Clamp the force if it exceeds the clamping force
# 	if fl_force_scale > fl_clamp_force:
# 		fl_force_scale = fl_clamp_force
	
# 	# Fudge blast forces to introduce variability
# 	fl_force_scale *= randf_range(0.85, 1.15)
	
# 	# Calculate the force vector
# 	var vec_force = vec_dir.normalized() * fl_force_scale * phys_pushscale
		
# 	# Apply the final scaling factor
# 	vec_force *= fl_scale
	
# 	# Set the damage force in the info object
# 	info.set_damage_force(vec_force)

# 	pass

# # ammo type is an enum? 
# func calculate_bullet_damage_force(info: Damage_Source, i_bullet_type: int, vec_bullet_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0):
# 	# Implement the logic for CalculateBulletDamageForce here
# 	# You can access info, i_bullet_type, vec_bullet_dir, vec_force_origin, and fl_scale as parameters
# 	# and modify them as needed within this function
# 	# Set the damage position in the info object
# 	info.set_damage_position(vec_force_origin)
	
# 	# Calculate the force vector
# 	var vec_force = vec_bullet_dir.normalized() * get_ammo_def().damage_force(i_bullet_type)
	
# 	# Apply scaling factors
# 	vec_force *= phys_pushscale
# 	vec_force *= fl_scale
	
# 	# Set the damage force in the info object
# 	info.set_damage_force(vec_force)
	
# 	# Assert that the force vector is not equal to vec3_origin
# 	assert(vec_force != Vector3(0, 0, 0))

# 	pass


# func calculate_melee_damage_force(info: Damage_Source, vec_melee_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0):
# 	# Implement the logic for CalculateMeleeDamageForce here
# 	# You can access info, vec_melee_dir, vec_force_origin, and fl_scale as parameters
# 	# and modify them as needed within this function
# 	# Set the damage position in the info object
# 	info.set_damage_position(vec_force_origin)
	
# 	# Calculate an impulse large enough to push a 75kg object 4 in/sec per point of damage
# 	var fl_force_scale = info.get_base_damage() * impulse_scale(75, 4)
	
# 	# Calculate the force vector
# 	var vec_force = vec_melee_dir.normalized() * fl_force_scale
	
# 	# Apply scaling factors
# 	vec_force *= phys_pushscale
# 	vec_force *= fl_scale
	
# 	# Set the damage force in the info object
# 	info.set_damage_force(vec_force)

# 	pass



# func guess_damage_force(info: Damage_Source, vec_force_dir: Vector3, vec_force_origin: Vector3, fl_scale: float = 1.0):
# 	# Implement the logic for GuessDamageForce here
# 	# You can access info, vec_force_dir, vec_force_origin, and fl_scale as parameters
# 	# and modify them as needed within this function
# 	var damage_type = info.get_damage_type()
	
# 	if damage_type & DMG_BULLET:
# 		calculate_bullet_damage_force(info, get_ammo_def().index("SMG1"), vec_force_dir, vec_force_origin, fl_scale)
# 	elif damage_type & DMG_BLAST:
# 		calculate_explosive_damage_force(info, vec_force_dir, vec_force_origin, fl_scale)
# 	else:
# 		calculate_melee_damage_force(info, vec_force_dir, vec_force_origin, fl_scale)

# 	pass



# # Function to get the name of the ammo that caused damage
# # Note: Returns the ammo name, or the classname of the object, or the model name in the case of physgun ammo.
# func get_ammo_name() -> String:
# 	var ammo_name = "Unknown"  # Default to "Unknown" in case no ammo information is available

# 	if m_iAmmoType >= 0:
# 		# Get the ammo name from the ammo definition
# 		var ammo_def = get_ammo_def()
# 		if ammo_def:
# 			ammo_name = ammo_def.get_ammo_of_index(m_iAmmoType).pName

# 	elif m_hInflictor != null:
# 		# Get the classname of the inflictor
# 		ammo_name = m_hInflictor.get_classname()

# 		# Check for physgun ammo (assuming "prop_physics" as the class name)
# 		if ammo_name == "prop_physics":
# 			ammo_name = str(m_hInflictor.get_model_name())

# 	return ammo_name


# func add_multi_damage(info: Damage_Source, entity: Object) -> void:
# 	if entity == null:
# 		return

# 	if entity != g_multi_damage.target:
# 		apply_multi_damage()
# 		g_multi_damage.init(entity, info.get_inflictor(), info.get_attacker(), info.get_weapon(),
# 							Vector3(0, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0), 0.0, info.get_damage_type(),
# 							info.get_damage_custom())

# 	g_multi_damage.add_damage_type(info.get_damage_type())
# 	g_multi_damage.set_damage(g_multi_damage.get_damage() + info.get_damage())
# 	g_multi_damage.set_damage_force(g_multi_damage.get_damage_force() + info.get_damage_force())
# 	g_multi_damage.set_damage_position(info.get_damage_position())
# 	g_multi_damage.set_reported_position(info.get_reported_position())
# 	g_multi_damage.set_max_damage(max(g_multi_damage.get_max_damage(), info.get_damage()))
# 	g_multi_damage.set_ammo_type(info.get_ammo_type())

# 	if g_multi_damage.get_player_penetration_count() == 0:
# 		g_multi_damage.set_player_penetration_count(info.get_player_penetration_count())

# 	var has_physics_force_damage = not g_game_rules.damage_no_physics_force(info.get_damage_type())
	
# 	if has_physics_force_damage and g_multi_damage.get_damage_type() != DMG_GENERIC:
# 		if g_multi_damage.get_damage_force() == Vector3(0, 0, 0) or g_multi_damage.get_damage_position() == Vector3(0, 0, 0):
# 			var warning_count = 0
# 			if warning_count < 10:
# 				if g_multi_damage.get_damage_force() == Vector3(0, 0, 0):
# 					print("AddMultiDamage:  g_multi_damage.get_damage_force() == Vector3(0, 0, 0)")

# 				if g_multi_damage.get_damage_position() == Vector3(0, 0, 0):
# 					print("AddMultiDamage:  g_multi_damage.get_damage_position() == Vector3(0, 0, 0)")
# 				warning_count += 1






# class CAmmoDef:
# 	var m_AmmoType: Array = []
# 	var m_nAmmoIndex: int = 0

# 	# Constructor
# 	func _init():
# 		for types in range(MAX_AMMO_TYPES):
# 			m_AmmoType.append(AmmoType .new())

# 	# Add an ammo type without constant vars
# 	func addAmmoType(name: String, damageType: int, tracerType: int, nFlags: int, minSplashSize: int, maxSplashSize: int) -> bool:
# 		if m_nAmmoIndex == MAX_AMMO_TYPES:
# 			return false

# 		var ammo = m_AmmoType[m_nAmmoIndex]
# 		ammo.pName = name
# 		ammo.nDamageType = damageType
# 		ammo.eTracerType = tracerType
# 		ammo.nMinSplashSize = minSplashSize
# 		ammo.nMaxSplashSize = maxSplashSize
# 		ammo.nFlags = nFlags
# 		m_nAmmoIndex += 1

# 		return true

# 	# Add an ammo type with constant vars
# 	func addAmmoTypeWithCvars(name: String, damageType: int, tracerType: int, plrCVar: String, npcCVar: String, carryCVar: String, physicsForceImpulse: float, nFlags: int, minSplashSize: int, maxSplashSize: int):
# 		if addAmmoType(name, damageType, tracerType, nFlags, minSplashSize, maxSplashSize) == false:
# 			return

# 		var ammo = m_AmmoType[m_nAmmoIndex - 1]
# 		if plrCVar != "":
# 			ammo.pPlrDmgCVar = plrCVar
# 			ammo.pPlrDmg = USE_CVAR
# 		if npcCVar != "":
# 			ammo.pNPCDmgCVar = npcCVar
# 			ammo.pNPCDmg = USE_CVAR
# 		if carryCVar != "":
# 			ammo.pMaxCarryCVar = carryCVar
# 			ammo.pMaxCarry = USE_CVAR
# 		ammo.physicsForceImpulse = physicsForceImpulse


