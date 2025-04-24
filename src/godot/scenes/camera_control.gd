extends Area2D

@export var zone_num: int
@export var type: int
@onready var hud = get_parent().get_parent().find_child("HUD")

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	if type == 1:
		hud.camera_on = true
		print("Camera On")


func _on_area_exited(area: Area2D) -> void:
	if type == 1:
		hud.camera_on = false
		print("Camera Off")
