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
	add_fucking_Egors()
	for child in get_node("Panel/ScrollContainer/hcontainer").get_children():
		child.rect_position = Vector2(0, 148)
		
	get_node("Panel/ScrollContainer").scroll_vertical = 999
		
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

func add_fucking_Egors():
	read_data()
	for i in Saveload.ourTeamData["config"]:
		var fucking_Egor = load("res://gui/TopIcon.tscn").instance()
		get_node("Panel2/GridContainer").add_child(fucking_Egor)
		var texture = load("res://gui/textures/IconEgor.png")
		fucking_Egor.get_node("TextureRect/ReferenceRect/TextureButton").set_normal_texture(texture)
#	print(get_node("Panel2/GridContainer").get_child_count())
	
func add_from_data():
	read_data()
	read_extra_data()
	print(invetoryData)
#	print(generators_data)
	
	for i in invetoryData:		
		match invetoryData[i]["type"]:
			"weapon":
				var icon = load(weapon_data[i]["image_path"])
				var current_item = load("res://scenes/watchingCar/Item_weapon.tscn").instance()
				container.add_child(current_item)
				current_item.get_node("item_icon/count").text = str(invetoryData[i]["count"])
				current_item.get_node("item_icon").texture = icon
				var curve_dam = load(weapon_data[i]["damimage"])
				var curve_dist= load(weapon_data[i]["distimage"])
				print(curve_dam)
				current_item.distimage = curve_dist
				current_item.damimage = curve_dam
				current_item.get_node("description").clear()
				current_item.get_node("description").add_text(i  + ": ")
				current_item.get_node("description").add_text(weapon_data[i]["damage_type"])
				current_item.get_node("description").newline()
				# kurva_poshla
				current_item.get_node("description").newline()
				current_item.get_node("description").add_text("damage: 123")
				current_item.get_node("description").newline()
				current_item.get_node("description").add_text("distance: 321")

				
			"shield":
				var icon = load(shields_data[i]["image_path"])
				var current_item = load("res://scenes/watchingCar/Item.tscn").instance()
				container.add_child(current_item)
				print(str(invetoryData[i]["count"]))
				current_item.get_node("item_icon/count").text = str(invetoryData[i]["count"])
				current_item.get_node("item_icon").texture = icon
			"generator":
				
				var icon = load(generators_data[i]["image_path"])
				var current_item = load("res://scenes/watchingCar/Item.tscn").instance()
				container.add_child(current_item)
				current_item.get_node("item_icon/count").text = str(invetoryData[i]["count"])
				current_item.get_node("item_icon").texture = icon
			"money":
				print(invetoryData[i])
				get_node("money").text = "Money: " + str(invetoryData[i]["count"])
	print(get_node("Panel/ScrollContainer/hcontainer").get_child_count())
#func _input(event):
#	if event.is_action_pressed("open_inventory"):
#		get_tree().get_root().get_node("Spatial").remove_child(self)
#		self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
