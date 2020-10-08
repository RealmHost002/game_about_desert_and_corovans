extends Control


var choosen_car
var second_button_expanded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
#	InputEventMouseMotion
	if !(event is InputEventMouseMotion) and !event.is_action_pressed('left_click'):
		self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func expand():
	second_button_expanded = true
	pass







func _on_TextureButton1_pressed():
	constants.selectedCar.hide_enemies()
	constants.selectedCar.attack_with_all_weapons(choosen_car)
	constants.selectedCar.show_enemies()


func _on_TextureButton2_pressed(extra_arg_0):
	constants.selectedCar.set_target_to_follow(choosen_car, extra_arg_0)
	constants.selectedCar.show_path()


func _on_TextureButton3_pressed():
	constants.selectedCar.set_target_to_approach(choosen_car)
	constants.selectedCar.show_path()



func _on_TextureButton2_mouse_entered():
	pass # Replace with function body.


func _on_UP_pressed(extra_arg_0):
	print(extra_arg_0)
	pass # Replace with function body.
