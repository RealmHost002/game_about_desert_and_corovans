extends Node

var ourTeamData
var corpusData
var weapon_data
var generators_data
var shields_data
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
func _update():
	var save_file = File.new()
	save_file.open("res://data/save.json", File.WRITE)
	save_file.store_string(to_json(ourTeamData))
	save_file.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
