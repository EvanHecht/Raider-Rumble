extends Node

enum match_phase {
	NO_FIGHT
	COUNTDOWN
	FIGHT
	END
}

var p1_reference: Player = null
var p2_reference: Player = null
var p1_character = PlayerVariables.Characters.ARCHITECTURAL_ENGINEER
var p2_character = PlayerVariables.Characters.MECHANICAL_ENGINEER
var p1_stock = 3
var p2_stock = 3

var stage

var current_phase = match_phase.NO_FIGHT
var countdown_timer = 181
var match_length = 28800 # Match duration in frames
var match_timer = 0
var match_timer_string = "8:00.00"
var countdown_timer_string = ""

var blastzone_right = null
var blastzone_left = null
var blastzone_up = null
var blastzone_down = null

func start_match():
	match_timer = 0
	countdown_timer = 181
	p1_stock = 3
	p2_stock = 3
	current_phase = match_phase.COUNTDOWN
	p1_reference.recieves_input = false
	p2_reference.recieves_input = false


func _physics_process(delta):
	timer_logic()
	check_match_status()
	
	
func timer_logic():
	
	# Countdown Timer
	if current_phase == match_phase.COUNTDOWN:
		countdown_timer -= 1
		if countdown_timer == 180:
			countdown_timer_string = "3"
		elif countdown_timer == 120:
			countdown_timer_string = "2"
		elif countdown_timer == 60:
			countdown_timer_string = "1"
		elif countdown_timer == 0:
			countdown_timer_string = "GO!"
			current_phase = match_phase.FIGHT
			p1_reference.recieves_input = true
			p2_reference.recieves_input = true
			
	
	# Game Timer	
	elif current_phase == match_phase.FIGHT:
		match_timer += 1
		if match_timer == 60:
			countdown_timer_string = ""
		var frames_remaining = match_length - match_timer
		var minutes_remaining = floor(frames_remaining / 3600)
		frames_remaining -= minutes_remaining * 3600
		var seconds_remaining = floor(frames_remaining / 60)
		frames_remaining -= seconds_remaining * 60
		seconds_remaining = str(seconds_remaining)
		if seconds_remaining.length() == 1:
			seconds_remaining = "0" + seconds_remaining
		frames_remaining = str(frames_remaining)
		if frames_remaining.length() == 1:
			frames_remaining = "0" + frames_remaining	
		match_timer_string = str(minutes_remaining) + ":" + seconds_remaining# + "." + frames_remaining
		if(match_timer == match_length):
			current_phase = match_phase.END

func check_match_status():
	if p1_stock == 0 or p2_stock == 0:
		current_phase = match_phase.END
		


