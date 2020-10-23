extends KinematicBody


var map_position = Vector3(-40, 0, -40)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_transform.origin += Vector3(1,0,0) * delta / 10.0
