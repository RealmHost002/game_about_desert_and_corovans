extends TextureRect


var car_inf
var scene
var items
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
	
	get_parent().get_parent().get_parent().get_node("Panel/Viewport").get_children()[-1].queue_free()
	get_parent().get_parent().get_parent().get_node("Panel/Viewport").add_child(load("res://car_base.tscn").instance())
	get_parent().get_parent().get_parent().get_node("Panel/Viewport").get_children()[-1]._load(Saveload.corpusData[car_inf["corpus"]])
	get_parent().get_parent().get_parent().get_node("Panel/Viewport").get_children()[-1].load_modules(car_inf)
	get_parent().get_parent().get_parent().get_node("Panel/Viewport").get_children()[-1].set_process(false)
	
	if get_parent().get_parent().get_parent().get_node("TextureRect").get_child(0):#blueprint
		get_parent().get_parent().get_parent().get_node("TextureRect").get_child(0).queue_free()
	scene.inf_from_dict = car_inf
	get_parent().get_parent().get_parent().get_node("TextureRect").add_child(scene)
#	print(car_inf)
	items = car_inf["weapons"]#car_inf is the stroke from the save.json file
	
