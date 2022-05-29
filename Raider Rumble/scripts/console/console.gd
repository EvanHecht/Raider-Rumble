extends Node2D

# Variables
onready var consoleInput: LineEdit = $Input
onready var consoleLabel: Label = $Label
# onready var StageNode = get_node("/root/TestStage")
# onready var Player1Node = get_node("/root/TestStage/Player")
# onready var Player2Node = get_node("/root/TestStage/Player2")
# onready var Player1Hitbox = get_node("/root/TestStage/Player/Hitboxes")
# onready var Player2Hitbox = get_node("/root/TestStage/Player2/Hitboxes")
# onready var StatsNode = get_node("/root/TestStage/Stats")
# onready var PauseNode = get_node("/root/TestStage/Pause")
# onready var StatsLabel = get_node("/root/TestStage/Stats/Label")

onready var StageNode = get_node("/root/GrohmannMuseum")
onready var Player1Node = get_node("/root/GrohmannMuseum/Player")
onready var Player2Node = get_node("/root/GrohmannMuseum/Player2")
onready var Player1Hitbox = get_node("/root/GrohmannMuseum/Player/Hitboxes")
onready var Player2Hitbox = get_node("/root/GrohmannMuseum/Player2/Hitboxes")
onready var ConsoleNode = get_node("/root/GrohmannMuseum/Console")
onready var StatsNode = get_node("/root/GrohmannMuseum/Stats")
onready var StatsLabel = get_node("/root/GrohmannMuseum/Stats/Label")
onready var PauseNode = get_node("/root/GrohmannMuseum/PauseScreen")


var command_history = []
var command_history_index = 0
var command_list = ["echo", "toggle", "mani", "restart", "swap"]


func _ready():
	self.visible = false
	StatsNode.visible = false
	PauseNode.visible = false


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("console_toggle")):
		self.toggle_visibility()
		
	if(Input.is_action_just_pressed("stats_toggle")):
		self.stats_toggle()
	
	if(Input.is_action_just_pressed("pause_toggle")):
		self.pause_toggle()
	
	if(self.visible):
		if(Input.is_action_just_pressed("console_history_up")):
			show_prev_commands("up")
			
		if(Input.is_action_just_pressed("console_history_down")):
			show_prev_commands("down")
			
	var stats_text = \
		"PLAYER 1" + \
		"\nmovement xy: " + str(Player1Node.movement_vector.x) + " " + str(Player2Node.movement_vector.y) + \
		"\nknockback xy: " + str(Player1Node.knockback_vector.x) + " " + str(Player1Node.knockback_vector.y) + \
		"\naction: " + str(Player1Node.action) + \
		"\ndirection facing: " + str(Player1Node.direction_facing) + \
		"\nremaining jumps: " + str(Player1Node.remaining_jumps) + \
		"\njump duration: " + str(Player1Node.jump_duration) + \
		"\nhitstun: " + str(Player1Node.hitstun) + \
		"\ndamage: " + str(Player1Node.damage) + \
		"\n" + \
		"\nPLAYER 2" + \
		"\nmovement xy: " + str(Player2Node.movement_vector.x) + " " + str(Player2Node.movement_vector.y) + \
		"\nknockback xy: " + str(Player2Node.knockback_vector.x) + " " + str(Player2Node.knockback_vector.y) + \
		"\naction: " + str(Player2Node.action) + \
		"\ndirection facing: " + str(Player2Node.direction_facing) + \
		"\nremaining jumps: " + str(Player2Node.remaining_jumps) + \
		"\njump duration: " + str(Player2Node.jump_duration) + \
		"\ndamage: " + str(Player2Node.damage) + \
		"\n"
	
	StatsLabel.text = stats_text


func toggle_visibility():
	if(!self.visible):
		self.visible = true
		consoleInput.grab_focus()
		Player1Node.recieves_input = false
		Player2Node.recieves_input = false
	else:
		self.visible = false
		consoleInput.clear()
		Player1Node.recieves_input = true
		Player2Node.recieves_input = true


func show_prev_commands(direction):
	if(command_history.size() > 0):
		if(direction == "up"):
			if(self.command_history_index - 1 >= 0):
				self.command_history_index -= 1
				consoleInput.text = self.command_history[self.command_history_index]
				
		if(direction == "down"):
			if(self.command_history_index + 1 < self.command_history.size()):
				self.command_history_index += 1
				consoleInput.text = self.command_history[self.command_history_index]


