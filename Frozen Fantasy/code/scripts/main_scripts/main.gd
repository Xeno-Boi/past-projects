extends Node3D

"""
This is the main scene

UI:
	- (present node for UI is placeholder)
	- handles using inbuild Godot classes (specifics need research)
	- will be a child node(s) of this scene -- may or may not have its own script
	- Title screen & pause (if we have pause) handled in UI
	- Health bars likely handled by individual units

Resources:
	- kept here
	- this is where main control happens. Lot of signals come through here

World Event Manager:
	- has its own script; handled mostly independantly. It adds children to this scene tho


"""

var defs = preload("res://defs.gd")


# properties
const RAY_DISTANCE = 1000	## distance for ray cast from camera to check for collision
@export var load_terrain_geometry_from_file : bool = false	## loads terrain geometry data from a file instead of gathering at runtime
@export var load_terrain_object_geometry_from_file : bool = false	## loads terrain objects geometry data from a file instead of gathering at runtime
@export var terrain_geometry_file_path : String = "res://data/terrain_geometry_data.bin"	## path to the file that stores terrain data, NavigationMeshSourceGeometryData3D object
@export var terrain_object_geometry_file_path : String = "res://data/terrain_object_geometry_data.bin"	## path to the file that stores terrain object data, dictionary

var resources : Dictionary = {"wood": 0, "stone": 0, "fire_stone": 0, "new_fire_shard": 0}

# signals
signal resources_updated(resources)

# child
@onready var nav_region = $Terrain/NavigationRegion
@onready var terrain = $Terrain/NavigationRegion/Floor
@onready var ui = $UI
@onready var goal_list = $UI/GoalList
@onready var patrol_nodes = $PatrolNodes
@onready var light = $WorldEventManager/DirectionalLight3D

# counters
var terrain_objects_geometry_shapes = NavigationMeshSourceGeometryData3D.new()
var terrain_obstruction_dictionary = {}
var building_name_counter = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Main") # this means everybody can query group main to get this node.
	
	if (not load_terrain_geometry_from_file) or\
		(not FileAccess.file_exists(terrain_object_geometry_file_path)):
		create_and_store_terrain_geometry_to_file()
	
	terrain_objects_geometry_shapes = collect_terrain_geometry_from_file()	# load fresh geomtry shape with only terrain geometry
	assert(terrain_objects_geometry_shapes)
	
	# add all terrain object geometry
	if not (load_terrain_object_geometry_from_file and \
			collect_geometry_from_file(terrain_objects_geometry_shapes)):
		collect_geometry_from_group(terrain_objects_geometry_shapes)
	
	# bake nav mesh
	bake_nav_mesh()
	
	for building in get_node("Terrain/NavigationRegion/Buildings").get_children():
		connect_building_signals(building)
	
	# setup enemy beast
	var enemy_beast = $Units/EnemyBeast
	for node in patrol_nodes.get_children():
		enemy_beast.patrol_path.append(node)
	
	


func add_resource(type: String, amount: int = 1) ->void:
	if(type in resources):
		resources[type] += amount
		#print("Gathered ", type, ", current amount = ", resources[type])
	
	#UI UPDATE CALLS SFX, ETC GO HERE
	emit_signal("resources_updated", resources)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#check for end condition:
	if get_tree().get_nodes_in_group("pyre_buildings").is_empty():
		endGame(false)
	
	pass


