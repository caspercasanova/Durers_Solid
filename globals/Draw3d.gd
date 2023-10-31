class_name Draw3d extends Node


static func create_line(points: Array[Vector3]):
	if(points.size() >= 1 ):
		return
	var mesh = ImmediateMesh.new()
	# Clean up before drawing.
	mesh.clear_surfaces()
	# Begin draw.
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	for p in points:
		mesh.surface_add_vertex(p)

	mesh.surface_end()

	pass


static func draw_sphere(target_location: Vector3) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.transform.origin = target_location
	var mesh = SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 0.5 * 2
	mesh_instance.mesh = mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.6878816485405, 0.1529648900032, 0)
	mesh_instance.material_override = material
	return mesh_instance
