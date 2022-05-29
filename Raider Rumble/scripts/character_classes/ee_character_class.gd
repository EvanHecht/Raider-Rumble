class_name EECharacterClass
extends Node

var character_name = "Electrical Engineer"
var character_sprite_frames: SpriteFrames = preload("res://sprites/characters/electrical engineer/sf_electrical_engineer.tres")
var animation_map: Dictionary = {
	"airborne": preload("res://animations/ee_animations/ee_airborne_animation.tres"),
	"blocking": preload("res://animations/ee_animations/ee_blocking_animation.tres"),
	"crouching": preload("res://animations/ee_animations/ee_crouching_animation.tres"),
	"down_attack": preload("res://animations/ee_animations/ee_down_attack_animation.tres"),
	"down_special": preload("res://animations/ee_animations/ee_down_special_animation.tres"),
	"forward_attack": preload("res://animations/ee_animations/ee_forward_attack_animation.tres"),
	"forward_special": preload("res://animations/ee_animations/ee_forward_special_animation.tres"),
	"idle": preload("res://animations/ee_animations/ee_idle_animation.tres"),
	"neutral_attack": preload("res://animations/ee_animations/ee_neutral_attack_animation.tres"),
	"neutral_special": preload("res://animations/ee_animations/ee_neutral_special_animation.tres"),
	"running": preload("res://animations/ee_animations/ee_running_animation.tres"),
	"stunned": preload("res://animations/ee_animations/ee_stunned_animation.tres"),
	"up_attack": preload("res://animations/ee_animations/ee_up_attack_animation.tres"),
	"up_special": preload("res://animations/ee_animations/ee_up_special_animation.tres")
}

var attribute_map: Dictionary = {
	
	PlayerVariables.PlayerAttributes.GROUND_SPEED: 250,
	PlayerVariables.PlayerAttributes.AIR_SPEED: 175,
	PlayerVariables.PlayerAttributes.MAX_JUMPS: 2,
	PlayerVariables.PlayerAttributes.JUMP_POWER: 400,
	PlayerVariables.PlayerAttributes.JUMP_DURATION: 10,
	PlayerVariables.PlayerAttributes.WEIGHT: 50,
	PlayerVariables.PlayerAttributes.FALL_SPEED: 750

}
