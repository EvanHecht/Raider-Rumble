class_name Player
extends KinematicBody2D

# Scenes
var death_blast = preload("res://scenes/death_blast.tscn") 

# Nodes
onready var animation_state: AnimationNodeStateMachinePlayback = $AnimatedSprite/AnimationTree.get("parameters/playback")
onready var player_sprite: AnimatedSprite = $AnimatedSprite
onready var animation_player: AnimationPlayer = $AnimatedSprite/AnimationPlayer
onready var moveset_functions: Node = $MovesetFunctions

# Attributes
export(PlayerVariables.PlayerNumber) var player_num = PlayerVariables.PlayerNumber.PLAYER_1
var character = PlayerVariables.Characters.TEMPLATE
var input_map: Dictionary = {}
var attribute_map: Dictionary = {}
var movement_vector: Vector2 = Vector2.ZERO
var knockback_vector: Vector2 = Vector2.ZERO
onready var spawn_location: Vector2 = position
var death_location: Vector2 = position
var remaining_jumps: float = 0
var jumping: bool = false
var airborne: bool = false
var crouching: bool = false
var jump_duration: float = 0
var hitstun: float = 0
var i_frames = 0
var death_timer = 0
var damage: float = 0
var action: String = ""
var launch_angle: float = 0
var recieves_input: float = true
var direction_facing: float = 1 # 1 = Right | -1 = Left
var performing_move: bool = false
var can_aerial_recovery: bool = true
var blocking: bool = false
var aerial_movement_enabled = true
var grounded_movement_enabled = true
var character_class = null


func _ready() -> void:
	
	if player_num == PlayerVariables.PlayerNumber.PLAYER_1:
		MatchVariables.p1_reference = self
		input_map = PlayerVariables.player_1_input_map
		character = MatchVariables.p1_character

	elif player_num == PlayerVariables.PlayerNumber.PLAYER_2:
		MatchVariables.p2_reference = self
		input_map = PlayerVariables.player_2_input_map
		character = MatchVariables.p2_character
		direction_facing = -1
		player_sprite.flip_h = true
		
	character_class = PlayerVariables.character_classes.get(character)
	attribute_map = character_class.attribute_map.duplicate()
	player_sprite.frames = character_class.character_sprite_frames
	
	for key in character_class.animation_map.keys():
		animation_player.remove_animation(key)
		var value = character_class.animation_map.get(key)
		animation_player.add_animation(key, value)
	
	

func _process(delta: float) -> void:
	action = animation_state.get_current_node()
	
	# i_frames
	if i_frames > 0:
		player_sprite.modulate.a = .5
	else:
		player_sprite.modulate.a = 1


