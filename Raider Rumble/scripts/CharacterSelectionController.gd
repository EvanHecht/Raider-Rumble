extends Node

var player 
var playerScript1 = preload("res://scripts/player.gd")

var opponent
var playerScript2 = preload("res://scripts/player.gd")

var selectableCharacters = {
	"Character1" : preload("res://scenes/player.tscn"),
	"Character2" : preload("res://scenes/player.tscn"),
	"Character3" : preload("res://scenes/player.tscn"),
	"Character4" : preload("res://scenes/player.tscn"),
	"Character5" : preload("res://scenes/player.tscn"),
	"Character6" : preload("res://scenes/player.tscn"),
}
