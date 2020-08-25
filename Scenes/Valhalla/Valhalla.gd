extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("keyboard_r"):
		get_tree().change_scene("res://Scenes/Valhalla/Valhalla.tscn")
	
	if Input.is_action_pressed("keyboard_escape"):
		get_tree().quit()
	
