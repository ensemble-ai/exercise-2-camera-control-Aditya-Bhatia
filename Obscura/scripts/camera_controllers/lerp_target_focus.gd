class_name LerpTargetFocus
extends CameraControllerBase

var _catchup_timer: float = 0.0

# lead_speed is a ratio of the target's velocity
# catchup_delay_duration is in seconds
# catchup_speed is also a multiplier that has min 0 and max 1
@export var lead_speed:float = 1.5
@export var catchup_delay_duration:float = 0.5
@export_range(0, 1, 0.05) var catchup_speed:float = 0.5
@export var leash_distance:float = 5

func _ready():
	super()
	draw_camera_logic = true
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()

	super(delta)
 

func _physics_process(delta: float) -> void:
	if target.velocity == Vector3(0, 0, 0) and position != target.position:
		if _catchup_timer > 0:
			_catchup_timer -= delta
			return

		var cpos = position
		position = cpos.lerp(target.position, 0.15 * catchup_speed)
		return
	
	var cpos_xz = Vector2(position.x, position.z)
	var desired_position = target.position + target.velocity.normalized() * leash_distance
	var dpos_xz = Vector2(desired_position.x, desired_position.z)
	var tvel_xz = Vector2(target.velocity.x, target.velocity.z)

	# This code allows the camera to change direction and move to the other side
	# of the target if the target instantaneously changes directions
	# however, it also causes the hitching when moving near the leash_distance
	# I tried my best, but unfortunately I was not able to stop that from hapenning
	# Apologies if it causes your eyes or head to hurt
	if (dpos_xz - cpos_xz).dot(tvel_xz) < 0:
		position = position.lerp(desired_position, 0.15 * catchup_speed)
	else:
		position += target.velocity * lead_speed * delta

	_catchup_timer = catchup_delay_duration


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var height:float = 5
	var width:float = 5

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(-width/2, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(width/2, 0, 0))

	immediate_mesh.surface_add_vertex(Vector3(0, 0, -height/2))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, height/2))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
