extends KinematicBody


var map_position = Vector3(-40, 0, -40)
var destination = Vector3(-30, 0, -30)
var speed = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.look_at(destination, Vector3(0,1,0))
	self.rotate_y(PI)
	self.global_transform.origin += (destination - self.global_transform.origin).normalized() * delta * speed / 300
#	print(self.global_transform.origin)
