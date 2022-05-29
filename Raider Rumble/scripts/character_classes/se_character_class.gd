class_name SECharacterClass
extends Node

var character_name = "Software Engineer"
var character_sprite_frames: SpriteFrames = preload("res://sprites/characters/software engineer/sf_software_engineer.tres")
var animation_map: Dictionary = {
	"airborne": preload("res://animations/se_animations/se_airborne_animation.tres"),
	"blocking": preload("res://animations/se_animations/se_blocking_animation.tres"),
	"crouching": preload("res://animations/se_animations/se_crouching_animation.tres"),
	"down_attack": preload("res://animations/se_animations/se_down_attack_animation.tres"),
	"down_special": preload("res://animations/se_animations/se_down_special_animation.tres"),
	"forward_attack": preload("res://animations/se_animations/se_forward_attack_animation.tres"),
	"forward_special": preload("res://animations/se_animations/se_forward_special_animation.tres"),
	"idle": preload("res://animations/se_animations/se_idle_animation.tres"),
	"neutral_attack": preload("res://animations/se_animations/se_neutral_attack_animation.tres"),
	"neutral_special": preload("res://animations/se_animations/se_neutral_special_animation.tres"),
	"running": preload("res://animations/se_animations/se_running_animation.tres"),
	"stunned": preload("res://animations/se_animations/se_stunned_animation.tres"),
	"up_attack": preload("res://animations/se_animations/se_up_attack_animation.tres"),
	"up_special": preload("res://animations/se_animations/se_up_special_animation.tres")
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
