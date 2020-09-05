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
	
	print(ourTeamData["laserGun"]["dot_position"])
	print(typeof(ourTeamData["laserGun"]["dot_position"]))
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
