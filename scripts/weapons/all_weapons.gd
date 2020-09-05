extends Spatial

var a = 1.97
var b = 1.17


var death_zones = [Vector2(b, a), Vector2(-a,-b), Vector2(b, a)]


# Called when the node enters the scene tree for the first time.
func _ready():
	var c = 1
	for i in range(1,3,1):
#		print(i)
		pass
#		get_child(i).death_zone = death_zones[i-1]
#		c += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