func _on_Input_text_entered(new_text):
	self.command_history.append(new_text)
	self.command_history_index = self.command_history.size()
	var output = parse_command(new_text)
	consoleInput.clear()


func parse_command(text):
	var text_array = text.split(" ")
	var command = text_array[0]
	var output_text = ""
	if(command_list.has(command)):
		if(command == "echo"):
			output_text = echo_commmand(text_array)
		if(command == "restart"):
			output_text = restart_command(text_array)
		if(command == "swap"):
			output_text = swap_command(text_array)
		if(command == "toggle"):
			output_text = toggle_command(text_array)
		if(command == "mani"):
			output_text = mani_command(text_array)
		output(output_text)
	else:
		output("command " + "\"" + command + "\"" + " does not exist!")


func output(text):
	consoleLabel.text = consoleLabel.text + str(text) + "\n"
	

func echo_commmand(array):
	if(array.size() > 1):
		return "echo: " + array[1]


func restart_command(array):
	if(array.size() <= 1):
		return "restart command error: scene is missing."
	
	var scene = array[1]
	if(scene == "character_selection"):
		get_tree().change_scene_to(load("res://scenes/character_selection.tscn"))
	elif(scene == "stage_grohmann_museum"):
		get_tree().change_scene_to(load("res://scenes/stage_grohmann_museum.tscn"))
	elif(scene == "title_screen"):
		get_tree().change_scene_to(load("res://scenes/title_screen.tscn"))
	else:
		return "restart command error: scene is invalid."
	return "restart: changed scene to " + scene

func swap_command(array):
	if(array.size() <= 1):
		return "swap command error: node is missing."
	
	var node = array[1]
	
	if(node == "stage"):
		if(array.size() <= 2):
			return "swap command error: stage name is missing."
		return "swap: swapped stage to ..."
	if(node == "player"):
		if(array.size() <= 2):
			return "swap command error: player number is missing."
		var player_num = array[2]
		if(array.size() <= 3):
				return "swap command error: character is missing."
		var character = array[3]
		if(player_num == "1"):
			if(character == "SE"):
				MatchVariables.p1_character = PlayerVariables.Characters.SOFTWARE_ENGINEER
				Player1Node._ready()
			if(character == "ME"):
				MatchVariables.p1_character = PlayerVariables.Characters.MECHANICAL_ENGINEER
				Player1Node._ready()
		if(player_num == "2"):
			if(character == "SE"):
				MatchVariables.p2_character = PlayerVariables.Characters.SOFTWARE_ENGINEER
				Player2Node._ready()
			if(character == "ME"):
				MatchVariables.p2_character = PlayerVariables.Characters.MECHANICAL_ENGINEER
				Player2Node._ready()
		return "swap: swapped player " + player_num + " to " + character


func toggle_command(array):
	if(array.size() <= 1):
		return "toggle command error: node is missing."
	
	var node = array[1]
	if(node == "stats"):
		return stats_toggle()
	elif(node == "pause_screen"):
		return pause_toggle()
	elif(node == "hitboxes"):
		return hitbox_toggle()
	else:
		return "toggle command error: node is invalid."


func stats_toggle():
	if(!StatsNode.visible):
		StatsNode.visible = true
		return "toggle: stats visible"
	else:
		StatsNode.visible = false
		return "toggle: stats not visible"


func pause_toggle():
	if(!PauseNode.visible):
		get_tree().paused = true
		PauseNode.visible = true
		return "toggle: pause screen visible"
	else:
		get_tree().paused = false
		PauseNode.visible = false
		return "toggle: pause screen not visible"


func hitbox_toggle():
	print(GlobalVariables.showing_hitboxes)
	if(!GlobalVariables.showing_hitboxes):
		GlobalVariables.showing_hitboxes = true
		return "toggle: hitboxes visible"
	else:
		GlobalVariables.showing_hitboxes = false
		return "toggle: hitboxes not visible"


func mani_command(array):
	if(array.size() <= 1):
		return "mani command error: node is missing."
	
	var node = array[1]
	if(node == "player"):
		if(array.size() <= 2):
			return "mani command error: player num is missing"
		
		var player_num = array[2]
		if(player_num == "1"):
			return mani_player(Player1Node, array)
		elif(player_num == "2"):
			return mani_player(Player2Node, array)
		elif(player_num == "12"):
			var return_str1 = mani_player(Player1Node, array)
			var return_str2 = mani_player(Player2Node, array)
			return (return_str1 + "\n" + return_str2 + "\n")
		else:
			return "mani command error: player num is invalid"
	else:
		return "mani command error: node is invalid"


