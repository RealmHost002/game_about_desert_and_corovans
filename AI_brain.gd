extends Spatial


var player_clusters = []
var machine_clusters = []
var player_cars_which_in_clusters = []
var machine_cars_which_in_clusters = []
var player_clusters_midpoints = []
var machine_clusters_midpoints = []


var truck_pos = Vector3()
var truck_pos_end_turn = Vector3()
var truck
# Called when the node enters the scene tree for the first time.
func _ready():
	truck = get_child(get_child_count() - 1)
	pass # Replace with function body.

func create_cluster(first_car, dist, chain = 1, arr = []):
#	var arr = []
	var pos = first_car.global_transform.origin
	if !(first_car in arr):
		arr.append(first_car)
#	player_cars_which_in_clusters.append(first_car)
	for p_car in get_tree().get_nodes_in_group('ally'):
		if (p_car.global_transform.origin - pos).length() < dist and p_car != first_car and !(p_car in player_cars_which_in_clusters):
			player_cars_which_in_clusters.append(p_car)
			if chain:
				var result = create_cluster(p_car, dist, 1, arr)
				if result:
					arr = result
#			else:
#				arr.append(p_car)
#		print('aft  ', arr)
	if arr.size() > 0:
		player_cars_which_in_clusters.append(first_car)
		return(arr)
		
		
func create_counter_cluster(cluster_to_counter):
	var arr = []
	var c = 0
	for p_car in cluster_to_counter:
		for m_car in get_tree().get_nodes_in_group('enemy'):
			if !(m_car in machine_cars_which_in_clusters):
				if m_car.body_type != 'truck' and p_car.weapon_type == 'close' and (m_car.weapon_type == 'close' or m_car.weapon_type == 'mid'):
					arr.append(m_car)
					machine_cars_which_in_clusters.append(m_car)
					break
	print(arr)
	machine_clusters.append(arr)
#	while arr.size() < cluster_to_counter.size():
#		if !(get_tree().get_nodes_in_group('enemy')[c] in machine_cars_which_in_clusters):
#			arr.append(get_tree().get_nodes_in_group('enemy')[c])
#			machine_cars_which_in_clusters.append(get_tree().get_nodes_in_group('enemy')[c])
#		c += 1
#		if c >= get_tree().get_nodes_in_group('enemy').size()-1:
#			break
#	machine_clusters.append(arr)



func calc_midpont(arr):
	var pos = Vector3(0,0,0)
#	var c = 0
	for car in arr:
		pos += car.global_transform.origin
#		c += 1
	return(pos / arr.size())

func _process(delta):
	player_clusters = []
	machine_clusters = []
	player_cars_which_in_clusters = []
	machine_cars_which_in_clusters = []
	player_clusters_midpoints = []
	machine_clusters_midpoints = []
	
	for p_car in get_tree().get_nodes_in_group('ally'):
		if !(p_car in player_cars_which_in_clusters):
			var result = create_cluster(p_car, 3.0)
			if result:
				player_clusters.append(result)
				
#	print('p   ',player_clusters)

	for cluster in player_clusters:
		player_clusters_midpoints.append(calc_midpont(cluster))
		create_counter_cluster(cluster)
		
#	print('m     ',machine_clusters)

	truck_pos = truck.global_transform.origin
	var c = 0
	for cluster in machine_clusters:
		var vec_to_p_cluster = player_clusters_midpoints[c] - truck_pos
		var pos = truck_pos + vec_to_p_cluster.normalized() * 3.0
		machine_clusters_midpoints.append(pos)
		var c_2 = 0
		for machine in cluster:
			machine.destination = pos + vec_to_p_cluster.cross(Vector3(0, 1, 0)).normalized() * 2.0 * (c_2 - cluster.size() / 2)
			c_2 += 1
		c += 1



