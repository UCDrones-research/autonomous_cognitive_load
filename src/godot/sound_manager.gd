extends Node

@onready var camera_sound = $CameraSound

func play_sound(key):
	var sound = get(key)
	if sound is AudioStreamPlayer:
		sound.play()
	else:
		print("Sound " + key + " not found!")
