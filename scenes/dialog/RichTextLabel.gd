extends RichTextLabel

var my_text
var waiting = 100
var char_counter = 0
var mode = "text"
var tag = "none"
var tag_value
var default_time = 0.1
var buf_time
var buf_pause
var quest

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("textTimer").wait_time = default_time
	var textdata = File.new()
	textdata.open("res://scenes/dialog/example.txt", File.READ)
	my_text = textdata.get_as_text()
	textdata.close()
	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if mode == "waiting" and event.is_action_pressed('left_click'):
		self.clear()
		mode = "text"
		char_counter += 1
		read_dialog(char_counter)
		
func pause():
	mode = "text"
	print("pause")
	tag = "none"
	tag_value = ""
	get_node("pauseTimer").stop()
	read_dialog(char_counter)
	
func parse_code():
	if tag == "none":
		match my_text[char_counter]:
			"t": tag = "t"
			"p": tag = "p"
			"c": tag = "c"
			"a": tag = "a"
			"g": tag = "g"
			"b": tag = "b"
			"q": tag = "q"
			"G": 
				char_counter = my_text.find(">", char_counter)
				mode = "text"
			_: 
				print("Error, can't find this tag:'", my_text[char_counter], "'")
				self.append_bbcode("[color=red]Error, can't find this tag[/color]")
		tag_value = ""
	else:
		match tag:
			"t":
				if my_text[char_counter] == ">":
					mode = "making"
				else:
					tag_value += my_text[char_counter]
			"p":
				if my_text[char_counter] == ">":
					mode = "making"
				else:
					tag_value += my_text[char_counter]
			"c":
				if my_text[char_counter] == ">":
					mode = "making"
				else:
					tag_value += my_text[char_counter]
			"a":
				if my_text[char_counter] == ">":
					mode = "making"
				else:
					tag_value += my_text[char_counter]
			"g":
				if my_text[char_counter] == ">":
					mode = "making"
				else:
					tag_value += my_text[char_counter]
			"b":
				if my_text[char_counter] == ">":
					mode = "making"
			"q":
				if my_text[char_counter] == ">":
					mode = "making"
				else:
					tag_value += my_text[char_counter]
	char_counter += 1
	read_dialog(char_counter)

func make_buttons(inf):
	var new_button = load("res://scenes/dialog/answer_button.tscn").instance()
	get_node("ButtonContainer").add_child(new_button)
	new_button.link = inf.split("&")[0]
	new_button.text = inf.split("&")[1]
	tag = "none"
	mode = "text"
	tag_value = ""


func making():
	match tag:
		"t":
			if tag_value == "":
				get_node("textTimer").wait_time = default_time
				
			else:
				 get_node("textTimer").wait_time = float(tag_value)
			mode = "text"
			tag = "none"
			tag_value = ""
			read_dialog(char_counter)
		"p":
			if tag_value == "":
				get_node("pauseTimer").wait_time = 1
				get_node("pauseTimer").start()
			else:
				get_node("pauseTimer").wait_time = float(tag_value)
				get_node("pauseTimer").start()
		"g":
			mode = "text"
			tag = "none"
			var substring = "<G" + tag_value +">"
			tag_value = ""
			char_counter = my_text.find(substring)
			read_dialog(char_counter)
		"c":
			get_node("Label").text = tag_value
			print("MenyauChara")
			mode = "text"
			tag = "none"
			tag_value = ""
			read_dialog(char_counter)
		"b":
			tag = "none"
			tag_value = ""
			mode = "waiting"
		"a":
			for button in tag_value.split("$"):
				make_buttons(button)
		"q":
			quest = tag_value
			char_counter += 1
			mode = "text"
			tag = "none"
			tag_value = ""
			read_dialog(char_counter)
			print(quest)
func parse_text():
	if my_text[char_counter] == "<":
		mode = "code"
	elif my_text[char_counter] == ">":
		print("Error, missed open bracked <")
		self.append_bbcode("[color=red]Error, missed open bracked <[/color]")
	else:
		self.append_bbcode(my_text[char_counter])
	char_counter += 1
	get_node("textTimer").stop()
	read_dialog(char_counter)
	

func read_dialog(char_counter):
	if char_counter < my_text.length():
		match mode:
			"text":
				get_node("textTimer").start()
			"code": parse_code()
			"making":making()

func remove_buttons():
	self.clear()
	for button in get_node("ButtonContainer").get_children():
		button.queue_free()
		
func start():
	if my_text[char_counter] == "<":
		mode = "code"
		char_counter += 1
		read_dialog(char_counter)
	else:
		mode = "text"
		read_dialog(char_counter)


	
#func _on_Timer_timeout():
#	if char_counter < my_text.length():
#		if buf_pause:
#			get_node("Timer").wait_time = buf_pause
##			get_node("Timer").wait_time = buf_pause
#			buf_pause = null
#		read_dialog(my_text[char_counter])
#		char_counter += 1
#		if char_counter < my_text.length():
#			if my_text[char_counter] == "<":
#				buf_time = get_node("Timer").wait_time
#				get_node("Timer").wait_time = 0.0001
#
#	else:
#		get_node("Timer").stop()
##		self.append_bbcode("[shake]else: [/shake]")

#func read_dialog():
#	for i in my_text:
#		if mode == "text":
#			if i == "<":
#				mode = "script"
#			elif i == ">":
#				print("Error, missed open bracked <")
#				self.append_bbcode("[color=red]Error, missed open bracked <[/color]")
#			else:
#				self.append_bbcode(i)
#		elif mode == "script":
#			if tag == "none":
#				match i:
#					"t": tag = "t"
#					"p": tag = "p"
#					"c": tag = "c"
#					"a": tag = "a"
#					"g": tag = "g"
#					_: 
#						print("Error, can't find this tag:'", i, "'")
#						self.append_bbcode("[color=red]Error, can't find this tag[/color]")
#				tag_value = ""
#			else:
#				match tag:
#					"t":
#						if i == ">":
#							mode = "making"
#						else:
#							tag_value += i
#					"p":
#						if i == ">":
#							mode = "making"
#						else:
#							tag_value += i
#					"c":
#						if i == ">":
#							mode = "making"
#						else:
#							tag_value += i
#					"a":
#						if i == ">":
#							mode = "making"
#						else:
#							tag_value += i
#					"g":
#						if i == ">":
#							mode = "making"
#						else:
#							tag_value += i
#		if mode == "making":
#			get_node("Timer").wait_time = buf_time
#			match tag:
#				"t":
#					if tag_value == "":
#						get_node("Timer").wait_time = default_time
#					else:
#						 get_node("Timer").wait_time = float(tag_value)
#				"p":
#					buf_pause = get_node("Timer").wait_time
#					if tag_value == "":					 
#						get_node("Timer").wait_time = 1
#					else:
#	#					get_node("Timer").wait_time = float(tag_value)
#						get_node("Timer").start(float(tag_value))
#			tag = "none"
#			mode = "text"


