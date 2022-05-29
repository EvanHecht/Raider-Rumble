class_name Hitbox
extends Area2D

# Reference to this hitbox's collider and visible component
onready var collider: CollisionShape2D = $Collider
onready var colored_rectangle: ColorRect = $Collider/ColorRect

# Hitbox Attributes
var x: float = 0
var y: float = 0
var duration: float = 0
var width: float = 20
var height: float = 20
var damage: float = 20
var launch_power: float = 1
var launch_angle: float = 20
var hitstun: float = 20
var is_relative_angle: bool = false
var creator: Player = null
var overlaping_bodies: Array = Array()
var hit_list: Array = Array()

# Used for debugging purposes
onready var showing: bool = GlobalVariables.showing_hitboxes

# Hitbox Constructor
func init( x: float, y: float, width: float, height: float, duration: float, damage: float, launch_power: float, hitstun: float, launch_angle: float, is_relative_angle: bool, creator: Player):
	self.x = x
	self.y = y
	self.duration = duration
	self.width = width
	self.height = height
	self.damage = damage
	self.launch_power = launch_power
	self.launch_angle = launch_angle
	self.is_relative_angle = is_relative_angle
	self.hitstun = hitstun
	self.creator = creator


func _ready() -> void:
	
	if creator != null:
		position.x = x * creator.direction_facing
		position.y = y #* creator.direction_facing
	
	collider.shape.extents = Vector2(width/2, height/2)
	colored_rectangle.rect_position.x = -width/2
	colored_rectangle.rect_position.y = -height/2
	colored_rectangle.rect_size.x = width
	colored_rectangle.rect_size.y = height
	colored_rectangle.visible = showing


func _physics_process(delta: float) -> void:
	check_visibility()
	
	if creator != null:
		position.x = x * creator.direction_facing
		position.y = y #* creator.direction_facing
	
	overlaping_bodies = get_overlapping_bodies()
	if !overlaping_bodies.empty():
		apply_hitbox()
		
	duration -= 1
	if duration == 0:
		queue_free()


func apply_hitbox() -> void:
	for body in overlaping_bodies:
		if body != creator and !hit_list.has(body) and body is Player:
			var target_player: Player = body
			var effective_angle = launch_angle
			if(creator.direction_facing == -1):
				effective_angle = 180 - effective_angle
			target_player.recieve_hit(self, damage, launch_power, effective_angle, hitstun)
			MusicController.play_hit_sound()
			hit_list.append(body)


func check_visibility() -> void:
	showing = GlobalVariables.showing_hitboxes
	colored_rectangle.visible = showing

