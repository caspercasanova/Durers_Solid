extends Damage_Source.Bullet

var blast = preload("res://weapons/blast.tscn")

#signal Hit_Successfull

#shielf with impact
#https://godotshaders.com/shader/shield-with-impact-visualisation/
func _ready():
	pass


func call_delayed(callable: Callable, delay: float):
	get_tree().create_timer(delay, false).connect('timeout', callable)


func instantiate_an_explosion():
	print('EXPLODED')
	var b = blast.instantiate()

	return b

# logic for piercing another body? 
func _on_body_entered(body):
	print('======================= EXPLOSIVE BULLETS ================', bullet_type)
	
	sleeping = true
	if(bullet_type == Bullet_Types.EXPLOSIVE):
		
		call_delayed(func():  add_child(instantiate_an_explosion()), 1)
	
#	if body.is_in_group("Target") && body.has_method("Hit_Successful"):
#		body.Hit_Successful(self.size)
#		emit_signal("Hit_Successfull")
#	queue_free()

func _on_timer_timeout():
	print('Bullet Timedout')
	queue_free()
