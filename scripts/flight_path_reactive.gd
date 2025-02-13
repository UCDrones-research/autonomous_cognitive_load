extends Path2D

signal flight_done

@onready var path = $"."
@onready var path_follow = $PathFollow2D
@onready var path_actual =  load("res://scenes/reactive_flight_path.tres")
@onready var drone = $PathFollow2D/Drone

const SPEED = 0.00166666666667

func _ready():
	path.curve = path_actual
	path_follow.set_progress_ratio(0)


func _process(delta):
	var new_progress = path_follow.progress_ratio + (SPEED * delta)
	new_progress = clamp(new_progress, 0.0, 1.0)
	path_follow.progress_ratio = new_progress
	if path_follow.progress_ratio >= 1:
		print("done")
		emit_signal("flight_done")
		queue_free()


func return_progress():
	#print(path_follow.progress_ratio)
	return path_follow.progress_ratio
