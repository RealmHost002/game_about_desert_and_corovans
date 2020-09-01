extends Spatial

var is_active = false
var ntex
var noise
var image
var clearance = 0.1
var speed = 1
var forward
var right
var destination = Vector3(20,20,20)
var rotation_speed = 1
var abilities = ['weap', 'weap']

# Called when the node enters the scene tree for the first time.
func _ready():
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
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
#	print(self.global_transform.origin.y)
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
#	destination.y = 0.0
	var angle_to_destination = forward.angle_to(destination - self.global_transform.origin)
#	destination.y = 2
	self.rotate(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * delta * clamp(angle_to_destination, 0.5, 1) * rotation_speed)
	self.global_transform.origin += forward * delta * speed
	if image:
		var s_height = 0
		for wheel in get_node('wheels').get_children():
			var some_pos = Vector2(wheel.global_transform.origin.x, wheel.global_transform.origin.z) / 20.0 * 1024
			while some_pos.x >= 1024:
				some_pos.x -= 1024
			while some_pos.y >= 1024:
				some_pos.y -= 1024
			wheel.global_transform.origin.y = image.get_pixelv(some_pos).r * 3
			s_height += wheel.global_transform.origin.y
		s_height = s_height/4 + clearance
		self.global_transform.origin.y = s_height
#	get_node("body").rotation_degrees.x = (-get_node("wheels/fl").global_transform.origin.y - get_node("wheels/fr").global_transform.origin.y + get_node("wheels/rl").global_transform.origin.y + get_node("wheels/rr").global_transform.origin.y) * 50
#	get_node("body").rotation_degrees.z = (-get_node("wheels/fl").global_transform.origin.y + get_node("wheels/fr").global_transform.origin.y - get_node("wheels/rl").global_transform.origin.y + get_node("wheels/rr").global_transform.origin.y) * 50
	var vec1 = get_node("wheels/fr").global_transform.origin - get_node("wheels/rl").global_transform.origin
	var vec2 = get_node("wheels/fl").global_transform.origin - get_node("wheels/rr").global_transform.origin
	get_node("body").rotation = Vector3(0,0,0)
	var vec01 = vec1
	vec01.y = 0
	var vec02 = vec2
	vec01.y = 0
	var a1 = vec01.angle_to(vec1) * sign(vec1.y)
	var a2 = vec02.angle_to(vec2) * sign(vec2.y)
	get_node("body").global_rotate(vec01.cross(Vector3(0, 1, 0)).normalized(), a1)
	get_node("body").global_rotate(vec02.cross(Vector3(0, 1, 0)).normalized(), a2)


func ability_used(id):
	if abilities[id] == 'weap':
		var w = get_node("body/weapons").get_child(id)
		w.activate()
	
	pass
	
func pause():
	self.set_process(false)
	for w in get_node("body/weapons").get_children():
		w.set_process(false)
	show_path()

func unpause():
	self.set_process(true)
	for w in get_node("body/weapons").get_children():
		if w.target:
			w.set_process(true)
	hide_path()
	
func hide_path():
	for child in get_node("Mypath").get_children():
		child.queue_free()
	pass


func show_path():
	hide_path()
	var f = forward
	var p = self.global_transform.origin
	p.y = 2
	var c = 0
	while (p - destination).length() > 0.1:
		var m = MeshInstance.new()
		if c < 10 * constants.step_time:
			m.mesh = load("res://new_cubemesh_green.tres")
		else:
			m.mesh = load("res://new_cubemesh.tres")
		get_node("Mypath").add_child(m)
		m.global_transform.origin = p
		f = f.rotated(Vector3(0,1,0), sign(f.cross(destination - p).y) * 0.1 * rotation_speed)
		p += f * 0.1 * speed
		c += 1
		if c > 100:
			break
		pass
	pass




func _on_input_event(camera, event, click_position, click_normal, shape_idx, from_gui = 0):
	if !(self in get_tree().get_nodes_in_group('ally')):
		return
	if constants.input_mode != 'car_select':
		return

	if from_gui:
		constants.selectedCar = self
#		is_active = true
#		for node in get_parent().get_children():
#			if node != self:
#				node.is_active = false
	elif event.is_action('left_click'):
		constants.selectedCar = self
#		if event.is_action('left_click'):
#			is_active = true
#			for node in get_parent().get_children():
#				if node != self:
#					node.is_active = false
#		constants.selectedCar = self
