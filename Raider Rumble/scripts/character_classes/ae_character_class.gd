class_name AECharacterClass
extends Node

var character_name = "Architectural Engineer"
var character_sprite_frames: SpriteFrames = preload("res://sprites/characters/architectural engineer/sf_architectural_engineer.tres")
var animation_map: Dictionary = {
	"airborne": preload("res://animations/ae_animations/ae_airborne_animation.tres"),
	"blocking": preload("res://animations/ae_animations/ae_blocking_animation.tres"),
	"crouching": preload("res://animations/ae_animations/ae_crouching_animation.tres"),
	"down_attack": preload("res://animations/ae_animations/ae_down_attack_animation.tres"),
	"down_special": preload("res://animations/ae_animations/ae_down_special_animation.tres"),
	"forward_attack": preload("res://animations/ae_animations/ae_forward_attack_animation.tres"),
	"forward_special": preload("res://animations/ae_animations/ae_forward_special_animation.tres"),
	"idle": preload("res://animations/ae_animations/ae_idle_animation.tres"),
	"neutral_attack": preload("res://animations/ae_animations/ae_neutral_attack_animation.tres"),
	"neutral_special": preload("res://animations/ae_animations/ae_neutral_special_animation.tres"),
	"running": preload("res://animations/ae_animations/ae_running_animation.tres"),
	"stunned": preload("res://animations/ae_animations/ae_stunned_animation.tres"),
	"up_attack": preload("res://animations/ae_animations/ae_up_attack_animation.tres"),
	"up_special": preload("res://animations/ae_animations/ae_up_special_animation.tres")
}

var attribute_map: Dictionary = {
	
	PlayerVariables.PlayerAttributes.GROUND_SPEED: 250,
	PlayerVariables.PlayerAttributes.AIR_SPEED: 175,
	PlayerVariables.PlayerAttributes.MAX_JUMPS: 2,
	PlayerVariables.PlayerAttributes.JUMP_POWER: 300,
	PlayerVariables.PlayerAttributes.JUMP_DURATION: 10,
	PlayerVariables.PlayerAttributes.WEIGHT: 35,
	PlayerVariables.PlayerAttributes.FALL_SPEED: 750

}