func mani_player(player, array):
	if(array.size() <= 3):
		return "mani command error: type is missing."
		
	var type = array[3]
	if(type == "attribute"):
		return mani_player_attribute(player, array)
	else:
		return "mani command error: type is invalid."


func mani_player_attribute(player, array):
	if(array.size() <= 4):
		return "mani command error: action is missing."
	
	var action = array[4]
	if(action == "set"):
		return mani_player_attribute_set(player, array)
	elif(action == "get"):
		return mani_player_attribute_get(player, array)
	else:
		return "mani command error: action is invalid."


func mani_player_attribute_set(player, array):
	if(array.size() <= 5):
		return "mani command error: attribute name is missing."
	if(array.size() <= 6):
		return "mani command error: set value is missing."
		
	var player_num = array[2]
	var attr_name = array[5]
	var output_text = ""
	var prev_value = ""
	var set_value = int(array[6])
	if(attr_name == "ground_speed"):
		prev_value = player.attribute_map[PlayerVariables.PlayerAttributes.GROUND_SPEED]
		player.attribute_map[PlayerVariables.PlayerAttributes.GROUND_SPEED] = set_value
	elif(attr_name == "air_speed"):
		prev_value = player.attribute_map[PlayerVariables.PlayerAttributes.AIR_SPEED]
		player.attribute_map[PlayerVariables.PlayerAttributes.AIR_SPEED] = set_value
	elif(attr_name == "max_jumps"):
		prev_value = player.attribute_map[PlayerVariables.PlayerAttributes.MAX_JUMPS]
		player.attribute_map[PlayerVariables.PlayerAttributes.MAX_JUMPS] = set_value
	elif(attr_name == "jump_power"):
		prev_value = player.attribute_map[PlayerVariables.PlayerAttributes.JUMP_POWER]
		player.attribute_map[PlayerVariables.PlayerAttributes.JUMP_POWER] = set_value
	elif(attr_name == "jump_duration"):
		prev_value = player.attribute_map[PlayerVariables.PlayerAttributes.JUMP_DURATION]
		player.attribute_map[PlayerVariables.PlayerAttributes.JUMP_DURATION] = set_value
	elif(attr_name == "weight"):
		prev_value = player.attribute_map[PlayerVariables.PlayerAttributes.WEIGHT]
		player.attribute_map[PlayerVariables.PlayerAttributes.WEIGHT] = set_value
	elif(attr_name == "fall_speed"):
		prev_value = player.attribute_map[PlayerVariables.PlayerAttributes.FALL_SPEED]
		player.attribute_map[PlayerVariables.PlayerAttributes.FALL_SPEED] = set_value
	elif(attr_name == "damage"):
		prev_value = player.damage
		player.damage = set_value
	else:
		return "mani command error: attribute name is invalid."
		
	return "mani: player " + player_num + " attribute " + attr_name + " now is " + str(set_value) + " (was " + str(prev_value) +  ")"


func mani_player_attribute_get(player, array):
	if(array.size() <= 5): 
		return "mani command error: attribute name is missing."
		
	var player_num = array[2]
	var action = array[4]
	var attr_name = array[5]
	var attr_value = 0
	var output_text = ""
	
	if(attr_name == "ground_speed"):
		attr_value = player.attribute_map[PlayerVariables.PlayerAttributes.GROUND_SPEED]
	elif(attr_name == "air_speed"):
		attr_value = player.attribute_map[PlayerVariables.PlayerAttributes.AIR_SPEED]
	elif(attr_name == "max_jumps"):
		attr_value = player.attribute_map[PlayerVariables.PlayerAttributes.MAX_JUMPS]
	elif(attr_name == "jump_power"):
		attr_value = player.attribute_map[PlayerVariables.PlayerAttributes.JUMP_POWER]
	elif(attr_name == "jump_duration"):
		attr_value = player.attribute_map[PlayerVariables.PlayerAttributes.JUMP_DURATION]
	elif(attr_name == "weight"):
		attr_value = player.attribute_map[PlayerVariables.PlayerAttributes.WEIGHT]
	elif(attr_name == "fall_speed"):
		attr_value = player.attribute_map[PlayerVariables.PlayerAttributes.FALL_SPEED]
	elif(attr_name == "damage"):
		attr_value = player.damage
	else:
		return "mani command error: attribute name is invalid."
		
	return "mani: player " + player_num + " attribute " + attr_name + " is " + str(attr_value)
