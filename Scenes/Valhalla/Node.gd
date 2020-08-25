extends Node


#Cross hair on mouse
var crosshair_generic = load("res://Images/Crosshairs/crosshair_generic.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(crosshair_generic)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
