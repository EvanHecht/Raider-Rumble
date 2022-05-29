extends Node2D

# Nodes
onready var background: TextureRect = $Background
onready var damageCounter1: Label = $DamageCounter1
onready var damageCounter2: Label = $DamageCounter2
onready var Player1Node = get_node("/root/TestStage/Player")
onready var Player2Node = get_node("/root/TestStage/Player2")

# Variables
var background_speed: float = 100

func _process(delta: float) -> void:
	scroll_background(delta)
	damageCounter1.text = str(Player1Node.damage)
	damageCounter2.text = str(Player2Node.damage)
	
		
	
func scroll_background(delta: float) -> void:
	
	# Move the background on both axis
	background.rect_position.x += background_speed * delta
	background.rect_position.y += background_speed * delta
	
	# Reset the background for infinite looping
	if background.rect_position.x > 0:
		background.rect_position.x -= background.rect_size.x/2
	if background.rect_position.y > 0:
		background.rect_position.y -= background.rect_size.y/2

