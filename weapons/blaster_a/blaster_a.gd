extends Damage_Source.Projectile_Weapon

@export var _weapon_name: String = 'blaster_a'
@export var _current_ammo: int = 10
@export var _reserve_ammo: int = 10


@onready var timer: Timer = $timer
@onready var muzzle: Marker3D = $muzzle

var fire_rate_per_second = 100
var bullet = preload("res://weapons/bullet.tscn")
var projectile_velocity: int = 50
var pick_up_ready: bool = false

var can_attack = true: set = set_can_attack, get = get_can_attack;
func set_can_attack(_can_attack):
	can_attack = _can_attack
func get_can_attack():
	return can_attack
 

func call_delayed(callable: Callable, delay: float):
	get_tree().create_timer(delay, false).connect('timeout', callable)


func _ready():
	await get_tree().create_timer(2.0).timeout
	pick_up_ready = true


# unqueue when parent dies? idk
# stat scaling for units?
# https://www.youtube.com/watch?v=SzBScaXlfao

# target prbpbaly not needed, but maybbe?
func use_weapon(actor: Dummy, target: Node):
	if !can_attack: 
		return 
	# add this type to the removing of bullets 
	# Collision_Exclusion.push_back(Projectile_RID)
	# Projectile.tree_exited.connect(Remove_Exclusion.bind(Projectile_RID))
	# Projectile.Damage = Current_Weapon.Damage

	var direction = -muzzle.global_transform.basis.z
	var projectile = bullet.instantiate()
	projectile.bullet_type = Bullet_Types.EXPLOSIVE
	projectile.size =  projectile.get_projectile_weapon_defs(Projectile_Weapons.SEMI_AUTO_SECONDARY)
	projectile.attacker = actor
	print("proctile class  ", projectile.get_class())
	muzzle.add_child(projectile)
	var projectile_RID = projectile.get_rid()

	projectile.set_linear_velocity(direction * projectile_velocity)
	actor.set_current_ammo(actor.get_current_ammo() - 1)
	
	set_can_attack(false)
	call_delayed(func(): set_can_attack(true), fire_rate_per_second)


# makes a bullet from the bullet class 
func use_bullet():
	return
