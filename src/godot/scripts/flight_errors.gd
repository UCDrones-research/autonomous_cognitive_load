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
		hud.flight_error_input.connect(_on_flight_error)
	else:
		push_error("Could not find HUD node to connect flight_error_input signal")


func _process(delta):
	if timing_active:
		elapsed_time += delta


func _on_area_entered(area: Area2D) -> void:
	if not has_entered:
		has_entered = true
		missed = false
		elapsed_time = 0.0
		timing_active = true
		hud.flight_error_instance += 1
		print("Drone entered flight error area for the first time!")
		Global.timestamps["flight_error_enter"][hud.flight_error_instance] = hud.curr_time


func _on_area_exited(area: Area2D) -> void:
	if has_entered and not has_exited:
		has_exited = true
		Global.timestamps["flight_error_exit"][hud.camera_error_instance] = hud.curr_time
		print("Drone exited flight error area for the first time!")
		await get_tree().create_timer(2).timeout
		if timing_active:
			timing_active = false
			missed = true
			Global.results["FlightError"][zone_num]["missed"] = missed
			print("Drone exited flight error area before timer was stopped - Missed!")


func _on_flight_error():
	if timing_active:
		timing_active = false
		saved_entry_time = elapsed_time
		Global.results["FlightError"][zone_num]["time"] = elapsed_time
		Global.results["FlightError"][zone_num]["missed"] = missed
		print("Timer stopped! Elapsed time: ", saved_entry_time)
