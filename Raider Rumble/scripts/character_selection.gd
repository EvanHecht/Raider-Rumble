extends Node2D

# Resources
var destination_stage = preload("res://scenes/stage_selection.tscn")
var me_sprite_frames = preload("res://sprites/characters/mechanical engineer/sf_mechanical_engineer.tres")
var se_sprite_frames = preload("res://sprites/characters/software engineer/sf_software_engineer.tres")
var ee_sprite_frames = preload("res://sprites/characters/electrical engineer/sf_electrical_engineer.tres")
var ae_sprite_frames = preload("res://sprites/characters/architectural engineer/sf_architectural_engineer.tres")
var nu_sprite_frames = preload("res://sprites/characters/nursing/sf_nursing.tres")
var bu_sprite_frames = preload("res://sprites/characters/business/sf_business.tres")

var unknown_sprite_frames = preload("res://sprites/CharacterSelection/sf_unknown_character.tres")

onready var transition_color: ColorRect = $TransitionColor
onready var title_text: Label = $TitleText
onready var equation_background: TextureRect = $Equations
var background_speed = 2

# Character Icons
onready var me_icon: Sprite = $MEIcon
onready var se_icon: Sprite = $SEIcon
onready var ee_icon: Sprite = $EEIcon
onready var nu_icon: Sprite = $NUIcon
onready var bu_icon: Sprite = $BUIcon
onready var ae_icon: Sprite = $AEIcon

onready var p1_selector: Sprite = $P1Selector
onready var p2_selector: Sprite = $P2Selector
onready var p1_character_name: Label = $P1Pedestal/P1CharacterName
onready var p2_character_name: Label = $P2Pedestal/P2CharacterName
onready var p1_character_display: AnimatedSprite = $P1Pedestal/P1CharacterDisplay
onready var p2_character_display: AnimatedSprite = $P2Pedestal/P2CharacterDisplay
onready var p1_ready_label: Label = $P1Pedestal/P1ReadyLabel
onready var p2_ready_label: Label = $P2Pedestal/P2ReadyLabel
onready var p1_ready_icon: AnimatedSprite = $P1Pedestal/P1ReadyIcon
onready var p2_ready_icon: AnimatedSprite = $P2Pedestal/P2ReadyIcon

onready var back_bar: ProgressBar = $BackBar
var back_progess = 0

var p1_cursor_position: Vector2 = Vector2(0, 0)
var p2_cursor_position: Vector2 = Vector2(1, 0)
const GRID_WIDTH: int = 2
const GRID_HEIGHT: int = 3

onready var character_icons = {Vector2(0,0): [me_icon, "Mechanical Engineer", me_sprite_frames, PlayerVariables.Characters.MECHANICAL_ENGINEER], 
								Vector2(1,0): [se_icon, "Software Engineer", se_sprite_frames, PlayerVariables.Characters.SOFTWARE_ENGINEER],
								Vector2(0,1): [ee_icon, "Electrical Engineer", ee_sprite_frames, PlayerVariables.Characters.ELECTRICAL_ENGINEER], 
								Vector2(1,1): [nu_icon, "Nursing", nu_sprite_frames, PlayerVariables.Characters.NURSING],
								Vector2(0,2): [bu_icon, "Business", bu_sprite_frames, PlayerVariables.Characters.BUSINESS], 
								Vector2(1,2): [ae_icon, "Architectural Engineer", ae_sprite_frames, PlayerVariables.Characters.ARCHITECTURAL_ENGINEER]}

enum player_phase {
	SELECTING
	CONFIRMING
	READY
	TRANSITIONING_OUT
}

var p1_phase = player_phase.SELECTING
var p2_phase = player_phase.SELECTING

var transitioning_in = true
var transitioning_out = false

func _ready():
	MusicController.play_menu_music()

func _physics_process(delta):
	
	background_effect()
	
	# These need to be called in this order due to input handling
	ready_phase()
	confirming_phase()
	selection_phase()

	if transitioning_in:
		transition_in()
	elif transitioning_out:
		transition_out()


