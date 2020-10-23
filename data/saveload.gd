extends Node

var ourTeamData
var corpusData
var weapon_data
var generators_data
var shields_data
var save_world
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var position = Vector3(3, 3, 3)

# Called when the node enters the scene tree for the first time.
func _ready():
	var saveFile = File.new()
	saveFile.open("res://data/save.json", File.READ)
	var ourTeamDataJson =JSON.parse(saveFile.get_as_text())
	saveFile.close()
	ourTeamData = ourTeamDataJson.result
	var save_world_file = File.new()
	save_world_file.open("res://data/save_world.json", File.READ)
	var save_world_json =JSON.parse(save_world_file.get_as_text())
	save_world_file.close()
	save_world = save_world_json.result
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
#	print(corpusData, corpusDataJson.result)
	var weapon_file = File.new()
	weapon_file.open("res://data/weapon_data.json", File.READ)
	var weaponDataJson = JSON.parse(weapon_file.get_as_text())
	weapon_file.close()
	weapon_data = weaponDataJson.result
#	call_deferred('read_data', ourTeamData)
	read_data(ourTeamData)
	_load_on_map()
	
	
func read_data(ourTeamData):
	var c = 0
	for i in ourTeamData['config']:
		var base_scene = load("res://car_base.tscn").instance()
		get_tree().get_root().get_node("Spatial/cars").add_child(base_scene)
		base_scene.set_owner(get_tree().get_root().get_node("Spatial/cars"))
		base_scene._load(corpusData[i["corpus"]])
#		base_scene.remove_from_group("enemy")
		if c < 4:
			base_scene.remove_from_group("enemy")
			base_scene.add_to_group('ally')
			base_scene.is_enemy = false
#		else:
#			base_scene.add
		base_scene.load_modules(i)
		base_scene.global_transform.origin = position
		base_scene.scale = Vector3(0.1, 0.1, 0.1)
		if c == 3:
			position += Vector3(20,0,-10)
		if c < 4:
			position += Vector3(0,0,3)
#			base_scene.add_to_group
		else:
			position += Vector3(0,0,3)
		c += 1
#	pass # Replace with function body.
func _load_on_map():
	for corovan_record in save_world:
		var buf = load("res://car_for_map.tscn").instance()
		get_tree().get_root().get_node("Spatial/map/corovans").add_child(buf)
		buf._load(corovan_record)
		
func _save_on_map():
	var save_file = File.new()
	save_file.open("res://data/save_world.json", File.WRITE)
	save_file.store_string('[')
	var corovans_on_map = []
	for corovan in get_tree().get_root().get_node("Spatial/map/corovans").get_children():
		var position = [corovan.global_transform.origin.x, corovan.global_transform.origin.z]
		var destination = [corovan.destination.x, corovan.destination.z]
		var cars = corovan.cars 
#		corovans_on_map.append({"position":position,"destination":destination,"enemy_cars":cars})
		var some = {"position":position,"destination":destination,"enemy_cars":cars}
		save_file.store_string(to_json(some))
		save_file.store_string(',\n')
	save_file.store_string(']')
#	save_file.store_string(to_json(corovans_on_map))
	save_file.close()
	
	
func _update():
	var save_file = File.new()
	save_file.open("res://data/save.json", File.WRITE)
	save_file.store_string(to_json(ourTeamData))
	save_file.close()

func _input(event):
	if event.is_action_pressed("test_button"):
		print('pipiska')
		_save_on_map()
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
