extends Node2D

onready var transition_color = $TransitionColor
onready var back_bar = $Sprite/BackBar
var back_progress = 0
var transitioning_in = true
var transitioning_out = false
var destination_stage

func _physics_process(delta):
	
	# Back to title
	if Input.is_action_pressed("p1_special") or Input.is_action_pressed("p2_special"):
		back_progress = clamp(back_progress + 1, 0, 100)
	elif !transitioning_out:
		back_progress = clamp(back_progress - 1, 0, 100)
	if back_progress >= 100:
		destination_stage = load("res://scenes/title_screen.tscn")
		transitioning_out = true
	else:
		back_bar.value = back_progress
		
	if transitioning_in:
		transition_in()
	elif transitioning_out:
		transition_out()

func transition_in():
	transition_color.modulate.a -= .01
	if transition_color.modulate.a <= 0:
		transitioning_in = false
		transition_color.modulate.a = 0

func transition_out():
	transition_color.modulate.a += .01
	if transition_color.modulate.a >= 1:
		get_tree().change_scene_to(destination_stage)
