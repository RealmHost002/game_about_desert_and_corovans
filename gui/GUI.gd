extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#var counter = 0
var selectedCar = 0

# Called when the node enters the scene tree for the first time.

func _ready():
#	print(get_tree().get_nodes_in_group('ally').size())
	AddingFuckingEgors(get_tree().get_nodes_in_group('ally').size())
	AddingWeaponButtons()
	pass # Replace with function body.
func AddingFuckingEgors(a):
	var counter = 0
	for i in a:
		var TopIconScene = load("res://gui/TopIcon.tscn").instance()
		get_node("HBoxContainer").add_child(TopIconScene)
		TopIconScene.number = counter
		counter += 1

func AddingWeaponButtons():
	if !constants.selectedCar:
		return
	var counter = 0
	
	var weapons = constants.selectedCar.get_node("body/weapons").get_children()
	for i in weapons:
		var WeaponIconScene = load("res://gui/weaponIcon.tscn").instance()
		get_node("HBoxContainer2/weaponContainer").add_child(WeaponIconScene)
		WeaponIconScene.selectedWeapon = counter
		print(str(counter) + "chlen")
		counter += 1
		
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
