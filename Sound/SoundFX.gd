extends Node

var sounds_path = "res://resources/Music and Sounds/"

var sounds = {
	"Bullet": load(sounds_path + "Bullet.wav"),
	"Click": load(sounds_path + "Click.wav"),
	"EnemyDie": load(sounds_path + "EnemyDie.wav"),
	"Explosion": load(sounds_path + "Explosion.wav"),
	"Hurt": load(sounds_path + "Hurt.wav"),
	"Jump": load(sounds_path + "Jump.wav"),
	"Music": load(sounds_path + "Music.ogg"),
	"Pause": load(sounds_path + "Pause.wav"),
	"Powerup": load(sounds_path + "Powerup.wav"),
	"Step": load(sounds_path + "Step.wav"),
	"Unpause": load(sounds_path + "Unpause.wav")
}

onready var soundPlayers := get_children()

func play(sound_string, pitch_scale = 1, volume_db = 0):
	for player in soundPlayers:
		if not player.is_playing():
			player.pitch_scale = pitch_scale
			player.volume_db = volume_db
			player.stream = sounds[sound_string]
			player.play()
			return

	print("Multiple sounds are playing at once")
