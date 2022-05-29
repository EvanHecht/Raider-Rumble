extends Node

var showing_hitboxes = false

func _physics_process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
