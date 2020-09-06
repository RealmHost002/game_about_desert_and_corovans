extends  KinematicBody 
#RigidBody
#KinematicBody 
#Spatial


var acc_multiplyer = 2.0
var acc = 1.0
var resistance = 1.0
var is_active = false
var ntex
var noise
var image
var clearance = 0.0
var speed = 0
var forward
var right
var destination = Vector3(20,20,20)
var rotation_speed = 1
var abilities = ['engine','weap', 'weap', 'generator', 'shield']
var sliders = [0, 0, 0, 0, 0]

var current_pattern = 'truck'

var hp = 100
var max_hp = 100
var shield = 50
var shield_limit = 50
var energy = 100
var energy_production = 10
var shield_production = 0.05
#var direction = Vector3()


# Called when the node enters the scene tree for the first time.

		
		
func _ready():
	constants.sliders[name] = [0, 0, 0, 0, 0]
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
	ntex = preload("res://noise.tres")
	yield(ntex, "changed")
	image = ntex.get_data()
	if image:
		image.lock()
	noise = ntex.noise
	get_node("Sprite3D").material_override = get_node("Sprite3D").material_override.duplicate(true)
#	take_damage(500, "laser")
#	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed += acc * delta
	speed -= resistance * speed * speed * delta
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
	var angle_to_destination = forward.angle_to(destination - self.global_transform.origin)
	self.rotate(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * delta * clamp(angle_to_destination, 0.5, 1) * rotation_speed)
#	self.global_transform.origin += forward * delta * speed
	var s_height = 0
	if image:
#		var s_height = 0
		for wheel in get_node('wheels').get_children():
			var some_pos = Vector2(wheel.global_transform.origin.x, wheel.global_transform.origin.z) / 20.0 * 1024
			while some_pos.x >= 1024:
				some_pos.x -= 1024
			while some_pos.y >= 1024:
				some_pos.y -= 1024
			wheel.global_transform.origin.y = image.get_pixelv(some_pos).r * 3
			s_height += wheel.global_transform.origin.y
		s_height = s_height/4.0 + clearance
#		self.global_transform.origin.y = s_height
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




	self.global_transform.origin.y = s_height
	forward.y = 0.0
	move_and_slide(speed * (forward))
#	move_and_collide(speed * (forward) * delta)
	if shield < shield_limit:
		shield += shield_production
#
	
	
func destroy():
	self.queue_free()
	pass
	
func take_damage(damage, weaponType, status = "no"):
#	print(damage)
	if weaponType == "laser":
		if shield > 0:
			if damage <= shield:
				shield -= damage
				get_node("Sprite3D").material_override.set_shader_param("b", float(shield)/shield_limit)
			else:
				damage -= shield
				shield = 0
				get_node("Sprite3D").material_override.set_shader_param("b", 0)
				hp -= damage
#				print("hp =", hp," ", maxHp," ",hp/maxHp)
				
		else:
			hp -= damage
#			get_node("Sprite3D").material_override.set_shader_param("a", float(hp)/max_hp)
			if hp <=0:
					self.destroy()
		get_node("Sprite3D").material_override.set_shader_param("a", float(hp)/max_hp)

	if status != 'no':
	
		pass	
				
func ability_used(id):
	if abilities[id] == 'weap':
		var w = get_node("body/weapons").get_child(id)
		w.activate()
	if abilities[id] == 'engine':
		pass


func slider_changed(id, value):
	constants.sliders[name][id] = value
	print(constants.sliders)
	if abilities[id] == 'engine':
		acc = value / 100.0 * acc_multiplyer
		show_path()
	elif abilities[id] == 'weap':
		var w = get_node("body/weapons").get_child(id)
		w.slider_changed(value)
		pass


func pause():
	self.set_process(false)
	for w in get_node("body/weapons").get_children():
		w.set_process(false)
	show_path()

func unpause():
	if shield + energy_production > shield_limit :
		shield = shield_limit
	self.set_process(true)
	for w in get_node("body/weapons").get_children():
		if w.type == 'weapon':
			if w.target:
				w.set_process(true)
	hide_path()
	
func hide_path():
	for child in get_node("Mypath").get_children():
		child.queue_free()
	pass


func show_path():
	hide_path()
	var spd = speed
	var f = forward
	var p = self.global_transform.origin
	p.y = 2
	var c = 0
	while (p - destination).length() > 0.1:
		spd += acc * 0.1
		spd -= resistance * spd * spd * 0.1
		
		var m = MeshInstance.new()
		if c < 10 * constants.step_time:
			m.mesh = load("res://new_cubemesh_green.tres")
		else:
			m.mesh = load("res://new_cubemesh.tres")
		get_node("Mypath").add_child(m)
		m.global_transform.origin = p
		f = f.rotated(Vector3(0,1,0), sign(f.cross(destination - p).y) * 0.1 * rotation_speed)
		p += f * 0.1 * spd
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
#	print(self.get_index())
#	get_node("../../GUI/HBoxContainer").get_child(self.get_index())._on_TextureButton_pressed()
	
	if from_gui:
		constants.selectedCar = self
#		is_active = true
#		for node in get_parent().get_children():
#			if node != self:
#				node.is_active = false
	elif event.is_action('left_click'):
		constants.selectedCar = self
		get_node("../../GUI/HBoxContainer").get_child(self.get_index())._on_TextureButton_pressed()
#		if event.is_action('left_click'):
#			is_active = true
#			for node in get_parent().get_children():
#				if node != self:
#					node.is_active = false
#		constants.selectedCar = self
	

