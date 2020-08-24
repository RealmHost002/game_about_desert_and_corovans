extends Spatial


var ntex
var noise
var image
var clearance = 0.1
var speed = 1
var forward
var right
var destination = Vector3(0,0,0)
var rotation_speed = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	ntex = preload("res://noise.tres")
	yield(ntex, "changed")
	image = ntex.get_data()
	if image:
		image.lock()
	noise = ntex.noise
#	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
	var angle_to_destination = forward.angle_to(destination - self.global_transform.origin)
#	print(angle_to_destination)
#	if angle_to_destination > 0.1:
	self.rotate(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * delta * clamp(angle_to_destination, 0.5, 1) * rotation_speed)
#	elif angle_to_destination > 0.05:
#		self.rotate(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * angle_to_destination / 2.0)
	self.global_transform.origin += forward * delta * speed
	if image:
		var s_height = 0
		for wheel in get_node('wheels').get_children():
			var some_pos = Vector2(wheel.global_transform.origin.x, wheel.global_transform.origin.z) / 20.0 * 1024
			wheel.global_transform.origin.y = image.get_pixelv(some_pos).r * 3
			s_height += wheel.global_transform.origin.y
		s_height = s_height/4 + clearance
		self.global_transform.origin.y = s_height
	get_node("body").rotation_degrees.x = (-get_node("wheels/fl").global_transform.origin.y - get_node("wheels/fr").global_transform.origin.y + get_node("wheels/rl").global_transform.origin.y + get_node("wheels/rr").global_transform.origin.y) * 50
#	get_node("body").rotation_degrees.z = (-get_node("wheels/fl").global_transform.origin.y + get_node("wheels/fr").global_transform.origin.y - get_node("wheels/rl").global_transform.origin.y + get_node("wheels/rr").global_transform.origin.y) * 50



func show_path():
	var f = forward
	var p = self.global_transform.origin
	p.y = 2
	var c = 0
	while (p - destination).length() > 0.1:
		var m = MeshInstance.new()
		m.mesh = load("res://new_cubemesh.tres")
		get_parent().add_child(m)
		m.global_transform.origin = p
		f = f.rotated(Vector3(0,1,0), sign(f.cross(destination - p).y) * 0.1 * rotation_speed)
		p += f * 0.1 * speed
		print((p - destination).length())
		c += 1
		if c > 1000:
#			print(1)
			break
		pass
	pass



func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		destination = click_position
		destination.y = 2
		var m = MeshInstance.new()
		m.mesh = load("res://new_cubemesh.tres")
		get_parent().add_child(m)
		m.global_transform.origin = destination
		show_path()
