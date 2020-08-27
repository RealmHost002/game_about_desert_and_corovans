extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var a = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	AddingFuckingEgors(a)	
	pass # Replace with function body.
func AddingFuckingEgors(a):
	for i in a:
		var TopIconScene = load("res://gui/TopIcon.tscn").instance()
		get_node("HBoxContainer").add_child(TopIconScene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