# handles input
func _input(event: InputEvent) -> void:
	# mouse inputs
	if event is InputEventMouseButton:
		# disables click if input in buttons
		var ui_buttons = [
			$UI/BottomPanel/BuildingListBG/BuildingList/GathererCampFireButton,
			$UI/BottomPanel/BuildingListBG/BuildingList/WarriorsHutButton,
			$UI/BottomPanel/BuildingListBG/BuildingList/WizardTowerButton, 
			$UI/BottomPanel/BuildingListBG/BuildingList/PyreButton,
			$UI/BottomPanel/BuildingListBG/BuildingList/WNFButton,
		]
		for button in ui_buttons:
			if button.get_global_rect().has_point(event.position):
				for pyre in get_tree().get_nodes_in_group("pyre_buildings"):
					pyre.select()
				return
				
		if event.pressed:
			# ray cast to see which object is being clicked on
			var ray_cast_result = getMouseClickCollision(get_viewport().get_mouse_position())
			if ray_cast_result:
				var collider = ray_cast_result.collider
				if collider is Area3D:
					collider = collider.get_parent()
				var click_position = ray_cast_result.position
				
				# remove selected pyre if not placing buildings
				if not ui.selecting_spawn:
					defs.clearGroup(self, "pyre_selected")
				
				if event.button_index == MOUSE_BUTTON_LEFT:
					if collider.has_method("leftClickOn"):	# if colliding object has an implemented left click function
						collider.leftClickOn(click_position)
				elif event.button_index == MOUSE_BUTTON_RIGHT:
					if collider.has_method("rightClickOn"):	# if colliding object has an implemented right click function
						collider.rightClickOn(click_position)
			
			# ui
			if event.button_index == MOUSE_BUTTON_LEFT:
				ui.leftClick(ray_cast_result)
			if event.button_index == MOUSE_BUTTON_RIGHT:
				ui.rightClick()
	
	# other inputs
	if Input.is_action_just_pressed("clear_selected"):
		defs.clearGroup(self, "selected")
		defs.clearGroup(self, "pyre_selected")
	
	if Input.is_action_just_pressed("debug_toggle"):
		defs.DEBUG_MODE = not defs.DEBUG_MODE
		ui.toggleDebug(defs.DEBUG_MODE)
	
	if Input.is_action_just_pressed("select_onscreen_units"):
		ui.deselectBuilding()
		defs.clearGroup(self, "selected")
		var camera = get_viewport().get_camera_3d()
		var viewport = Rect2(Vector2.ZERO, get_viewport().size)
		for node in get_tree().get_nodes_in_group("units"):
			# get camera space coordinate of node
			var screen_position = camera.unproject_position(node.global_position)
			# check if node is on screen (ignores obsticles)
			if viewport.has_point(screen_position):
				if node.is_visible_in_tree():
					if node.alignment:	# player units
						node.select()
	
	if Input.is_action_just_pressed("select_all_units"):
		ui.deselectBuilding()
		for node in get_tree().get_nodes_in_group("units"):
			if node.alignment:	# player units
				node.select()
	
	if Input.is_action_just_pressed("back_to_window"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	if Input.is_key_pressed(KEY_U):
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

# get colliding object information which mouse is clicking on
func getMouseClickCollision(viewport_click_position: Vector2):
	var world_space = get_world_3d().direct_space_state
	var ray_start = get_viewport().get_camera_3d().project_ray_origin(viewport_click_position)
	var ray_end = get_viewport().get_camera_3d().project_position(viewport_click_position, RAY_DISTANCE)
	var ray_param = PhysicsRayQueryParameters3D.new()
	ray_param.from = ray_start
	ray_param.to = ray_end
	ray_param.collide_with_areas = true
	ray_param.collision_mask = 0b00000000_00000000_00000000_10000000
	
	var result = world_space.intersect_ray(ray_param)
	if not result.is_empty():
		return result	# result = {position, normal, face_index, collider_id, shape, rid}
	else:
		return null


# places building in world
func place_spawn_point(spawn_scene: PackedScene, world_pos: Vector3):
	var spawn_point = spawn_scene.instantiate()
	# readable building name
	var base_name = spawn_point.name
	if base_name.contains("@"):
		base_name = base_name.split("@")[0]
	if not building_name_counter.has(base_name):
		building_name_counter[base_name] = 1
	else:
		building_name_counter[base_name] += 1
	spawn_point.name = base_name + str(building_name_counter[base_name])
	
	var buildings = get_node_or_null("Terrain/NavigationRegion/Buildings")
	buildings.add_child(spawn_point)
	spawn_point.global_position = world_pos
	
	# add new building to terrain object geometry
	collect_geometry_from_static_body(spawn_point, terrain_objects_geometry_shapes)
	
	# use other threads to bake nav mesh
	WorkerThreadPool.add_task(bake_nav_mesh, false, "RuntimeNavigationBaker")
	
	# connect signals
	if spawn_point.has_signal("destroyed"):
		spawn_point.destroyed.connect(onObstructionDestroyed)
		spawn_point.destroyed.connect(Callable(goal_list, "on_building_destroyed"))
	
	if spawn_point is PlayerBuilding:
		print(spawn_point.building_type, " Placed")
		spawn_point.connect("building_placed", Callable(goal_list, "on_building_placed"))
		if not defs.DEBUG_MODE:
			spawn_point.pay_for_building()
	
	if spawn_point.is_in_group("pyre_buildings"):
		spawn_point.activateSurroundingBuildings()


# bakes a new nav mesh
func bake_nav_mesh():
	# get nav mesh properties from original nav mesh
	var nav_mesh = nav_region.navigation_mesh.duplicate()
	# assign geometry to navigation mesh and bake
	NavigationMeshGenerator.bake_from_source_geometry_data(nav_mesh, terrain_objects_geometry_shapes)
	
	var weak_target = weakref(self)
	Defis.safeNavBake.call_deferred(weak_target,nav_mesh)
	
	#bake_finished.call_deferred(nav_mesh)


# finish function for baking
func bake_finished(nav_mesh: NavigationMesh):
	nav_region.navigation_mesh = nav_mesh
	

func buildGeometryFromDictionary():
	terrain_objects_geometry_shapes = collect_terrain_geometry_from_file()	# load fresh geomtry shape with only terrain geometry
	for node in terrain_obstruction_dictionary.keys():
		var data = terrain_obstruction_dictionary[node]
		terrain_objects_geometry_shapes.add_projected_obstruction(data[0], data[1], data[2], data[3])


## collects geometry of all children of a node [br]
## expensive resursion
func collect_geometry(node, geometry : NavigationMeshSourceGeometryData3D):
	if node is StaticBody3D and node.get_collision_layer_value(1):	# arrived at a static body in world layer
		for shape_owner in node.get_shape_owners():
			var shape = node.shape_owner_get_shape(shape_owner, 0)
			# only deals with conves polygon shape and box shape
			# ignores sphere shape and capsule shape and polygon shape
			if shape is ConvexPolygonShape3D:
				# not implemented
				# to implement:
					# get all vertices of the shape, find global position of the shape
					# assign a slight offset away from node global position
					# use geometry.add_projected_obstruction(shape.translated_points, node.global_position.y, 30.0, true)
				pass
				#geometry.add_faces(shape.points, node.global_transform)
			
			elif shape is BoxShape3D:	# turn into convexpolygonShape3D
				# keey track of obstructions
				var data = [boxShapeToPoints(shape, node.global_transform), node.global_position.y - 15.0, 30.0, true]
				terrain_obstruction_dictionary[node.name] = data
				geometry.add_projected_obstruction(boxShapeToPoints(shape, node.global_transform), node.global_position.y - 15.0, 30.0, true)
				#geometry.add_faces(boxShapeToPoints(shape), node.global_transform)

	# recursively call for all children
	for child in node.get_children():
		collect_geometry(child, geometry)

	store_terrain_object_geometry_to_file()


## collects geometry from the terrain geometry data file
## terrain_geometry_file_path must point to an existing file
func collect_geometry_from_file(geometry : NavigationMeshSourceGeometryData3D) -> bool:
	if not FileAccess.file_exists(terrain_object_geometry_file_path):
		return false
		
	var save_file = FileAccess.open(terrain_object_geometry_file_path, FileAccess.READ)
	terrain_obstruction_dictionary = save_file.get_var(true)
	buildGeometryFromDictionary()
	return true


## collects geometry of all nodes in static objects group [br]
## cheaper as not recursion is used
func collect_geometry_from_group(geometry : NavigationMeshSourceGeometryData3D):
	for node in get_tree().get_nodes_in_group("static_objects"):
		if node is StaticBody3D and node.get_collision_layer_value(1):	# arrived at a static body in world layer
			for shape_owner in node.get_shape_owners():
				var shape = node.shape_owner_get_shape(shape_owner, 0)
				# only deals with conves polygon shape and box shape
				# ignores sphere shape and capsule shape and polygon shape
				if shape is BoxShape3D:	# turn into convexpolygonShape3D
					# keey track of obstructions
					var data = [boxShapeToPoints(shape, node.global_transform), node.global_position.y - 15.0, 30.0, true]
					terrain_obstruction_dictionary[node.name] = data
					geometry.add_projected_obstruction(boxShapeToPoints(shape, node.global_transform), node.global_position.y - 15.0, 30.0, true)
	store_terrain_object_geometry_to_file()


## collects collision from a single static body
## ignores its child
## cheaper as no recursion
func collect_geometry_from_static_body(node : StaticBody3D, geometry : NavigationMeshSourceGeometryData3D):
	if node.get_collision_layer_value(1):	# arrived at a static body in world layer
		for shape_owner in node.get_shape_owners():
			var shape = node.shape_owner_get_shape(shape_owner, 0)
			# only deals with conves polygon shape and box shape
			# ignores sphere shape and capsule shape and polygon shape
			if shape is BoxShape3D:	# turn into convexpolygonShape3D
				# keey track of obstructions
				var data = [boxShapeToPoints(shape, node.global_transform), node.global_position.y - 15.0, 30.0, true]
				terrain_obstruction_dictionary[node.name] = data
				geometry.add_projected_obstruction(boxShapeToPoints(shape, node.global_transform), node.global_position.y - 15.0, 30.0, true)


# converts a boxShape3D into an array of points for the nav mesh with a transformation
func boxShapeToPoints(box: BoxShape3D, global_transform : Transform3D) -> PackedVector3Array:
	var offset = 0.7	# offset from walls for nav mesh to be cut out
	var half_extend = box.size / 2.0
	# apply scale
	half_extend *= global_transform.basis.get_scale()
	# add offset
	half_extend += Vector3(offset, offset, offset)
	# set points
	var lb = Vector3(-half_extend.x, 0.0, -half_extend.z)	# left back
	var rb = Vector3(half_extend.x, 0.0, -half_extend.z)	# right back
	var lf = Vector3(-half_extend.x, 0.0, half_extend.z)	# left front
	var rf = Vector3(half_extend.x, 0.0, half_extend.z)		# right front
	# apply rotation and translation
	var rotation = global_transform.basis.orthonormalized()
	lb = rotation * lb
	rb = rotation * rb
	lf = rotation * lf
	rf = rotation * rf
	# apply translation
	lb += global_transform.origin
	rb += global_transform.origin
	lf += global_transform.origin
	rf += global_transform.origin
	return PackedVector3Array([lb, rb, rf, lf])


## stores static terrain object geometry to file
## file is erased if already exist
func store_terrain_object_geometry_to_file():
	var save_file = FileAccess.open(terrain_object_geometry_file_path, FileAccess.WRITE)
	if save_file:
		save_file.store_var(terrain_obstruction_dictionary, true)


## creates and stores terrain floor geometry to file
## file is erased if already exist
func create_and_store_terrain_geometry_to_file():
	var terrain_geometry_shape = NavigationMeshSourceGeometryData3D.new()
	
	var nav_mesh = nav_region.navigation_mesh.duplicate()
	var aabb: AABB = nav_mesh.filter_baking_aabb
	aabb.position += nav_mesh.filter_baking_aabb_offset
	
	var terrain_geometry = terrain.generate_nav_mesh_source_geometry(aabb, true)
	terrain_geometry_shape.add_faces(terrain_geometry, Transform3D.IDENTITY)

	var save_file = FileAccess.open(terrain_geometry_file_path, FileAccess.WRITE)
	assert(save_file)
	save_file.store_var(terrain_geometry_shape, true)


## fetches terrain geometry variable from file
func collect_terrain_geometry_from_file() -> NavigationMeshSourceGeometryData3D:
	var save_file = FileAccess.open(terrain_geometry_file_path, FileAccess.READ)
	return save_file.get_var(true)
	

# signals

func onObstructionDestroyed(building):
	terrain_obstruction_dictionary.erase(building.name)
	buildGeometryFromDictionary()
	# use other threads to bake nav mesh
	WorkerThreadPool.add_task(bake_nav_mesh, false, "RuntimeNavigationBaker")
	
func connect_building_signals(building):
	if building.has_signal("destroyed"):
		building.connect("destroyed", Callable(self, "onObstructionDestroyed"))

func endGame(win: bool = false) ->void:
	
	if win: get_tree().change_scene_to_file("res://scenes/win_menu.tscn")
	
	else: get_tree().change_scene_to_file("res://scenes/lose_menu.tscn")
	
	
	pass
