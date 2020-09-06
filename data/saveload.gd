extends Node

var ourTeamData
var corpusData
var weapon_data
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var saveFile = File.new()
	saveFile.open("res://data/save.json", File.READ)
	var ourTeamDataJson =JSON.parse(saveFile.get_as_text())
	saveFile.close()
	ourTeamData = ourTeamDataJson.result
	var corpusFile = File.new()
	corpusFile.open("hulls_data.json", File.READ)
	var corpusDataJson =JSON.parse(corpusFile.get_as_text())
	corpusFile.close()
	corpusData = corpusDataJson.result
	var weapon_file = File.new()
	weapon_file.open("weapon_data.json", File.READ)
	var weaponDataJson = JSON.parse(weapon_file.get_as_text())
	weapon_file.close()
	weapon_data = weaponDataJson.result

	read_data(ourTeamData)
	
func read_data(ourTeamData):
	for i in ourTeamData:
		var base_scene = load("res://car_base.tscn")
		get_tree().get_root().get_node("cars").add_child(base_scene)
		base_scene._load(corpusData[i["corpus"]])
		base_scene.load_modules(i)
		
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
