extends Node

var ourTeamData
var corpusData
var weapon_data
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
	for i in ourTeamData['config']:
		var base_scene = load("res://car_base.tscn").instance()
		get_tree().get_root().get_node("Spatial/cars").add_child(base_scene)
#		print(corpusData)
		base_scene._load(corpusData[i["corpus"]])
		base_scene.remove_from_group("enemy")
		base_scene.add_to_group('ally')
		base_scene.load_modules(i)
		base_scene.global_transform.origin = position
		base_scene.scale = Vector3(0.1, 0.1, 0.1)
		position += Vector3(3,0,3)
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
