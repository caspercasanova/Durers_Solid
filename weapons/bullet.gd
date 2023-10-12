extends Damage_Source.Bullet

signal Hit_Successfull


# should probably do size instead of damage 
var size: int = 0
var type: Bullet_Types = Bullet_Types.STANDARD

# logic for piercing another body? 
func _on_body_entered(body):
	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
		body.Hit_Successful(size)
		emit_signal("Hit_Successfull")

#	queue_free()

func _on_timer_timeout():
	queue_free()
