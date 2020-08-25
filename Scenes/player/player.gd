extends KinematicBody2D

#Movement Setup
onready var ray1 = get_node("ground_ray1")
onready var ray2 = get_node("ground_ray2")
onready var ray3 = get_node("ground_ray3")
const GRAVITY = 1500.0
const WALK_SPEED = 125
const JUMP_FORCE = 300
var velocity = Vector2()
var time_start = 0
var groundState = false
onready var streamplayer = get_node("sfx_gunshot")

#Bullet Setup
var bullet = preload("res://Scenes/Bullet/Bullet.tscn")
var rate_of_fire = 0.1
var can_fire = true

#crosshair Setup
var crosshair_generic = load("res://Images/Crosshairs/crosshair_generic.png")


func _ready():
	#Set custom crosshair
	Input.set_custom_mouse_cursor(crosshair_generic)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!is_player_grounded()):
		if(groundState == true):		
			time_start = OS.get_ticks_msec()
			groundState = false
	else:
		groundState = true
		time_start = -1
	
#Ground Check (did a lot to try to fix sticky ground when jumping at edges but never succeeded left as is for now)
func is_player_grounded():
	if(ray1.is_colliding() or ray2.is_colliding()) or ray3.is_colliding():
		return true
	else:
		return false

func destroy_instance(instance):
	destroy_instance(instance)
	pass
	
func _physics_process(delta):	

	velocity.y += delta * GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#Mouse left right animation
	if get_local_mouse_position().x < 0:		        
		$AnimatedSprite.flip_h = true		
	elif get_local_mouse_position().x > 0:				
		$AnimatedSprite.flip_h = false		
	
	#Keyboard left right animation	
	if Input.is_action_pressed("ui_left"):		
		velocity.x = -WALK_SPEED        
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run_right")
		
	elif Input.is_action_pressed("ui_right"):		
		velocity.x =  WALK_SPEED   
		$AnimatedSprite.play("run_right")
		$AnimatedSprite.flip_h = false
		
	elif Input.is_action_pressed("left_mouse"):
		$AnimatedSprite.play("shoot")	

		if(!streamplayer.is_playing()):
			streamplayer.play(0.0)	

		if can_fire == true:
			var bullet_instance = bullet.instance()

			#If for some reason mouse global position can't be found use some default offset
			var offset = Vector2(rand_range(20,30), -10)
			
			#Match bullet offset location depending on character direction
			if get_local_mouse_position().x > 0:
				offset = Vector2(rand_range(20,30), -10)
			elif get_local_mouse_position().x < 0:
				offset = Vector2(rand_range(-20,-30), -10)
			can_fire = false
			
			#Spawn bullet from gun with mouse vector & play some sweet random pitch scaled sound effect
			bullet_instance.position = get_global_position() + offset
			bullet_instance.rotation = get_angle_to(get_global_mouse_position())
			get_parent().add_child(bullet_instance)
			streamplayer.set_pitch_scale(rand_range(1.5,2.0))
			yield(get_tree().create_timer(0.1), "timeout")
			can_fire = true			
		
			#velocity.x = 0		
		
		
	elif Input.is_action_pressed("right_mouse"):
		$AnimatedSprite.play("aim")
		velocity.x = 0
	else:
		$AnimatedSprite.play("idle_right")
		velocity.x = 0
		streamplayer.stop()

	
	#print(OS.get_ticks_msec() - time_start)
	if Input.is_action_just_pressed("ui_up"):
		
		#print(OS.get_ticks_msec() - time_start )
		
		if(!is_player_grounded()):
			if(OS.get_ticks_msec() - time_start  < 18):
				velocity.y =  -JUMP_FORCE   
			elif(time_start == -1):
				velocity.y =  -JUMP_FORCE   
		else: 
			velocity.y =  -JUMP_FORCE   
		
		
	move_and_slide(velocity, Vector2(0, -1))
