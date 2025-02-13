extends Control

signal flight_path_spawn
signal reactive_flight_path_spawn
signal flight_error_input
signal altitude_error_input
signal camera_error_input
signal hardware_error_input

@onready var battery = $TextureRect/Battery
@onready var battery_label = $TextureRect/Battery/BatteryLabel
@onready var altitude_label = $TextureRect/Altitude/NumFeet
@onready var radio = $TextureRect/RC
@onready var radio_label = $TextureRect/RC/RCLabel
@onready var camera_label = $TextureRect/Camera/CameraLabel
@onready var camera_sound = $CameraSound
@onready var num_detected = $Results/NumDetectedLabel
@onready var num_missed = $Results/NumMissedLabel
@onready var avg_time = $Results/AvgTimeLabel

@export var alt_error = false
@export var camera_error = false
@export var camera_on = false
@export var radio_error = false
@export var isreactive = false

var alt_error_val = randi_range(10, 20)
var radio_error_val = randi_range(40, 60)
var structures_missed = 0
var rows_missed = 0

func _ready() -> void:
	isreactive = false
	$Survey.visible = true
	$Start.visible = false
	$Start2.visible = false
	$Instructions.visible = false
	$InstructionsPanel.visible = false
	$Submit.visible = false
	$"Flight Error".visible = false
	$"Camera Error/Label".text = "0"
	$"Altitude Error".visible = false
	$"Altitude Error/Label".text = "0"
	$"Hardware Error".visible = false
	$"Hardware Error/Label".text = "0"
	$"Camera Error".visible = false
	$"Camera Error/Label".text = "0"
	$Results.visible = false
	$ReactiveMissCount.visible = false


func generate_user_id(name: String):
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(name)
	return rng.randi()


func set_battery_level(new_value):
	battery.value = new_value
	battery_label.text = str(battery.value)


func altitude_curve(progress):
	var midpoint = (400 + 390) / 2
	var amplitude = (400 - 390) / 2
	var cycles = 100
	if alt_error:
		return midpoint + alt_error_val + (amplitude * sin(progress * 2 * PI * cycles))
	else:
		return midpoint + (amplitude * sin(progress * 2 * PI * cycles))


func set_altitude_label(progress):
	var new_value = altitude_curve(progress)
	altitude_label.text = str(int(new_value)) + " Feet"


func radio_curve(progress):
	var midpoint = (100 + 90) / 2
	var amplitude = (100 - 90) / 2
	var cycles = 10
	if radio_error:
		return midpoint - radio_error_val + (amplitude * sin(progress * 2 * PI * cycles))
	else:
		return midpoint + (amplitude * sin(progress * 2 * PI * cycles))


func set_radio_level(progress):
	var new_value = radio_curve(progress)
	radio.value = new_value


func set_camera_label(new_value):
	if not camera_error and camera_on:
		var new_text = str(new_value)
		if new_text != camera_label.text:
			camera_label.text = str(new_value)
			camera_sound.play()


func save_to_file(name: String):
	var log_data: Dictionary
	var fp_data: Dictionary
	var simtype: String
	if isreactive:
		simtype = "reactive"
	else:
		simtype = "planned"
	log_data["results"] = Global.results
	fp_data["FalsePositives"] = Global.falsepositives
	log_data["userinfo"] = Global.userinfo
	var timestamp = Time.get_datetime_string_from_system()
	var filename = "res://" + name + "-" + timestamp + "-" + simtype + ".json"
	var file = FileAccess.open(filename, FileAccess.WRITE)
	if isreactive:
		log_data["reactive_results"] = Global.reactive_results
	file.store_line(JSON.stringify(log_data, "\t"))
	file.store_line(JSON.stringify(fp_data, "\t"))
	file.close()
	return filename


