extends Path2D

signal flight_done

@onready var path = $"."
@onready var path_follow = $PathFollow2D
@onready var path_display = load("res://scenes/planned_path.tres")
@onready var path_actual =  load("res://scenes/flight_path.tres")
@onready var drone = $PathFollow2D/Drone
@onready var hud = get_parent().find_child("HUD")

const SPEED = 0.000833333333333

func _ready():
	hud.camera_on = true
	path.curve = path_display
	path_follow.set_progress_ratio(0)
	var line = Line2D.new()
	line.default_color = Color(1, 1, 1, 1)
	line.width = 3
	line.antialiased = true
	for point in path.curve.get_baked_points():
		line.add_point(point + path_follow.position)
	add_child(line)
	path.curve = path_actual
	path_follow.set_progress_ratio(0)


func _process(delta):
	var new_progress = path_follow.progress_ratio + (SPEED * delta)
	new_progress = clamp(new_progress, 0.0, 1.0)
	path_follow.progress_ratio = new_progress
	if path_follow.progress_ratio >= 1:
		emit_signal("flight_done")
		queue_free()


func return_progress():
	#print(path_follow.progress_ratio)
	return path_follow.progress_ratio
