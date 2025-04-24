extends Node2D

var missed = 0
var time = 0
var started = false
var camera_error = false
var camera_error_count = 0
var hardware_error = false
var hardware_error_count = 0
var picture_total = 0
var last_picture_time = 0

@onready var hud = $UI/HUD
@onready var ui = $UI

var flight_path = preload("res://scenes/flight_path.tscn")
var reactive_flight_path = preload("res://scenes/reactive_flight_path.tscn")
var tutorial_flight_path = preload("res://scenes/tutorial_flight_path.tscn")
var path



func _ready():
	hud.set_battery_level(100)
	hud.set_altitude_label(390)
	hud.set_radio_level(100)
	hud.set_camera_label(0)
	hud.tutorial_flight_path_spawn.connect(_on_hud_tutorial_flight_path_spawn)


func _on_hud_tutorial_flight_path_spawn() -> void:
	var flight_path_instance = tutorial_flight_path.instantiate()
	get_tree().current_scene.add_child(flight_path_instance)
	flight_path_instance.name = "FlightPath"
	path = flight_path_instance
	path.tutorial_done.connect(hud.tutorial_done)
	picture_total = 0
	started = true


func _on_hud_flight_path_spawn() -> void:
	var flight_path_instance = flight_path.instantiate()
	get_tree().current_scene.add_child(flight_path_instance)
	flight_path_instance.name = "FlightPath"
	path = flight_path_instance
	path.flight_done.connect(hud.results_screen)
	picture_total = 0
	started = true


func _on_hud_reactive_flight_path_spawn() -> void:
	var flight_path_instance = reactive_flight_path.instantiate()
	get_tree().current_scene.add_child(flight_path_instance)
	flight_path_instance.name = "FlightPath"
	path = flight_path_instance
	path.flight_done.connect(hud.reactive_miss_count)
	picture_total = 0
	started = true


func _physics_process(delta):
	if started and path != null:
		var progress = path.return_progress()
		if progress != null:
			hud.set_battery_level(100 - (progress * 60))
			hud.set_altitude_label(progress)
			hud.set_radio_level(progress)
			if hud.camera_on:
				if last_picture_time < 60:
					last_picture_time += 1
					#print(last_picture_time)
				else:
					last_picture_time = 0
					picture_total += 1
					hud.set_camera_label(picture_total)
					#print(picture_total)
