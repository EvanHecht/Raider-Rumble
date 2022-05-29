extends Control

onready var match_timer: Label = $Timer
onready var countdown_timer: Label = $CountdownTimer
onready var p1_damage_counter: AnimatedSprite = $P1DamageCounter
onready var p1_damage_label: Label = $P1DamageCounter/P1DamageLabel
onready var p2_damage_counter: AnimatedSprite = $P2DamageCounter
onready var p2_damage_label: Label = $P2DamageCounter/P2DamageLabel
onready var transition_color: ColorRect = $TransitionColor
onready var match_end_label: Label = $MatchEndLabel
var decided = false

func _process(delta: float) -> void:
	update_damage_counters()
	update_timers()
	update_transitions()


func update_damage_counters() -> void:
	p1_damage_counter.frame = 3 - MatchVariables.p1_stock
	p2_damage_counter.frame = 3 - MatchVariables.p2_stock
	p1_damage_label.text = str(MatchVariables.p1_reference.damage) + "%"
	p2_damage_label.text = str(MatchVariables.p2_reference.damage) + "%"


func update_timers() -> void:
	countdown_timer.text = MatchVariables.countdown_timer_string
	match_timer.text = MatchVariables.match_timer_string
	if !MatchVariables.current_phase == MatchVariables.match_phase.COUNTDOWN:
		match_timer.visible = true
	else:
		match_timer.visible = false
		

func update_transitions():
	if MatchVariables.current_phase == MatchVariables.match_phase.END:
		
		if !decided:
			decided = true
			if MatchVariables.p2_stock <= 0:
				match_end_label.text = "P1 WINS!"
				match_end_label.modulate = Color.red
			elif MatchVariables.p1_stock <= 0:
				match_end_label.text = "P2 WINS!"
				match_end_label.modulate = Color.dodgerblue
			else:
				match_end_label.text = "TIE!"
		
		transition_color.color.a += .01
		match_end_label.visible = true
		if transition_color.color.a >= 1 and (Input.is_action_just_pressed("p1_attack") or Input.is_action_just_pressed("p2_attack")):
			get_tree().change_scene_to(load("res://scenes/character_selection.tscn"))
	else:
		transition_color.color.a -= .025
		
	transition_color.color.a = clamp(transition_color.color.a, 0, 1)
