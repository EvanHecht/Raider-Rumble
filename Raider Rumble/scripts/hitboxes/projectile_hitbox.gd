class_name ProjectileHitbox
extends Area2D

onready var sprite: Sprite = $Sprite
onready var colored_rectangle: ColorRect = $Collider/ColorRect
onready var collider: CollisionShape2D = $Collider

var x: float = 0
var y: float = 0
var duration: float = 0
var width: float = 20
var height: float = 20
var damage: float = 20
var launch_power: float = 1
var launch_angle: float = 20
var hitstun: float = 20
var creator: Player = null
var h_speed: float
var v_speed: float
var grav: bool
var texture
var overlaping_bodies: Array = Array()
var hit_list: Array = Array()
var showing = false

# Hitbox Constructor
func projectile_init( x: float, y: float, width: float, height: float, duration: float, damage: float, launch_power: float, hitstun: float, launch_angle: float, h_speed: float, v_speed: float, grav: bool, texture: String, creator: Player):
	self.x = x
	self.y = y
	self.duration = duration
	self.width = width
	self.height = height
	self.damage = damage
	self.launch_power = launch_power
	self.launch_angle = launch_angle
	self.hitstun = hitstun
	self.creator = creator
	self.h_speed = h_speed
	self.v_speed = v_speed
	self.grav = grav
	self.texture = texture
	self.h_speed *= creator.direction_facing

func _ready():
	print("GGGDG")
	sprite.texture = load(texture)
	position.x = creator.position.x + (x * creator.direction_facing)
	position.y = creator.position.y + y
	
	collider.shape.extents = Vector2(width/2, height/2)
	colored_rectangle.rect_position.x = -width/2
	colored_rectangle.rect_position.y = -height/2
	colored_rectangle.rect_size.x = width
	colored_rectangle.rect_size.y = height
	colored_rectangle.visible = showing
	if creator.direction_facing == -1:
		sprite.flip_h = true
	
func _physics_process(delta):
	movement()
	check_visibility()
	
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
			if position.x > body.position.x:
				effective_angle = 180 - effective_angle
			target_player.recieve_hit(self, damage, launch_power, effective_angle, hitstun)
			hit_list.append(body)
			MusicController.play_hit_sound()
			queue_free()


func check_visibility() -> void:
	showing = GlobalVariables.showing_hitboxes
	colored_rectangle.visible = showing

func movement():
	var to_move = abs(h_speed)
	while to_move > 0:
		to_move = max(to_move - 1, 0)
		position.x += sign(h_speed)
		apply_hitbox()
	to_move = abs(v_speed)
	while to_move > 0:
		to_move = max(to_move - 1, 0)
		position.y += v_speed
		apply_hitbox()
	
		