func _physics_process(delta: float) -> void:
	print(str(player_num) + ": " + str(hitstun))
	if !recieves_input:
		return
	
	# Horizontal Movement
	if  hitstun == 0 and !blocking and !crouching and ((grounded_movement_enabled and !airborne) or (aerial_movement_enabled and airborne)):
		var current_movement_speed = get_attribute(PlayerVariables.PlayerAttributes.GROUND_SPEED)
		if !is_on_floor():
			current_movement_speed = get_attribute(PlayerVariables.PlayerAttributes.AIR_SPEED)
		movement_vector.x = input_strength(PlayerVariables.PlayerInputs.MOVE_RIGHT) - input_strength(PlayerVariables.PlayerInputs.MOVE_LEFT)
		movement_vector.x *= get_attribute(PlayerVariables.PlayerAttributes.GROUND_SPEED)
	else:
		movement_vector.x = 0
	
	# Gravity
	if is_on_floor():
		movement_vector.y = 0
		remaining_jumps = get_attribute(PlayerVariables.PlayerAttributes.MAX_JUMPS)
		can_aerial_recovery = true
		airborne = false
	else:
		airborne = true
	movement_vector.y += get_attribute(PlayerVariables.PlayerAttributes.WEIGHT)
	movement_vector.y = min(movement_vector.y, get_attribute(PlayerVariables.PlayerAttributes.FALL_SPEED))
	
	# Jumping
	if hitstun == 0 and remaining_jumps > 0 and input_just_pressed(PlayerVariables.PlayerInputs.JUMP) and !performing_move:
		jumping = true
		remaining_jumps -= 1
		movement_vector.y = 0
		jump_duration = 0
	if jumping and input_pressed(PlayerVariables.PlayerInputs.JUMP) and jump_duration < get_attribute(PlayerVariables.PlayerAttributes.JUMP_DURATION) and !performing_move:
		jump_duration += 1
		movement_vector.y -= get_attribute(PlayerVariables.PlayerAttributes.JUMP_POWER)/jump_duration
	else:
		jumping = false
	
	# Knockback vector
	var deceleration_value = sign(knockback_vector.x) * get_attribute(PlayerVariables.PlayerAttributes.WEIGHT) * abs(cos(deg2rad(launch_angle)))
	if abs(deceleration_value) > abs(knockback_vector.x):
		deceleration_value = knockback_vector.x
	knockback_vector.x -= deceleration_value
	deceleration_value = sign(knockback_vector.y) * get_attribute(PlayerVariables.PlayerAttributes.WEIGHT) * abs(sin(deg2rad(launch_angle)))
	if abs(deceleration_value) > abs(knockback_vector.y):
		deceleration_value = knockback_vector.y
	knockback_vector.y -= deceleration_value
	
	# Remove hit stun each frame
	if hitstun > 0: hitstun -= 1
	if i_frames > 0: i_frames -= 1
	set_animation_tree_conditions()

	perform_moveset()
	
	determine_animation()

	move_and_slide(movement_vector + knockback_vector, Vector2.UP)
	
	handle_death()


func perform_moveset():
	
	# If already performing a move, don't cancel it
	if performing_move or blocking: return
	
	# Down Attack	
	if input_pressed(PlayerVariables.PlayerInputs.CROUCH) and input_just_pressed(PlayerVariables.PlayerInputs.ATTACK):
		animation_state.travel("down_attack")
		performing_move = true
		
	# Up Attack
	elif input_pressed(PlayerVariables.PlayerInputs.UP) and input_just_pressed(PlayerVariables.PlayerInputs.ATTACK):
		animation_state.travel("up_attack")
		performing_move = true
		
	# Neutral Attack
	elif movement_vector.x == 0 and input_just_pressed(PlayerVariables.PlayerInputs.ATTACK):
		animation_state.travel("neutral_attack")
		performing_move = true
		
	# Forward Attack
	elif movement_vector.x != 0 and input_just_pressed(PlayerVariables.PlayerInputs.ATTACK):
		animation_state.travel("forward_attack")
		performing_move = true
	
	# Up Special
	elif can_aerial_recovery and input_pressed(PlayerVariables.PlayerInputs.UP) and input_just_pressed(PlayerVariables.PlayerInputs.SPECIAL):
		animation_state.travel("up_special")
		performing_move = true
		can_aerial_recovery = false
	
		# Down Special
	elif input_pressed(PlayerVariables.PlayerInputs.CROUCH) and input_just_pressed(PlayerVariables.PlayerInputs.SPECIAL):
		animation_state.travel("down_special")
		performing_move = true
	
	# Forward Special
	elif movement_vector.x != 0 and input_just_pressed(PlayerVariables.PlayerInputs.SPECIAL):
		animation_state.travel("forward_special")
		performing_move = true
				
	# Neutral Special
	elif movement_vector.x == 0 and input_just_pressed(PlayerVariables.PlayerInputs.SPECIAL):
		animation_state.travel("neutral_special")
		performing_move = true


func set_animation_tree_conditions():
	$AnimatedSprite/AnimationTree["parameters/conditions/is_airborne"] = !is_on_floor()
	$AnimatedSprite/AnimationTree["parameters/conditions/is_crouching"] = crouching


