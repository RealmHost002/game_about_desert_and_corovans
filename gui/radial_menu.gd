extends Control


var choosen_car


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
#	InputEventMouseMotion
	if !(event is InputEventMouseMotion) and !event.is_action_pressed('left_click'):
		self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton1_pressed():
	constants.selectedCar.hide_enemies()
	constants.selectedCar.attack_with_all_weapons(choosen_car)
	constants.selectedCar.show_enemies()
	pass # Replace with function body.


func _on_TextureButton2_pressed():
#	constants.selectedCar.target_to_follow = choosen_car
#	constants.selectedCar.current_move = 'follow'
#	constants.selectedCar.destination = choosen_car.global_transform.origin
	constants.selectedCar.set_target_to_follow(choosen_car)
	constants.selectedCar.show_path()
	pass # Replace with function body.


func _on_TextureButton3_pressed():
#	constants.selectedCar.target_to_follow = choosen_car
#	constants.selectedCar.current_move = 'approach'
#	constants.selectedCar.destination = choosen_car.global_transform.origin
	constants.selectedCar.set_target_to_approach(choosen_car)
	constants.selectedCar.show_path()
	pass # Replace with function body.
