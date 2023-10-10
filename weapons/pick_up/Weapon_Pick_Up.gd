extends RigidBody3D

@export var _weapon_name: String
@export var _current_ammo: int
@export var _reserve_ammo: int

const TYPE = "Weapon"

var Pick_Up_Ready: bool = false
@onready var timer: Timer = $Timer
var can_attack = true: set = set_can_attack, get = get_can_attack;

func set_can_attack(_can_attack):
	can_attack = _can_attack
func get_can_attack():
	return can_attack
 

func call_delayed(callable: Callable, delay: float):
	get_tree().create_timer(delay, false).connect('timeout', callable)


func _ready():
	await get_tree().create_timer(2.0).timeout
	Pick_Up_Ready = true

func Set_Ammo(w_name: String, c_ammo : int, r_ammo : int):
	if w_name == _weapon_name:
		_current_ammo = c_ammo
		_reserve_ammo = r_ammo


func attack(actor, target):
	if !can_attack: 
		return 
	
	
	set_can_attack(false)
	call_delayed(func(): set_can_attack(true), 100)


#
#func LaunchProjectile(Point: Vector3):
#	var Direction = (Point - Bullet_Point.global_transform.origin).normalized()
#	var Projectile = Current_Weapon.Projectile_To_Load.instantiate()
#
#	Bullet_Point.add_child(Projectile)
#	Add_Signal_To_HUD.emit(Projectile)
#
#	var Projectile_RID = Projectile.get_rid()
#
#	Collision_Exclusion.push_back(Projectile_RID)
#	Projectile.tree_exited.connect(Remove_Exclusion.bind(Projectile_RID))
#
#	Projectile.set_linear_velocity(Direction*Current_Weapon.Projectile_Velocity)
#	Projectile.Damage = Current_Weapon.Damage
