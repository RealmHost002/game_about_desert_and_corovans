extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selectedWeapon = 0
var selectedCar
var is_pressable
var type = "weapon"
var _name
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TextureProgress").material = get_node("TextureProgress").material.duplicate(true)
#	get_node("TextureProgress").material.set_shader_param('a', randf())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Node2D_pressed():
#	print(self.name)
	if constants.input_mode == 'only_move':
		return
	print(self.name)
	is_pressable = constants.selectedCar.get_node("body/weapons").get_child(selectedWeapon).is_pressable
	if constants.selectedCar and is_pressable:
		constants.selectedCar.ability_used(selectedWeapon)
	constants.selected_weapon = constants.selectedCar.get_node("body/weapons").get_child(selectedWeapon)
	pass # Replace with function body.