func determine_animation():
	
	crouching = false
	blocking = false
	
	# Determine Direction
	if(movement_vector.x != 0):
		direction_facing = sign(movement_vector.x)
	if(direction_facing == 1):
		player_sprite.flip_h = false
	else:
		player_sprite.flip_h = true
	
	# Stunned
	if hitstun > 0:
		# animation set to stunned
		return
	elif performing_move:
		return

	# Airborne
	if !is_on_floor():
		animation_state.travel("airborne")
		var neutral_frame_threshold = 200
		if (movement_vector.y < -neutral_frame_threshold):
			player_sprite.frame = 0
		elif (movement_vector.y > neutral_frame_threshold):
			player_sprite.frame = 2
		else:
			player_sprite.frame = 1
	
	elif input_pressed(PlayerVariables.PlayerInputs.BLOCK):
		animation_state.travel("blocking")
		blocking = true
	
	# Crouching
	elif input_pressed(PlayerVariables.PlayerInputs.CROUCH):
		animation_state.travel("crouching")
		crouching = true
		
	# Running
	elif movement_vector.x != 0:
		animation_state.travel("running")

	# Idle
	else:
		animation_state.travel("idle")


func get_attribute(attribute):
	return attribute_map.get(attribute)


func recieve_hit(hitbox, damage: float, launch_power: float, launch_angle: float, hitstun: float):

	# successful block
	if(i_frames > 0 or (blocking and ((hitbox.global_position.x > global_position.x and direction_facing == 1) or (hitbox.global_position.x < global_position.x and direction_facing == -1)))):
		return
		
	moveset_functions.end_move()
	self.damage += damage
	self.launch_angle = launch_angle
	self.hitstun = hitstun
	
	if hitbox.global_position.x > global_position.x:
		direction_facing = 1
	else:
		direction_facing = -1

	movement_vector = Vector2.ZERO
	knockback_vector.x = cos(deg2rad(launch_angle)) * launch_power * (1 + (self.damage/100))
	knockback_vector.y = -sin(deg2rad(launch_angle)) * launch_power * (1 + (self.damage/100))
	animation_state.travel("stunned")


func handle_death():
	
	if death_timer == 0 and (position.x >= MatchVariables.blastzone_right or position.x <= MatchVariables.blastzone_left or position.y <= MatchVariables.blastzone_up or position.y >= MatchVariables.blastzone_down):
		
		var blast = death_blast.instance()
		blast.position = position
		get_parent().add_child(blast)
		
		
		if player_num == PlayerVariables.PlayerNumber.PLAYER_1:
			MatchVariables.p1_stock -= 1
			
		elif player_num == PlayerVariables.PlayerNumber.PLAYER_2:
			MatchVariables.p2_stock -= 1
		
		damage = 0
		i_frames = 150
		death_timer = 150
		death_location = position
		
		
	if death_timer > 0 and ((MatchVariables.p1_stock > 0 and player_num == PlayerVariables.PlayerNumber.PLAYER_1) or (MatchVariables.p2_stock > 0 and player_num == PlayerVariables.PlayerNumber.PLAYER_2)):
		death_timer -= 1
		position = death_location
		if death_timer == 0:
			position = spawn_location
			i_frames = 120
			movement_vector = Vector2.ZERO
			knockback_vector = Vector2.ZERO

# INPUT FUNCTIONS (These exist because native input calls using our custom input system are quite long)
func input_pressed(input):
	if !recieves_input:
		return

	assert(input in PlayerVariables.PlayerInputs.values(), "input_pressed in player.gd recieved invalid input: " + str(input))
	return Input.is_action_pressed(input_map.get(input))

func input_just_pressed(input):
	if !recieves_input:
		return

	assert(input in PlayerVariables.PlayerInputs.values(), "input_just_pressed in player.gd recieved invalid input: " + str(input))
	return Input.is_action_just_pressed(input_map.get(input))

func input_just_released(input):
	if !recieves_input:
		return
	assert(input in PlayerVariables.PlayerInputs.values(), "input_just_releasedin player.gd recieved invalid input: " + str(input))
	return Input.is_action_just_released(input_map.get(input))

func input_strength(input):
	if !recieves_input:
		return
	assert(input in PlayerVariables.PlayerInputs.values(), "input_strength in player.gd recieved invalid input: " + str(input))
	return Input.get_action_strength(input_map.get(input))

