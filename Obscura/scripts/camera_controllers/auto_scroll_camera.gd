class_name AutoScroll
extends CameraControllerBase


@export var top_left:Vector2 = Vector2(-5, -5)
@export var bottom_right:Vector2 = Vector2(5, 5)
@export var autoscroll_speed:Vector3 = Vector3(5, 0, 0)

func _ready() -> void:
	super()
	draw_camera_logic = true
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		position = target.position
		return
	
	if draw_camera_logic:
		draw_logic()

	position += autoscroll_speed * delta
	target.global_position += autoscroll_speed * delta
	
	var tpos = target.global_position
	var cpos = global_position
	
	_boundary_checks(tpos, cpos)
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = top_left.x
	var right:float = bottom_right.x
	var top:float = top_left.y
	var bottom:float = bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()


func _boundary_checks(tpos, cpos) -> void:
	# boundary checks
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - abs(bottom_right.x))
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + abs(bottom_right.x))
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + abs(bottom_right.y))
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - abs(bottom_right.y))
	
	if autoscroll_speed.x > 0:
		# left
		if diff_between_left_edges < 0:
			target.global_position.x -= diff_between_left_edges
		# right
		if diff_between_right_edges > 0:
			target.global_position.x = cpos.x + abs(bottom_right.x) - target.WIDTH / 2.0
	elif autoscroll_speed.x < 0:
		# right
		if diff_between_right_edges > 0:
			target.global_position.x -= diff_between_right_edges
		# left
		if diff_between_left_edges < 0:
			target.global_position.x = cpos.x - abs(bottom_right.x) + target.WIDTH / 2.0
	else:
		# left
		if diff_between_left_edges < 0:
			target.global_position.x = cpos.x - abs(bottom_right.x) + target.WIDTH / 2.0
		# right
		if diff_between_right_edges > 0:
			target.global_position.x = cpos.x + abs(bottom_right.x) - target.WIDTH / 2.0
	
	if autoscroll_speed.z < 0:
		# bottom
		if diff_between_bottom_edges > 0:
			target.global_position.z -= diff_between_bottom_edges
		# top
		if diff_between_top_edges < 0:
			target.global_position.z = cpos.z - abs(bottom_right.y) + target.HEIGHT / 2.0
	elif autoscroll_speed.z > 0:
		# top
		if diff_between_top_edges < 0:
			target.global_position.z -= diff_between_top_edges
		# bottom
		if diff_between_bottom_edges > 0:
			target.global_position.z = cpos.z + abs(bottom_right.y) - target.HEIGHT / 2.0
	else:
		# bottom
		if diff_between_bottom_edges > 0:
			target.global_position.z = cpos.z + abs(bottom_right.y) - target.HEIGHT / 2.0
		# top
		if diff_between_top_edges < 0:
			target.global_position.z = cpos.z - abs(bottom_right.y) + target.HEIGHT / 2.0
