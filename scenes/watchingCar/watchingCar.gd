extends Control

var car
var invetoryData
var generators_data
var shields_data
var corpusData
var weapon_data
var container 
var taken_node
var current_button
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
#		print(i)
		var fucking_Egor = load("res://scenes/watchingCar/pilot_icon.tscn").instance()
		fucking_Egor.car_inf = i
		get_node("Panel2/GridContainer").add_child(fucking_Egor)
		var texture = load("res://gui/textures/IconEgor.png")
		fucking_Egor.get_node("TextureRect/ReferenceRect/TextureButton").set_normal_texture(texture)
		
#	print(get_node("Panel2/GridContainer").get_child_count())
	
func add_from_data():
	read_data()
	read_extra_data()
	update()
#	print(invetoryData)
#	print(generators_data)
func update():
	for child in get_node("Panel/ScrollContainer/hcontainer").get_children():
		child.queue_free()
#	print("piiiiiiiiiiiiiizda ",invetoryData)
	for i in invetoryData:
		if invetoryData[i]["count"] > 0:
			match invetoryData[i]["type"]:
				"weapon":
					var icon = load(weapon_data[i]["image_path"])
					var current_item = load("res://scenes/watchingCar/Item_weapon.tscn").instance()
					container.add_child(current_item)
					current_item.get_node("item_icon/count").text = str(invetoryData[i]["count"])
					current_item.get_node("item_icon").texture = icon
					var curve_dam = load(weapon_data[i]["damimage"])
					var curve_dist= load(weapon_data[i]["distimage"])
	#				print(curve_dam)
					current_item.distimage = curve_dist
					current_item.damimage = curve_dam
					current_item.name_of_weapon_string = i
					current_item.weapon_data = weapon_data
					current_item.set_desc()
					
				"shield":
					var icon = load(shields_data[i]["image_path"])
					var current_item = load("res://scenes/watchingCar/Item_weapon.tscn").instance()
					current_item.type = "item"
					current_item.subtype = "shield"
					container.add_child(current_item)
					print(str(invetoryData[i]["count"]))
					current_item.get_node("item_icon/count").text = str(invetoryData[i]["count"])
					current_item.get_node("item_icon").texture = icon
					current_item.name_of_weapon_string = i
					current_item.set_desc()
					if i == "zzzConvergenator_mk3":
						current_item.hide()
				"generator":
					var icon = load(generators_data[i]["image_path"])
					var current_item = load("res://scenes/watchingCar/Item_weapon.tscn").instance()
					current_item.type = "item"
					current_item.subtype = "generator"
					container.add_child(current_item)
					current_item.get_node("item_icon/count").text = str(invetoryData[i]["count"])
					current_item.get_node("item_icon").texture = icon
					current_item.name_of_weapon_string = i
					current_item.set_desc()
					if i == "zzzConvergenator_mk3":
						current_item.hide()
				"money":
#					print(invetoryData[i])
					get_node("money").text = "Money: " + str(invetoryData[i]["count"])
			
#	print(get_node("Panel/ScrollContainer/hcontainer").get_child_count())

	var invetory_file = File.new()
	invetory_file.open("res://data/inventory.json", File.WRITE)
	invetory_file.store_string(to_json(invetoryData))
	invetory_file.close()

func _input(event):
	if event.is_action_released("left_click") and current_button and taken_node:
		taken_node.pop_one() # invetoryData[i]['count'] -= 1
#		print("zalupa")
#		print(taken_node.type)
#		print(typeof(taken_node))
		current_button.change_item(taken_node)
		update()

#		taken_node.pop_one()

#func _input(event):
#	if event.is_action_pressed("open_inventory"):
#		get_tree().get_root().get_node("Spatial").remove_child(self)
#		self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
