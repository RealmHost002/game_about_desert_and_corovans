extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var number

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("pipka")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_TextureButton_pressed():
#	print("hui" + str(number))
	for i in get_parent().get_parent().get_node("HBoxContainer2/weaponContainer").get_children():
		i.queue_free()
	get_parent().get_parent().AddingWeaponButtons()
	get_tree().get_root().get_node("Spatial/cars").get_child(number)._on_input_event(0,0,0,0,0,1)
#	get_parent().get_parent().selectedCar = number
	
	pass # Replace with function body.