extends Control


# Declare member variables here. Examples:
# var a = 2
var super_parent
var damimage
var distimage 
var name_of_weapon_string 
var weapon_data
var type = "weapon"
var is_taken = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var desc = get_node("description")
	desc.newline()
	super_parent = get_parent().get_parent().get_parent().get_parent()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_desc():
	get_node("item_icon/HSlider/Label").text = str(get_node("item_icon/HSlider").value) + "%"
		
	var desc = get_node("description")
	if type == "weapon":
		desc.clear()
		desc.add_text(name_of_weapon_string   + ": ")
		desc.add_text(weapon_data[name_of_weapon_string]["damage_type"])
		desc.newline()
		var distance = distimage.curve.interpolate(100 / 100.0)
		var damage = damimage.curve.interpolate(100 / 100.0)
		desc.newline()
		desc.add_text("damage: " + str(damage))
		desc.newline()
		desc.add_text("distance: " + str(distance))
	if type == "shield":
		desc.clear()
		desc.add_text(name_of_weapon_string   + ": shield")
		desc.newline()
		desc.add_text("max_value: " + str(Saveload.shields_data[name_of_weapon_string]["max_value"]))
		desc.newline()
		desc.add_text("energy_cost: " + str(Saveload.shields_data[name_of_weapon_string]["energy_cost"]))
		
	if type == "generator":
		desc.clear()
		desc.add_text(name_of_weapon_string   + ": generator")
		desc.newline()
		desc.add_text("production: " +str(Saveload.generators_data[name_of_weapon_string]["energy_production"]))
		desc.newline()
		desc.add_text("max_energy: " + str(Saveload.generators_data[name_of_weapon_string]["max_energy"]))


#func _on_HSlider_value_changed(value):
#	get_node("item_icon/HSlider/Label").text = str(get_node("item_icon/HSlider").value) + "%"
#
#	var desc = get_node("description")
#	if type == "weapon":
#		desc.clear()
#		desc.add_text(name_of_weapon_string   + ": ")
#		desc.add_text(weapon_data[name_of_weapon_string]["damage_type"])
#		desc.newline()
#	# kurva_poshla
#
#		var distance = distimage.curve.interpolate(value / 100.0)
#		var damage = damimage.curve.interpolate(value / 100.0)
#		desc.newline()
#		desc.add_text("damage: " + str(damage))
#		desc.newline()
#		desc.add_text("distance: " + str(distance))

func _input(event):
	if is_taken and event is InputEventMouseMotion:
		self.rect_position = event.position
	if is_taken and event.is_action_released('left_click'):
		super_parent.invetoryData[name_of_weapon_string]['count'] += 1
		super_parent.update()
		call_deferred('queue_free')
		pass

func pop_one():
	super_parent.invetoryData[name_of_weapon_string]['count'] -= 1
	
func _take(event):
	if event.is_action_pressed('left_click'):
		var target = super_parent
		var source = self
		get_parent().remove_child(source)
		target.add_child(source)
		source.set_owner(target)
		self.mouse_filter = MOUSE_FILTER_IGNORE
		get_node("item_icon").mouse_filter = MOUSE_FILTER_IGNORE
		get_node("item_icon/ReferenceRect").mouse_filter = MOUSE_FILTER_IGNORE
		get_node("description").hide()
		get_node("RichTextLabel").hide()
		super_parent.invetoryData[name_of_weapon_string]['count'] -= 1
		is_taken = true
		super_parent.taken_node = self
		super_parent.update()



