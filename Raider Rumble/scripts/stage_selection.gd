extends Node2D

# Resources
var grohmann_scene = preload("res://scenes/stage_grohmann_museum.tscn")
var kern_scene = preload("res://scenes/stage_kern_center.tscn")
var viets_scene = preload("res://scenes/stage_viets_field.tscn")
var diercks_scene = preload("res://scenes/stage_diercks_hall.tscn")
var cc_scene = preload("res://scenes/stage_campus_center.tscn")

var grohmann_bg = preload("res://sprites/stages/grohmann_stage_background.png")
var kern_bg = preload("res://sprites/stages/kern_stage_background.png")
var viets_bg = preload("res://sprites/stages/field_stage_background.png")
var diercks_bg = preload("res://sprites/stages/diercks_stage_background.png")
var cc_bg = preload("res://sprites/stages/cc_stage_background.png")

onready var transition_color: ColorRect = $TransitionColor
onready var title_text: Label = $TitleText
onready var equation_background: TextureRect = $Equations
onready var fight_banner: Sprite = $FightBanner
onready var banner_shimmer: Sprite = $FightBanner/Shimmer
onready var stage_name_label: Label = $StageNameLabel
var background_speed = 2
var banner_scale_speed = .25
var shimmer_speed = 25

# Stage Icons
onready var grohmann_icon: Sprite = $GrohmannIcon
onready var kern_icon: Sprite = $KernIcon
onready var viets_icon: Sprite = $FieldIcon
onready var diercks_icon: Sprite = $AuditoriumIcon
onready var cc_icon: Sprite = $CCIcon

# Misc Nodes
onready var selector: AnimatedSprite = $Selector
onready var background: Sprite = $Background

var selector_position = 1
var number_of_stages = 5
var selected = false
var destination_scene = kern_scene

enum stages {
	GROHMANN_MUSEUM = 0
	KERN_CENTER = 1
	VIETS_FIELD = 2
	DIERCKS_HALL = 3
	CAMPUS_CENTER = 4
}

onready var stage_info = {
	stages.GROHMANN_MUSEUM: ["Grohmann Museum", grohmann_icon, grohmann_bg, grohmann_scene],
	stages.KERN_CENTER: ["Kern Center", kern_icon, kern_bg, kern_scene],
	stages.VIETS_FIELD: ["Viets Field", viets_icon, viets_bg, viets_scene],
	stages.DIERCKS_HALL: ["Diercks Hall", diercks_icon, diercks_bg, diercks_scene],
	stages.CAMPUS_CENTER: ["Campus Center", cc_icon, cc_bg, cc_scene]
}

var transitioning_in = true
var transitioning_out = false

func _ready():
	MusicController.play_menu_music()

func _physics_process(delta):
	
	fight_banner_effect()
	
	if !selected:
		selection_phase()
	else:
		confirming_phase()

	if transitioning_in:
		transition_in()
	elif transitioning_out:
		transition_out()


func selection_phase():
	
	var move_dir = int(Input.is_action_just_pressed("p1_move_right") || Input.is_action_just_pressed("p2_move_right")) - int(Input.is_action_just_pressed("p1_move_left") || Input.is_action_just_pressed("p2_move_left"))
	
	if move_dir != 0 and !transitioning_out:
		MusicController.play_sound_effect("selector_move")
		selector_position = wrapi(selector_position + move_dir, 0, number_of_stages)
		var current_stage = stage_info[selector_position]
		stage_name_label.text = current_stage[0]
		selector.position = current_stage[1].position
		background.texture = current_stage[2]
		destination_scene = current_stage[3]
		
	if (Input.is_action_just_pressed("p1_attack") or Input.is_action_just_pressed("p2_attack")) and !transitioning_out:
		selected = true
		
	elif Input.is_action_just_pressed("p1_special") or Input.is_action_just_pressed("p2_special"):
		destination_scene = load("res://scenes/character_selection.tscn")
		transitioning_out = true


func confirming_phase():
	if !transitioning_out and (Input.is_action_just_pressed("p1_special") or Input.is_action_just_pressed("p2_special")):
		selected = false
	elif Input.is_action_just_pressed("p1_attack") or Input.is_action_just_pressed("p2_attack"):
		transitioning_out = true
		MusicController.play_sound_effect("confirm")


func background_effect():
	equation_background.rect_position.x += background_speed
	while(equation_background.rect_position.x > 0):
		equation_background.rect_position.x -= 1280


func fight_banner_effect():
	if selected:
		fight_banner.scale.y += banner_scale_speed
		banner_shimmer.position.x += shimmer_speed
		if banner_shimmer.position.x > 800:
			banner_shimmer.position.x = -5000
	else:
		fight_banner.scale.y -= banner_scale_speed
		banner_shimmer.position.x = -1000
	fight_banner.position.x = clamp(fight_banner.position.x, -640, 640)
	fight_banner.scale.y = clamp(fight_banner.scale.y, 0, 1)


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
		get_tree().change_scene_to(destination_scene)
