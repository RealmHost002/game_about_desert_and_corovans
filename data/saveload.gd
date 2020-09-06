extends Node

var ourTeamData
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
	read_data(ourTeamData)


	
func read_data(ourTeamData):
	for i in ourTeamData:
		var base_scene = load("res://car_base.tscn")
		get_tree().get_root().get_node("cars").add_child(base_scene)
		var hull = i["corpus"]
		var params = get_node("res://data/corpusDataLoad.gd").corpusData[hull]
		base_scene._load(params)
		var weapons = get_node("res://data/weapon_load.gd").weapon_data[i["weapons"]]
		base_scene.load_modules(weapons)
		
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
