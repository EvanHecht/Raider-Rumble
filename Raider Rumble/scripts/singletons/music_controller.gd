extends AudioStreamPlayer

onready var VolumeLabel = $CanvasLayer/VolumeLabel
onready var SFXController = $SFXController

var menu_music = preload("res://sound/Everythings_Fine_Raider_Rumble.wav")
var battle_music = preload("res://sound/Something_Else_Raider_Rumble.wav")
var volume = .65
var min_volume = -80.0
var max_volume = 0.0
var db = max_volume

var effects = {
	"confirm": preload("res://sound/snd_confirm.wav"),
	"selector_move": preload("res://sound/snd_selector_move.wav"),
	"death": preload("res://sound/death.wav"),
	"hit_1": preload("res://sound/snd_hit1.wav"),
	"hit_2": preload("res://sound/snd_hit2.wav"),
	"hit_3": preload("res://sound/snd_hit3.wav")
	
	
}

func _init():
	db = min_volume + (80.0 * volume)
	set_volume_db(db)
	
func _ready():
	SFXController.set_volume_db(abs(db)*.65*sign(db))
	
func _physics_process(delta):
	VolumeLabel.modulate.a -= .01
	VolumeLabel.modulate.a = max(VolumeLabel.modulate.a, 0)

func play_menu_music():
	if stream != menu_music:
		stream = menu_music
		play()

func play_battle_music():
	if stream != battle_music:
		stream = battle_music
		play()

func change_volume(amount: float):
	volume = clamp(volume + amount, 0.0, 1.0)
	db = min_volume + (80.0 * volume)
	set_volume_db(db)
	SFXController.set_volume_db(abs(db)*.65*sign(db))
	VolumeLabel.modulate.a = 1
	var level = volume * 100.0
	level = int(level)
	VolumeLabel.text = "Volume: " + str(level) + "%"
	
func play_sound_effect(effect_name):
	var effect = effects[effect_name]
	SFXController.stream = effect
	SFXController.play()
	
func play_hit_sound():
	var num =  1 + (randi() % 3)
	var effect = effects["hit_" + str(num)]
	SFXController.stream = effect
	SFXController.play()
