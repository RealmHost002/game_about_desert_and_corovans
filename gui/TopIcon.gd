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
	
	if get_node("TextureRect/ReferenceRect").border_color == Color("6bff05"):
		get_parent().get_parent().get_parent().get_node('camera_look_at').global_transform.origin = Vector3(constants.selectedCar.global_transform.origin.x, 0, constants.selectedCar.global_transform.origin.z)

	
#	print(get_node("TextureRect/ReferenceRect").border_color)
	for i in get_parent().get_parent().get_node("HBoxContainer2/weaponContainer").get_children():
		i.free()
	get_tree().get_root().get_node("Spatial/cars").get_child(number)._on_input_event(0,0,0,0,0,1)
	get_parent().get_parent().AddingWeaponButtons()
	get_parent().get_child(get_parent().get_parent().selectedCar).get_node("TextureRect/ReferenceRect").border_color = Color("3412bf") 
	get_parent().get_parent().selectedCar = number
#	get_parent().get_parent().get_node("TextureRect").texture = load()
	get_node("TextureRect/ReferenceRect").border_color = Color("6bff05")
	var c = 0
	for slider in constants.sliders[constants.selectedCar.name]:
#		var sliderpos = constants.sliders[constants.selectedCar.name]
		get_node("../../HBoxContainer2/weaponContainer").get_child(c).get_node("HSlider").value = slider * 100
		c += 1
	
