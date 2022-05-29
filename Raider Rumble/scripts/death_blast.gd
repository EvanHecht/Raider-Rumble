extends Node2D

func _ready():
	look_at(Vector2(702, 396))
	MusicController.play_sound_effect("death")
