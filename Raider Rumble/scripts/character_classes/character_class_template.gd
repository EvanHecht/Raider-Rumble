class_name CharacterClassTemplate
extends Node

var character_name = "character name"
var character_sprite_frames: SpriteFrames = null

var attribute_map: Dictionary = {
	
	PlayerVariables.PlayerAttributes.GROUND_SPEED: 250,
	PlayerVariables.PlayerAttributes.AIR_SPEED: 175,
	PlayerVariables.PlayerAttributes.MAX_JUMPS: 2,
	PlayerVariables.PlayerAttributes.JUMP_POWER: 300,
	PlayerVariables.PlayerAttributes.JUMP_DURATION: 10,
	PlayerVariables.PlayerAttributes.WEIGHT: 35,
	PlayerVariables.PlayerAttributes.FALL_SPEED: 750

}
