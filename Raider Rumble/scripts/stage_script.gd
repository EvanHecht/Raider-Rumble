extends Node2D

onready var stage_camera: Camera2D = $StageCamera
onready var console: Node2D = $Console
onready var stats: Node2D = $Stats
onready var pause_screen: Node2D = $Pause
onready var match_ui: Control = $MatchUI

var min_camera_zoom = .6
var max_camera_zoom = 1
var max_camera_width = 600
var zoom_speed = .01

var blastzone_right = 1400
var blastzone_left = -120
var blastzone_up = -120
var blastzone_down = 840

func _ready():
	MatchVariables.start_match()
	MatchVariables.blastzone_right = blastzone_right
	MatchVariables.blastzone_left = blastzone_left
	MatchVariables.blastzone_up = blastzone_up
	MatchVariables.blastzone_down = blastzone_down
	MatchVariables.stage = self
	MusicController.play_battle_music()


func _physics_process(delta):
	update_camera()


func update_camera():
	
	# Position
	var greater_x = max(MatchVariables.p1_reference.position.x, MatchVariables.p2_reference.position.x)
	var lesser_x = min(MatchVariables.p1_reference.position.x, MatchVariables.p2_reference.position.x)
	var difference_x = greater_x - lesser_x
	var greater_y = max(MatchVariables.p1_reference.position.y, MatchVariables.p2_reference.position.y)
	var lesser_y = min(MatchVariables.p1_reference.position.y, MatchVariables.p2_reference.position.y)
	var difference_y = greater_y - lesser_y
	stage_camera.position.x = greater_x - (difference_x/2)
	stage_camera.position.y = greater_y - (difference_y/2)
	
	# Zoom
	var zoom: float = max(difference_x, difference_y)/max_camera_width
	zoom = clamp(zoom, min_camera_zoom, max_camera_zoom)
	var current_zoom: float = stage_camera.zoom.x
	if current_zoom + zoom_speed < zoom:
		current_zoom = min(current_zoom + zoom_speed, max_camera_zoom)
	elif current_zoom - zoom_speed > zoom:
		current_zoom = max(current_zoom - zoom_speed, min_camera_zoom)
	else:
		current_zoom = zoom
	stage_camera.zoom = Vector2(current_zoom, current_zoom)
	

	
