extends Node2D

# Load Next Scene
var character_select_scene = preload("res://scenes/character_selection.tscn")
var credits_scene = preload("res://scenes/credits.tscn")

var confirm_sound = preload("res://sound/snd_confirm.wav")

var destination = character_select_scene
# References to children
onready var raider_logo = $RaiderLogoPart
onready var rumble_logo = $RumbleLogoPart
onready var msoe_logo = $MSOELogoPart
onready var animator = $AnimationPlayer
onready var start = $PressStart
onready var jump = $PressJump
onready var block = $PressBlock
onready var cloud = $Cloud
onready var transition_color = $TransitionColor

var blink_duration: float = 30
var blink_counter: float = 0
export var blink: bool = false

var cloud_speed: float = 1
var transitioning: bool = false


func _ready():
	MusicController.play_menu_music()

func _physics_process(_delta):
	
	if blink:
		blink_counter += 1
		if(blink_counter == blink_duration):
			start.visible = !start.visible
			block.visible = !block.visible
			jump.visible = !jump.visible
			blink_counter = 0
		
		cloud.position.x += cloud_speed
		if cloud.position.x > 1350:
			cloud.position.x = -150
		
	# Volume
	if Input.is_action_just_pressed("p1_up") or Input.is_action_just_pressed("p2_up"):
		MusicController.change_volume(.05)
	elif Input.is_action_just_pressed("p1_crouch") or Input.is_action_just_pressed("p2_crouch"):
		MusicController.change_volume(-.05)
	
	if !transitioning and blink and (Input.is_action_just_pressed("p1_attack") or Input.is_action_just_pressed("p2_attack")):
		transitioning = true
		MusicController.play_sound_effect("confirm")
	
	if !transitioning and blink and (Input.is_action_just_pressed("p1_block") or Input.is_action_just_pressed("p2_block")):
		destination = credits_scene
		transitioning = true
		MusicController.play_sound_effect("confirm")
		
	if transitioning:
		transition_color.modulate.a += .01
		if transition_color.modulate.a > 1:
			get_tree().change_scene_to(destination)
	
func show_controls():
	Controls.get_child(0).toggle()
