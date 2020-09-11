extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damimage
var distimage 
var i 
var weapon_data
# Called when the node enters the scene tree for the first time.
func _ready():
	var desc = get_node("description")
	desc.newline()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_HSlider_value_changed(value):
	get_node("item_icon/HSlider/Label").text = str(get_node("item_icon/HSlider").value) + "%"
	
	
	var distance = distimage.curve.interpolate(value / 100.0)
	var damage = damimage.curve.interpolate(value / 100.0)
	var desc = get_node("description")
	desc.clear()
	desc.add_text(i  + ": ")
	desc.add_text(weapon_data[i]["damage_type"])
	desc.newline()
	# kurva_poshla
	desc.newline()
	desc.add_text("damage: " + str(damage))
	desc.newline()
	desc.add_text("distance: " + str(distance))

