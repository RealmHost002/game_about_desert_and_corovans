extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter = 0

# Called when the node enters the scene tree for the first time.

func _ready():
	AddingFuckingEgors(get_node("../cars").get_children())
	pass # Replace with function body.
func AddingFuckingEgors(a):
	for i in a:
		var TopIconScene = load("res://gui/TopIcon.tscn").instance()
		get_node("HBoxContainer").add_child(TopIconScene)
		TopIconScene.number = counter
		counter += 1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
