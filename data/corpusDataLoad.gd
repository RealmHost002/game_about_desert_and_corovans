extends Node

var corpusData
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var corpusFile = File.new()
	corpusFile.open("res://data/corpuses.json", File.READ)
	var corpusDataJson =JSON.parse(corpusFile.get_as_text())
	corpusFile.close()
	corpusData = corpusDataJson.result
	
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
