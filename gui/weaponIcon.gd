extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selectedWeapon = 0
var selectedCar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Node2D_pressed():
	if constants.selectedCar:
		constants.selectedCar.ability_used(selectedWeapon)
	pass # Replace with function body.
