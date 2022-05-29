class_name MECharacterClass
extends Node

var character_name = "Mechanical Engineering"
var character_sprite_frames: SpriteFrames = preload("res://sprites/characters/mechanical engineer/sf_mechanical_engineer.tres")
var animation_map: Dictionary = {
	"airborne": preload("res://animations/me_animations/me_airborne_animation.tres"),
	"blocking": preload("res://animations/me_animations/me_blocking_animation.tres"),
	"crouching": preload("res://animations/me_animations/me_crouching_animation.tres"),
	"down_attack": preload("res://animations/me_animations/me_down_attack_animation.tres"),
	"down_special": preload("res://animations/me_animations/me_down_special_animation.tres"),
	"forward_attack": preload("res://animations/me_animations/me_forward_attack_animation.tres"),
	"forward_special": preload("res://animations/me_animations/me_forward_special_animation.tres"),
	"idle": preload("res://animations/me_animations/me_idle_animation.tres"),
	"neutral_attack": preload("res://animations/me_animations/me_neutral_attack_animation.tres"),
	"neutral_special": preload("res://animations/me_animations/me_neutral_special_animation.tres"),
	"running": preload("res://animations/me_animations/me_running_animation.tres"),
	"stunned": preload("res://animations/me_animations/me_stunned_animation.tres"),
	"up_attack": preload("res://animations/me_animations/me_up_attack_animation.tres"),
	"up_special": preload("res://animations/me_animations/me_up_special_animation.tres")
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
