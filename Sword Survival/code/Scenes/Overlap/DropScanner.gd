extends Area2D

# scene
onready var Player = get_parent()

# child
onready var collision = $CollisionShape2D

# tracker
var closest = null # closest object
var closest_ref = null # closest object reference, used to check if object is freed

func _process(delta):
	if closest_ref != null and !closest_ref.get_ref():
		# closest object is freed
		closest = null
	if closest != get_closest_collider():
		if closest != null:
			closest.remove_highlight()
		closest = get_closest_collider()
		closest_ref = weakref(get_closest_collider())
		if closest != null:
			closest.highlight()
	if Input.is_action_just_pressed("interact"): # picking up weapon
		if closest != null and closest_ref.get_ref():
			closest.pickup()
			closest = get_closest_collider()
			if closest != null:
				closest_ref = weakref(closest)
			else:
				closest_ref = null

func get_closest_collider():
	var closest_collider = null
	var overlapping = self.get_overlapping_bodies()
	if !overlapping.empty():
		closest_collider = overlapping[0]
		for object in overlapping:
			if self.global_position.distance_to(closest_collider.position) > self.global_position.distance_to(object.position):
				closest_collider = object
	return closest_collider
