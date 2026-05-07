extends Camera3D

# switch between isometric view and perspective view
@export var is_ORTHOGONAL: bool = true 
@export var ortho_size: float = 20.0
@export var move_speed: float = 15
@export var height_offset: float = 30.0
@export var rotation_speed: float = 0.002
@export var sprint_multiplier: float = 2.0
@export var zoom_speed: float = 1.0
@export var min_zoom: float = 10.0
@export var max_zoom: float = 30.0
@export var follow_speed: float = 10.0
@export var tracking_distance: float = 8.0

var camera_position = Vector3(-130, height_offset, 30)
var pitch: float = rotation_degrees.x
var rotating: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO
var tracked_unit: Node3D = null
var last_valid_position: Vector3

var min_pitch: float = -60.0
var max_pitch: float = -15.0 

func _ready() -> void:
	if is_ORTHOGONAL:
		projection = Camera3D.PROJECTION_ORTHOGONAL
		size = ortho_size
		rotation_degrees.x = -30
		rotation_degrees.y = -45
		rotation_degrees.z = 0
		position = Vector3(-115.5571, height_offset, 12.56429)
	else:
		min_zoom = 30.0
		max_zoom = 80.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_rotation()
	handle_zoom()
	
	if tracked_unit:
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or \
			Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			clear_tracking()
		else:
			handle_tracking(delta)
	else:
		handle_movement(delta)

func handle_movement(delta):
	var speed = move_speed
	if Input.is_action_pressed("sprint"):
		speed *= sprint_multiplier
	
	var move_dir = Vector3.ZERO
	if Input.is_action_pressed("move_up"):
		move_dir -= transform.basis.z
	if Input.is_action_pressed("move_down"):
		move_dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		move_dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		move_dir += transform.basis.x
	
	if move_dir != Vector3.ZERO:
		move_dir = move_dir.normalized()
	
	camera_position += move_dir * speed * delta
	global_position = Vector3(camera_position.x, height_offset, camera_position.z)

func handle_rotation():
	if Input.is_action_just_pressed("rotate_camera"):
		rotating = true
		last_mouse_position = get_viewport().get_mouse_position()
	elif Input.is_action_just_released("rotate_camera"):
		rotating = false

	if rotating:
		if is_ORTHOGONAL:
			var current_mouse_position = get_viewport().get_mouse_position()
			var delta_mouse = current_mouse_position - last_mouse_position
			rotate_y(-delta_mouse.x * rotation_speed)
			last_mouse_position = current_mouse_position
		else:
			var current_mouse_position = get_viewport().get_mouse_position()
			var delta_mouse = current_mouse_position - last_mouse_position
			rotate_y(-delta_mouse.x * rotation_speed)
			pitch = clamp(pitch - delta_mouse.y * rotation_speed * 100, min_pitch, max_pitch)
			rotation_degrees.x = pitch
			last_mouse_position = current_mouse_position

func handle_zoom():
	if is_ORTHOGONAL:
		if Input.is_action_just_released("zoom_in"):
			size = max(size - zoom_speed, min_zoom)
		if Input.is_action_just_released("zoom_out"):
			size = min(size + zoom_speed, max_zoom)
	else:
		if Input.is_action_just_released("zoom_in"):
			fov = max(fov - zoom_speed, min_zoom)
		if Input.is_action_just_released("zoom_out"):
			fov = min(fov + zoom_speed, max_zoom)

func handle_tracking(delta):
	if tracked_unit:
		if is_ORTHOGONAL:
			var target_pos = tracked_unit.global_position
			var forward = -transform.basis.z.normalized()
			var right = transform.basis.x.normalized()
			var desired_pos = target_pos - (forward*7 + right/2) * tracking_distance
			desired_pos.y = height_offset
			global_position = global_position.lerp(desired_pos, follow_speed * delta)
		else:
			var target_pos = tracked_unit.global_position
			var direction = (Vector3(global_position.x, 0, global_position.z) - Vector3(target_pos.x, 0, target_pos.z)).normalized()
			var desired_pos = target_pos + direction * tracking_distance
			desired_pos.y = height_offset - tracking_distance
			global_position = global_position.lerp(desired_pos, follow_speed * delta)	
			
	last_valid_position = global_position
	

func set_tracked_unit(unit: DynamicObj):
	tracked_unit = unit

func clear_tracking():
	tracked_unit = null
	camera_position = last_valid_position

func stop_tracking_if_killed(unit: DynamicObj):
	if tracked_unit == unit:
		if OS.is_debug_build(): print(unit.name, " was killed, stopping tracking")
		clear_tracking()
