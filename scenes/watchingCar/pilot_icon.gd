extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var car_inf
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(car_inf["cars"])
#	print(Saveload.corpusData[car_inf["corpus"]]["blueprint"])
#	scene = load(Saveload.corpusData[car_inf["corpus"]]["blueprint"]).instance()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	scene = load(Saveload.corpusData[car_inf["corpus"]]["blueprint"]).instance()
	if get_parent().get_parent().get_parent().get_node("TextureRect").get_child(0):
		get_parent().get_parent().get_parent().get_node("TextureRect").get_child(0).queue_free()
	get_parent().get_parent().get_parent().get_node("TextureRect").add_child(scene)	
	
	pass # Replace with function body.
