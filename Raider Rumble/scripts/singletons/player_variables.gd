extends Node

# THIS SCRIPT IS A SINGLETON THAT CAN BE REFERENCED FROM ANY NODE
# This node is used to initialize the player variabes so that the player
# script can solely focus on the main functionality of the player.

###########################################
#               ENUMERATIONS              #
###########################################

enum PlayerNumber { 
	PLAYER_1
	PLAYER_2
}

enum PlayerInputs {
	MOVE_LEFT
	MOVE_RIGHT
	UP
	JUMP
	CROUCH
	ATTACK
	SPECIAL
	BLOCK
}

enum PlayerStates {
	IDLE
	RUNNING
	CROUCHING
	BLOCKING
	STUNNED
	AIRBORNE
	NEUTRAL_ATTACK
	NEUTRAL_ATTACK_AIR
	FORWARD_ATTACK
	FORWARD_ATTACK_AIR
	UP_ATTACK
	UP_ATTACK_AIR
	DOWN_ATTACK
	DOWN_ATTACK_AIR
	NEUTRAL_SPECIAL
	FORWARD_SPECIAL
	UP_SPECIAL
	DOWN_SPECIAL
}

enum PlayerAttributes {
	GROUND_SPEED
	AIR_SPEED
	MAX_JUMPS
	JUMP_POWER
	JUMP_DURATION
	WEIGHT
	FALL_SPEED
}

enum Characters {
	TEMPLATE
	MECHANICAL_ENGINEER
	SOFTWARE_ENGINEER
	ELECTRICAL_ENGINEER
	ARCHITECTURAL_ENGINEER
	NURSING
	BUSINESS
}


###########################################
#                VARIABLES                #
###########################################

var player_1_input_map: Dictionary = {}
var player_2_input_map: Dictionary = {}

var character_classes: Dictionary = {}

var se_down_attack = 50

###########################################
#                FUNCTIONS                #
###########################################

func _ready() -> void:
	_initialize_input_maps()
	_initialize_character_classes()

func _initialize_character_classes() -> void:
	character_classes[Characters.TEMPLATE] = CharacterClassTemplate.new()
	character_classes[Characters.MECHANICAL_ENGINEER] = MECharacterClass.new()
	character_classes[Characters.SOFTWARE_ENGINEER] = SECharacterClass.new()
	character_classes[Characters.ELECTRICAL_ENGINEER] = EECharacterClass.new()
	character_classes[Characters.ARCHITECTURAL_ENGINEER] = AECharacterClass.new()
	character_classes[Characters.NURSING] = NUCharacterClass.new()
	character_classes[Characters.BUSINESS] = BUCharacterClass.new()


func _initialize_input_maps() -> void:
	
	# Player 1
	player_1_input_map[PlayerInputs.MOVE_LEFT] = "p1_move_left"
	player_1_input_map[PlayerInputs.MOVE_RIGHT] = "p1_move_right"
	player_1_input_map[PlayerInputs.UP] = "p1_up"
	player_1_input_map[PlayerInputs.JUMP] = "p1_jump"
	player_1_input_map[PlayerInputs.CROUCH] = "p1_crouch"
	player_1_input_map[PlayerInputs.ATTACK] = "p1_attack"
	player_1_input_map[PlayerInputs.SPECIAL] = "p1_special"
	player_1_input_map[PlayerInputs.BLOCK] = "p1_block"
	
	# Player 2
	player_2_input_map[PlayerInputs.MOVE_LEFT] = "p2_move_left"
	player_2_input_map[PlayerInputs.MOVE_RIGHT] = "p2_move_right"
	player_2_input_map[PlayerInputs.UP] = "p2_up"
	player_2_input_map[PlayerInputs.JUMP] = "p2_jump"
	player_2_input_map[PlayerInputs.CROUCH] = "p2_crouch"
	player_2_input_map[PlayerInputs.ATTACK] = "p2_attack"
	player_2_input_map[PlayerInputs.SPECIAL] = "p2_special"
	player_2_input_map[PlayerInputs.BLOCK] = "p2_block"

#MECHANICAL ENGINEER
#
#NEUTRAL_ATTACK = 5
#NEUTRAL_SPECIAL = 10
#FORWARD_ATTACK = 5
#FORWARD_SPECIAL = 10
#UP_ATTACK = 15
#UP_SPECIAL = 15
#DOWN_ATTACK = 10
#DOWN_SPECIAL = 10

#SOFTWARE ENGINEER
#
#NEUTRAL_ATTACK = 5
#NEUTRAL_SPECIAL = 15
#FORWARD_ATTACK = 5
#FORWARD_SPECIAL = 15
#UP_ATTACK = 10
#UP_SPECIAL = 15
#DOWN_ATTACK = 10
#DOWN_SPECIAL = N/A
