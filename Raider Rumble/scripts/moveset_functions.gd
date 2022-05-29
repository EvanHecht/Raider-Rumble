class_name MovesetFunctions
extends Node

var hitbox_scene = preload("res://scenes/hitbox.tscn")
var projectile_scene = preload("res://scenes/projectile_hitbox.tscn")

# NOTE: The functions in this script with an argument count > 5 are handled
# containing the arguments in an array because the animation player node only
# only allows up to 5 arguments passed in through the inspector.
onready var player: KinematicBody2D = get_parent()
onready var animation_state: AnimationNodeStateMachinePlayback = get_parent().get_node("AnimatedSprite/AnimationTree").get("parameters/playback")

# Should be called at the start of each move
func start_move():
	player.performing_move = true

# Should be called at the end of each move to clean up
func end_move():
	player.performing_move = false
	player.grounded_movement_enabled = true
	player.aerial_movement_enabled = true

# Set true if player can move horizontally while grounded, false otherwise
func set_grounded_movement_enabled(is_enabled: bool):
	player.grounded_movement_enabled = is_enabled


# Set true if player can move horizontally in air, false otherwise
func set_aerial_movement_enabled(is_enabled: bool):
	player.aerial_movement_enabled = is_enabled


# Will only affect the player while they are grounded
# Value: The speed in pixels per frame
# Absolute: True for absolute movement (negative to left, positive to right)
#		    False for direction character is facing to influence movement
func set_grounded_horizontal_speed(value: float, absolute: bool):
	if !player.airborne:
		player.movement_vector.x = value
		if(!absolute):
			player.movement_vector.x *= player.direction_facing

func move_relative(x: float, y: float):
	var move_vector: Vector2 = Vector2(x * player.direction_facing, y)
	player.move_and_slide(move_vector, Vector2.UP)

# Will only affect the player while they are grounded
# Value: The speed in pixels per frame
# Absolute: True for absolute movement (negative to left, positive to right)
#		    False for direction character is facing to influence movement
func set_aerial_horizontal_speed(value: float, absolute: bool):
	if player.airborne:
		player.movement_vector.x = value
		if(!absolute):
			player.movement_vector.x *= player.direction_facing

# Sets the players vertical speed
func set_vertical_speed(value: float):
	player.movement_vector.y = value

# Moves the player x_distance along the x-axis, and y_distance along the y-axis
func move_player(x_distance: float, y_distance: float):
	var move_vector: Vector2 = Vector2(x_distance, y_distance)
	player.move_and_slide(move_vector, Vector2.UP)

func heal(amount: int):
	player.damage = max(player.damage - amount, 0)


# 0 x: float                 | desired horizontal distance from the player
# 1 y: float                 | desired vertical distance from the player
# 2 width: float             | the width of the hitbox
# 3 height: float            | the height of the hitbox
# 4 duration: float          | how many frames the hitbox should last (game frames not animation, 60/sec)
# 5 damage: float            | the damage of the hitbox
# 6 launch_power: float      | the speed the hit player should be launched
# 7 hitstun: float           | the number of hitstun frames the hitbox inflicts
# 8 launch_angle: float      | the angle the hitbox launches the player at
# 9 is_relative: bool        | if the hitbox angle and positions should be relative to the direction the player is facing
func spawn_hitbox(args: Array):
	var new_hitbox = hitbox_scene.instance()
	new_hitbox.init(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], get_node("../"))
	get_node("../Hitboxes").add_child(new_hitbox)

# 0 x: float                 | desired horizontal distance from the player
# 1 y: float                 | desired vertical distance from the player
# 2 width: float             | the width of the hitbox
# 3 height: float            | the height of the hitbox
# 4 duration: float          | how many frames the hitbox should last (game frames not animation, 60/sec)
# 5 damage: float            | the damage of the hitbox
# 6 launch_power: float      | the speed the hit player should be launched
# 7 hitstun: float           | the number of hitstun frames the hitbox inflicts
# 8 launch_angle: float      | the angle the hitbox launches the player at
# 9 h_speed: float           | the number of hitstun frames the hitbox inflicts
# 10 v_speed: float          | the angle the hitbox launches the player at
# 11 grav: bool             | if the hitbox angle and positions should be relative to the direction the player is facing
# 12 sprite_path: string
func spawn_projectile(args: Array):
	var new_projectile = projectile_scene.instance()
	new_projectile.projectile_init(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], get_node("../"))
	MatchVariables.stage.add_child(new_projectile)

	