func selection_phase():
	
	# Player 1
	if p1_phase == player_phase.SELECTING:
		p1_selector.visible = true
		if Input.is_action_just_pressed("p1_move_right"):
			p1_cursor_position.x += 1
			MusicController.play_sound_effect("selector_move")
		elif Input.is_action_just_pressed("p1_move_left"):
			p1_cursor_position.x -= 1
			MusicController.play_sound_effect("selector_move")
		elif Input.is_action_just_pressed("p1_up"):
			p1_cursor_position.y -= 1
			MusicController.play_sound_effect("selector_move")
		elif Input.is_action_just_pressed("p1_crouch"):
			p1_cursor_position.y += 1
			MusicController.play_sound_effect("selector_move")
		p1_cursor_position.x = clamp(p1_cursor_position.x, 0, GRID_WIDTH - 1)
		p1_cursor_position.y = clamp(p1_cursor_position.y, 0, GRID_HEIGHT - 1)
		p1_selector.position = character_icons.get(p1_cursor_position)[0].position
		p1_character_name.text = character_icons.get(p1_cursor_position)[1]
		if p1_character_display.frames != character_icons.get(p1_cursor_position)[2]:
			p1_character_display.frames = character_icons.get(p1_cursor_position)[2]
		p1_character_display.playing = true
		
		if Input.is_action_just_pressed("p1_attack"):
			MatchVariables.p1_character = character_icons.get(p1_cursor_position)[3]
			p1_phase = player_phase.CONFIRMING
			p1_selector.visible = false
	
	# Player 2
	if p2_phase == player_phase.SELECTING:
		p2_selector.visible = true
		if Input.is_action_just_pressed("p2_move_right"):
			p2_cursor_position.x += 1
			MusicController.play_sound_effect("selector_move")
		elif Input.is_action_just_pressed("p2_move_left"):
			p2_cursor_position.x -= 1
			MusicController.play_sound_effect("selector_move")
		elif Input.is_action_just_pressed("p2_up"):
			p2_cursor_position.y -= 1
			MusicController.play_sound_effect("selector_move")
		elif Input.is_action_just_pressed("p2_crouch"):
			p2_cursor_position.y += 1
			MusicController.play_sound_effect("selector_move")
		p2_cursor_position.x = clamp(p2_cursor_position.x, 0, GRID_WIDTH - 1)
		p2_cursor_position.y = clamp(p2_cursor_position.y, 0, GRID_HEIGHT - 1)
		p2_selector.position = character_icons.get(p2_cursor_position)[0].position
		p2_character_name.text = character_icons.get(p2_cursor_position)[1]
		if p2_character_display.frames != character_icons.get(p2_cursor_position)[2]:
			p2_character_display.frames = character_icons.get(p2_cursor_position)[2]
		p2_character_display.playing = true
		
		if Input.is_action_just_pressed("p2_attack"):
			MatchVariables.p2_character = character_icons.get(p2_cursor_position)[3]
			p2_phase = player_phase.CONFIRMING
			p2_selector.visible = false
		
	# Back to title
	if Input.is_action_pressed("p1_special") or Input.is_action_pressed("p2_special"):
		back_progess = clamp(back_progess + 1, 0, 100)
	elif !transitioning_out:
		back_progess = clamp(back_progess - 1, 0, 100)
	if back_progess >= 100:
		destination_stage = load("res://scenes/title_screen.tscn")
		transitioning_out = true
	else:
		back_bar.value = back_progess
		

func confirming_phase():
	
	if p1_phase == player_phase.CONFIRMING:
		p1_ready_label.visible = true
		if Input.is_action_just_pressed("p1_attack"):
			p1_phase = player_phase.READY
			p1_ready_label.visible = false
			p1_ready_icon.visible = true
			MusicController.play_sound_effect("confirm")
		elif Input.is_action_just_pressed("p1_special"):
			p1_phase = player_phase.SELECTING
			p1_ready_label.visible = false
			p1_ready_icon.visible = false
			
	if p2_phase == player_phase.CONFIRMING:
		p2_ready_label.visible = true
		if Input.is_action_just_pressed("p2_attack"):
			p2_phase = player_phase.READY
			p2_ready_label.visible = false
			p2_ready_icon.visible = true
			MusicController.play_sound_effect("confirm")
		elif Input.is_action_just_pressed("p2_special"):
			p2_phase = player_phase.SELECTING
			p2_ready_label.visible = false
			p2_ready_icon.visible = false


func ready_phase():
	
	if p1_phase == player_phase.READY and !transitioning_out:
		if Input.is_action_just_pressed("p1_special"):
			p1_phase = player_phase.CONFIRMING
			p1_ready_icon.visible = false
			p1_ready_label.visible = true
			
	if p2_phase == player_phase.READY:
		if Input.is_action_just_pressed("p2_special") and !transitioning_out:
			p2_phase = player_phase.CONFIRMING
			p2_ready_icon.visible = false
			p2_ready_label.visible = true

	if p1_phase == player_phase.READY and p2_phase == player_phase.READY:
		transitioning_out = true

func background_effect():
	equation_background.rect_position.x += background_speed
	while(equation_background.rect_position.x > 0):
		equation_background.rect_position.x -= 1280


func transition_in():
	transition_color.modulate.a -= .01
	if title_text.visible_characters < title_text.text.length():
		title_text.visible_characters += 1
	if transition_color.modulate.a <= 0 and title_text.visible_characters >= title_text.text.length():
		transitioning_in = false
		transition_color.modulate.a = 0
		title_text.visible_characters = -1

func transition_out():
	transition_color.modulate.a += .01
	if transition_color.modulate.a >= 1:
		get_tree().change_scene_to(destination_stage)
