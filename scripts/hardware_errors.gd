extends Area2D

var has_entered = false
var has_exited = false
@export var saved_entry_time: float = 0.0
@export var elapsed_time: float = 0.0
@export var missed: bool = false
@export var zone_num: int
var timing_active: bool = false
@onready var hud = get_parent().get_parent().find_child("HUD")

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	if hud:
		hud.hardware_error_input.connect(_on_hardware_error)
		hud.altitude_error_input.connect(_on_altitude_error)
	else:
		push_error("Could not find HUD node to connect hardware_error_input signal")


func _process(delta):
	if timing_active:
		elapsed_time += delta


func make_error(err_no):
	if err_no == 1:
		hud.radio_error = true
	elif err_no == 2:
		hud.alt_error = true
	elif err_no == 3:
		hud.alt_error = true
	elif err_no == 4:
		hud.radio_error = true
	elif err_no == 5:
		hud.radio_error = true
	elif err_no == 6:
		hud.alt_error = true
	elif err_no == 7:
		hud.alt_error = true


func fix_error(err_no):
	if err_no == 1:
		hud.radio_error = false
	elif err_no == 2:
		hud.alt_error = false
	elif err_no == 3:
		hud.alt_error = false
	elif err_no == 4:
		hud.radio_error = false
	elif err_no == 5:
		hud.radio_error = false
	elif err_no == 6:
		hud.alt_error = false
	elif err_no == 7:
		hud.alt_error = false


func _on_area_entered(area: Area2D) -> void:
	if not has_entered:
		has_entered = true
		missed = false
		elapsed_time = 0.0
		timing_active = true
		make_error(zone_num)
		print("Drone entered hardware error area for the first time!")


func  _on_area_exited(area: Area2D) -> void:
	if has_entered and not has_exited:
		has_exited = true
		print("Drone exited hardware error area for the first time!")
		if timing_active:
			timing_active = false
			missed = true
			Global.results["HardwareError"][zone_num]["missed"] = missed
			fix_error(zone_num)
			print("Drone exited hardware error area before timer was stopped - Missed!")


func _on_hardware_error():
	if timing_active:
		timing_active = false
		saved_entry_time = elapsed_time
		Global.results["HardwareError"][zone_num]["time"] = elapsed_time
		Global.results["HardwareError"][zone_num]["missed"] = missed
		fix_error(zone_num)
		print("Timer stopped! Elapsed time: ", saved_entry_time)


func _on_altitude_error():
	if timing_active:
		timing_active = false
		saved_entry_time = elapsed_time
		Global.results["HardwareError"][zone_num]["time"] = elapsed_time
		Global.results["HardwareError"][zone_num]["missed"] = missed
		fix_error(zone_num)
		print("Timer stopped! Elapsed time: ", saved_entry_time)
