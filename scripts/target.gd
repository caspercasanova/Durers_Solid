extends StaticBody3D

var Health = 1

# convert to resource or can probably delete after morphing FPS code

func Hit_Successful(Damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= Damage
	if Health <= 0:
		queue_free()
