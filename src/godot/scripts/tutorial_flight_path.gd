extends Path2D

signal tutorial_done

@onready var path = $"."
@onready var path_follow = $PathFollow2D
@onready var path_display = load("res://scenes/planned_path.tres")
@onready var path_actual =  load("res://scenes/tutorial_flight_path.tres")
@onready var drone = $PathFollow2D/Drone
@onready var hud = get_parent().find_child("HUD")
@onready var tutorial_active = true

const SPEED = 0.0866666666667

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
	hud.done_pressed.connect(_on_hud_done_pressed)
	reset_instructions()


func _process(delta):
	if tutorial_active:
		var new_progress = path_follow.progress_ratio + (SPEED * delta)
		new_progress = clamp(new_progress, 0.0, 1.0)
		path_follow.progress_ratio = new_progress
	else:
		hud.camera_on = false

	if path_follow.progress_ratio >= 1:
		queue_free()
		emit_signal("tutorial_done")


func return_progress():
	#print(path_follow.progress_ratio)
	return path_follow.progress_ratio


func  init_instructions(type: String) -> void:
	if type == "altitude":
		hud.done_button.visible = true
		$InstructionsPanel.visible = true
		$InstructionsPanel/AltiInstructLabel.visible = true
		$InstructionsPanel/AltButtonLabel.visible = true
		tutorial_active = false
	elif type == "radio":
		hud.done_button.visible = true
		$InstructionsPanel.visible = true
		$InstructionsPanel/RadioInstructLabel.visible = true
		$InstructionsPanel/RadioButtonLabel.visible = true
		tutorial_active = false
	elif type == "camera":
		hud.done_button.visible = true
		$InstructionsPanel.visible = true
		$InstructionsPanel/CameraInstructLabel.visible = true
		$InstructionsPanel/CameraButtonLabel.visible = true
		tutorial_active = false
	elif type == "flight":
		hud.done_button.visible = true
		$InstructionsPanel.visible = true
		$InstructionsPanel/FlightButtonLabel.visible = true
		tutorial_active = false
	else:
		$InstructionsPanel.visible = true
		$InstructionsPanel/FlightButtonLabel.visible = true
		$InstructionsPanel/AltiInstructLabel.visible = true
		$InstructionsPanel/AltButtonLabel.visible = true
		$InstructionsPanel/CameraInstructLabel.visible = true
		$InstructionsPanel/CameraButtonLabel.visible = true
		$InstructionsPanel/RadioInstructLabel.visible = true
		$InstructionsPanel/RadioButtonLabel.visible = true
		tutorial_active = false


func reset_instructions() -> void:
	$InstructionsPanel/AltiInstructLabel.visible = false
	$InstructionsPanel/RadioInstructLabel.visible = false
	$InstructionsPanel/CameraInstructLabel.visible = false
	$InstructionsPanel/FlightButtonLabel.visible = false
	$InstructionsPanel/AltButtonLabel.visible = false
	$InstructionsPanel/RadioButtonLabel.visible = false
	$InstructionsPanel/CameraButtonLabel.visible = false
	tutorial_active = true


func _on_hud_done_pressed() -> void:
	reset_instructions()
	$InstructionsPanel.visible = false
	hud.camera_on = true


func _on_hardware_error_zone_1_area_entered(area: Area2D) -> void:
	init_instructions("radio")


func _on_hardware_error_zone_2_area_entered(area: Area2D) -> void:
	init_instructions("altitude")


func _on_camera_error_zone_1_area_entered(area: Area2D) -> void:
	init_instructions("camera")


func _on_flight_error_zone_1_area_entered(area: Area2D) -> void:
	init_instructions("flight")
