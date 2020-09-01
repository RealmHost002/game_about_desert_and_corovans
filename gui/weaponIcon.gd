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
	selectedCar = get_parent().get_parent().get_parent().selectedCar
	get_tree().get_root().get_node("Spatial/cars").get_child(selectedCar).ability_used(selectedWeapon)
	pass # Replace with function body.
