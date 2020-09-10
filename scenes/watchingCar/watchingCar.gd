extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var car
var invetoryData
var generators_data
var shields_data
var corpusData
var weapon_data
var container 

# Called when the node enters the scene tree for the first time.
func _ready():
	container = get_node("Panel/ScrollContainer/hcontainer")
	add_from_data()
	#self.add_child("res://car.tscn")
	pass # Replace with function body.

func read_data():
	var invetory_file = File.new()
	invetory_file.open("res://data/inventory.json", File.READ)
	var invetoryDataJson =JSON.parse(invetory_file.get_as_text())
	invetory_file.close()
	invetoryData = invetoryDataJson.result

func read_extra_data():
	var generators_file = File.new()
	generators_file.open("res://data/generators_data.json", File.READ)
	var generators_json =JSON.parse(generators_file.get_as_text())
	generators_file.close()
	generators_data = generators_json.result
	var shield_file = File.new()
	shield_file.open("res://data/shield_data.json", File.READ)
	var shields_data_json =JSON.parse(shield_file.get_as_text())
	shield_file.close()
	shields_data = shields_data_json.result
	var corpusFile = File.new()
	corpusFile.open("res://data/hulls_data.json", File.READ)
	var corpusDataJson =JSON.parse(corpusFile.get_as_text())
	corpusFile.close()
	corpusData = corpusDataJson.result
	var weapon_file = File.new()
	weapon_file.open("res://data/weapon_data.json", File.READ)
	var weaponDataJson = JSON.parse(weapon_file.get_as_text())
	weapon_file.close()
	weapon_data = weaponDataJson.result

func add_from_data():
	read_data()
	read_extra_data()
#	print(invetoryData)
#	print(generators_data)
	
	for i in invetoryData:		
		match invetoryData[i]["type"]:
			"weapon":
				var icon = load(weapon_data[i]["image_path"])
				var current_item = load("res://scenes/watchingCar/Item.tscn").instance()
				container.add_child(current_item)
				current_item.get_node("item_icon").texture = icon
				current_item.get_node("description").clear()
				current_item.get_node("description").add_text(weapon_data[i]["damage_type"])
				current_item.get_node("description").add_text(weapon_data[i]["damage_type"])
				current_item.get_node("description").newline()
				current_item.get_node("description").add_text("pipka")
				
			"shield":
				var icon = load(shields_data[i]["image_path"])
				var current_item = load("res://scenes/watchingCar/Item.tscn").instance()
				container.add_child(current_item)
				current_item.get_node("item_icon").texture = icon
			"generator":
				var icon = load(generators_data[i]["image_path"])
				var current_item = load("res://scenes/watchingCar/Item.tscn").instance()
				container.add_child(current_item)
				current_item.get_node("item_icon").texture = icon
			"money":
				print(invetoryData[i])
				get_node("money").text = "Money: " + str(invetoryData[i]["count"])
#func _input(event):
#	if event.is_action_pressed("open_inventory"):
#		get_tree().get_root().get_node("Spatial").remove_child(self)
#		self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
