extends KinematicBody


var m_pos = Vector3(-40, 0, -40)
var destination = Vector3(-31, 0, -30)
var speed = 10
var wheel_height = 0
var cars = []
var path = []
var nav

var player = false
var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	nav = get_parent().get_parent().get_node('Navigation')
	if get_index() == 0:
		player = true
		speed = 30
	pass # Replace with function body.


func set_path(dest):
	path = nav.get_simple_path(self.transform.origin / 333, dest)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !path and nav and !player:

#		path = nav.get_simple_path(self.transform.origin / 333, destination)
		set_path(destination)

		
	if !path:
		return
		
	if (self.transform.origin / 333.0 - path[0]).length() < 0.0001:
		path.remove(0)
		if !path:
			return
	var d = path[0]
	self.look_at(d + m_pos, Vector3(0,1,0))
	self.rotate_y(PI)
	self.transform.origin += (d - self.transform.origin / 333).normalized() * delta * speed




func pause():
	self.set_process(false)


func unpause():
	self.set_process(true)












func _load(params):
	destination = Vector3(params['destination'][0],0, params['destination'][1])
	self.transform.origin = Vector3(params['position'][0],0, params['position'][1]) * 333
	cars = params['enemy_cars']
	_load_body(cars[0])
	pass


func _load_body(params):

	params = Saveload.corpusData[params['corpus']]
	get_node("body").mesh = load(params['body'])
	var wp = params['wheel_pos']
#	if params['body'] == "res://models/cyclopus/body.tres":
#		anim = 'truck'
	
	
	
	get_node("wheels/fl").mesh = load(params['wheelFront'])
	get_node("wheels/fl").transform.origin = Vector3(wp[0], 0, wp[1])
	get_node("wheels/fr").mesh = load(params['wheelFront'])
	get_node("wheels/fr").transform.origin = Vector3(-wp[0], 0, wp[1])
	get_node("wheels/rl").mesh = load(params['wheelBack'])
	get_node("wheels/rl").transform.origin = Vector3(wp[2], 0, wp[3])
	get_node("wheels/rr").mesh = load(params['wheelBack'])
	get_node("wheels/rr").transform.origin = Vector3(-wp[2], 0, wp[3])
	if wp[4] == 0:
		get_node("wheels/ml").hide()
		get_node("wheels/mr").hide()
	get_node("wheels/ml").mesh = load(params['wheelBack'])
	get_node("wheels/ml").transform.origin = Vector3(wp[4], 0, wp[5])
	get_node("wheels/mr").mesh = load(params['wheelBack'])
	get_node("wheels/mr").transform.origin = Vector3(-wp[4], 0, wp[5])
	
	
	self.wheel_height = params['wheel_height']




func _encounter(camera, event, click_position, click_normal, shape_idx):
	return
	if event.is_action('left_click'):
		for car in cars:
			Saveload.ourTeamData["config"].append(car)
		Saveload.read_data(Saveload.ourTeamData)

		pass
	pass # Replace with function body.


func _on_Area_area_entered(area):
	if active and player:
		active = false
		get_parent().get_parent().PAUSE()
		for car in area.get_parent().cars:
			Saveload.ourTeamData["config"].append(car)
		Saveload.read_data(Saveload.ourTeamData)

	pass # Replace with function body.
