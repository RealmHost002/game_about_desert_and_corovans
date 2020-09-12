extends Control


# Declare member variables here. Examples:
# var a = 2
var super_parent
var damimage
var distimage 
var i 
var weapon_data
var type = "weapon"
var is_taken = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var desc = get_node("description")
	desc.newline()
	super_parent = get_parent().get_parent().get_parent().get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_HSlider_value_changed(value):
	get_node("item_icon/HSlider/Label").text = str(get_node("item_icon/HSlider").value) + "%"
		
	var desc = get_node("description")
	if type == "weapon":
		desc.clear()
		desc.add_text(i  + ": ")
		desc.add_text(weapon_data[i]["damage_type"])
		desc.newline()
	# kurva_poshla

		var distance = distimage.curve.interpolate(value / 100.0)
		var damage = damimage.curve.interpolate(value / 100.0)
		desc.newline()
		desc.add_text("damage: " + str(damage))
		desc.newline()
		desc.add_text("distance: " + str(distance))

func _input(event):
	if is_taken and event is InputEventMouseMotion:
		self.rect_position = event.position
	if is_taken and event.is_action_released('left_click'):
		super_parent.invetoryData[i]['count'] += 1
		super_parent.update()
		call_deferred('queue_free')
		pass
	
	
func _take(event):
	if event.is_action_pressed('left_click'):
		var target = super_parent
		var source = self
		print(str(super_parent.invetoryData[i]['count']) + "pisos")
		get_parent().remove_child(source)
		target.add_child(source)
		source.set_owner(target)
		self.mouse_filter = MOUSE_FILTER_IGNORE
		get_node("item_icon").mouse_filter = MOUSE_FILTER_IGNORE
		get_node("item_icon/ReferenceRect").mouse_filter = MOUSE_FILTER_IGNORE
		get_node("description").hide()
		get_node("RichTextLabel").hide()
		print(str(super_parent.invetoryData[i]['count']) + "pisos")
		super_parent.invetoryData[i]['count'] -= 1
		is_taken = true
		super_parent.taken_node = self
		
			
		super_parent.update()
	
#		else:
#			var new_node = self.duplicate()
#			super_parent.add_child(new_node)
#			new_node.is_taken = true
#			super_parent.taken_node = new_node
#			new_node.i = self.i
#			new_node.type = self.type
#			new_node.mouse_filter = MOUSE_FILTER_PASS
#			new_node.get_node("item_icon").mouse_filter = MOUSE_FILTER_IGNORE
#			new_node.get_node("item_icon/ReferenceRect").mouse_filter = MOUSE_FILTER_IGNORE
#			new_node.get_node("description").hide()
#			new_node.get_node("RichTextLabel").hide()
			
			
			
			
			
			
		