func _download_file(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to load file")
		return
	var fname = path.get_file()
	var buffer = file.get_buffer(file.get_length())
	JavaScriptBridge.download_buffer(buffer, fname)


func get_results() -> Array:
	var global_results = Global.results
	var results = []
	var missed_true = 0
	var missed_false = 0
	var total_time = 0.0
	var average_time = 0.0
	var time_count = 0
	var detected_flight_error = 0
	var detected_camera_error = 0
	var detected_hardware_error = 0
	for error_type in global_results.keys():
		var error_data = global_results[error_type]
		for entry in error_data.values():
			if entry["missed"]:
				missed_true += 1
			else:
				missed_false += 1
				if error_type == "FlightError":
					detected_flight_error += 1
				elif error_type == "CameraError":
					detected_camera_error += 1
				else:
					detected_hardware_error += 1
			if entry["time"] != 0.0:
				total_time += entry["time"]
				time_count += 1
	if time_count > 0:
		average_time = (total_time / time_count)
	if isreactive:
		var reactive_results = Global.reactive_results
		var missed_structures = reactive_results["ObjectsMissed"]["structures"]
		var missed_rows = reactive_results["ObjectsMissed"]["rows"]
		results = [missed_false, missed_true, average_time, structures_missed, missed_rows]
	else:
		results = [missed_false, missed_true, average_time]
		print("Detected count: ", results[0])
		print("Missed count: ", results[1])
		print("Average non-zero time: ", results[2])
	Global.falsepositives["FalsePositives"]["FlightError"] = int($"Camera Error/Label".text) - detected_flight_error
	Global.falsepositives["FalsePositives"]["CameraError"] = int($"Camera Error/Label".text) - detected_camera_error
	Global.falsepositives["FalsePositives"]["HardwareError"] = int($"Camera Error/Label".text) - detected_hardware_error
	return results


func reactive_miss_count() -> void:
	$ReactiveMissCount.visible = true
	isreactive = true


func results_screen() -> void:
	var results = get_results()
	num_detected.text = str(results[0])
	num_missed.text = str(results[1])
	avg_time.text = str(results[2])
	$"Flight Error".visible = false
	$"Altitude Error".visible = false
	$"Hardware Error".visible = false
	$"Camera Error".visible = false
	$Results.visible = true
	#$NameEntry.visible = true
	#$NameSubmit.visible = true
	print("Flight Done!")


func reactive_results_screen() -> void:
	var results = get_results()
	num_detected.text = str(results[0])
	num_missed.text = str(results[1])
	avg_time.text = str(results[2])
	$"Flight Error".visible = false
	$"Altitude Error".visible = false
	$"Hardware Error".visible = false
	$"Camera Error".visible = false
	$Results.visible = true
	print("Flight Done!")


func _on_survey_submit_pressed() -> void:
	$Survey.visible = false
	$Start.visible = true
	$Start2.visible = true
	$Instructions.visible = true
	Global.userinfo["id"] = str(generate_user_id($Survey/NameEntry.text))
	Global.userinfo["age"] = int($Survey/AgeSelect.selected)
	Global.userinfo["droneexp"] = int($Survey/DroneExpSelect.selected)
	Global.userinfo["droneautoexp"] = int($Survey/DroneAutoExpSelect.selected)
	print(Global.userinfo["id"])
	print(Global.userinfo["age"])
	print(Global.userinfo["droneexp"])
	print(Global.userinfo["droneautoexp"])


func _on_start_pressed() -> void:
	$Start.visible = false
	$Start2.visible = false
	$Instructions.visible = false
	$"Flight Error".visible = true
	$"Altitude Error".visible = true
	$"Hardware Error".visible = true
	$"Camera Error".visible = true
	emit_signal("flight_path_spawn")


func _on_start_2_pressed() -> void:
	isreactive = true
	$Start.visible = false
	$Start2.visible = false
	$Instructions.visible = false
	$"Flight Error".visible = true
	$"Altitude Error".visible = true
	$"Hardware Error".visible = true
	$"Camera Error".visible = true
	emit_signal("reactive_flight_path_spawn")


func _on_instructions_pressed() -> void:
	$Start.visible = false
	$Start2.visible = false
	$Instructions.visible = false
	$"Flight Error".visible = true
	$"Altitude Error".visible = true
	$"Hardware Error".visible = true
	$"Camera Error".visible = true
	$InstructionsPanel.visible = true


func _on_done_pressed() -> void:
	$Start.visible = true
	$Start2.visible = true
	$Instructions.visible = true
	$"Flight Error".visible = false
	$"Altitude Error".visible = false
	$"Hardware Error".visible = false
	$"Camera Error".visible = false
	$InstructionsPanel.visible = false


func _on_flight_error_button_down() -> void:
	emit_signal("flight_error_input")
	print("Flight Error Input!")
	$"Flight Error/Label".text = str(1 + int($"Flight Error/Label".text))


func _on_altitude_error_button_down() -> void:
	emit_signal("altitude_error_input")
	print("Altitude Error Input!")
	$"Altitude Error/Label".text = str(1 + int($"Altitude Error/Label".text))


func _on_hardware_error_button_down() -> void:
	emit_signal("hardware_error_input")
	print("Hardware Error Input!")
	$"Hardware Error/Label".text = str(1 + int($"Hardware Error/Label".text))


func _on_camera_error_button_down() -> void:
	emit_signal("camera_error_input")
	print("Camera Error Input!")
	$"Camera Error/Label".text = str(1 + int($"Camera Error/Label".text))
	

func _on_reactive_count_pressed() -> void:
	$ReactiveMissCount.visible = false
	structures_missed = 3 - int($ReactiveMissCount/StructuesMissed.text)
	rows_missed = 3 - int($ReactiveMissCount/RowsMissed.text)
	reactive_results_screen()


func _on_download_button_pressed() -> void:
	_download_file(save_to_file(Global.userinfo["id"]))
	$Results.visible = false
	$Submit.visible = true


func _on_submit_pressed() -> void:
	_ready()
