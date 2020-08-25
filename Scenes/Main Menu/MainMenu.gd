extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim_player = get_node("AnimationPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("main_menu_spr")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("keyboard_escape"):
		get_tree().quit()
	pass
