extends Node


# Declare member variables here. Examples:
var start_date = 0
var quest_caravan_presistance
var data
var pay_or_gtfo

# Called when the node enters the scene tree for the first time.
func _ready():
	var saveFile = File.new()
	saveFile.open("res://quests/introduction.json", File.READ)
	var Parse_result = JSON.parse(saveFile.get_as_text())
	saveFile.close()
	data = Parse_result.result
#	print(data)
	self.add_child(load("res://scenes/dialog/Node2D.tscn").instance())
#	_save()
	pass # Replace with function body.


func _load():
#	pay_or_gtfo = data['pay_or_gtfo']
#	quest_caravan_presistance = data
	pass

func _save():
	var save_file = File.new()
	save_file.open("res://quests/introduction.json", File.WRITE)
	save_file.store_string(to_json(data))
	save_file.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
