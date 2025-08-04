extends CharacterBody2D

@onready var player_anim_controller: AnimationController = $AnimatedSprite2D
@export var move_speed: float = 3200
@export var footstep_cooldown: float = 0.4
var footstep_timer: float = 0.0

func _physics_process(delta: float) -> void:
	footstep_timer += delta
	move_player(delta)

func move_player(delta: float) -> void:
	# Get input from the player
	var input_x = Input.get_axis("move_left", "move_right")
	var input_y = Input.get_axis("move_up", "move_down")   
		
	var movement_vector = Vector2(input_x, input_y).normalized()  
	velocity = movement_vector * move_speed * delta
	update_animations(movement_vector) 
	move_and_slide()

func update_animations(movement_vector: Vector2) -> void:
	if footstep_timer >= footstep_cooldown:
		if not $AudioStreamPlayer.playing:
			if movement_vector.length() > 0:
				$AudioStreamPlayer.play()
		footstep_timer = 0.0 # Reset the timer
	# Check for the idle state first. If the character is not moving,
	# play the idle animation and exit the function.
	if movement_vector.length() == 0:
		if player_anim_controller.animation != "idle":
			player_anim_controller.play("idle")
		return # <-- This is the key change!

	# Only if the character is moving do we get to this part of the code.
	if abs(movement_vector.x) > abs(movement_vector.y):
		# Moving horizontally
		if movement_vector.x > 0:
			if player_anim_controller.animation != "right":
				player_anim_controller.play("right")
		else:
			if player_anim_controller.animation != "left":
				player_anim_controller.play("left")
	else:
		# Moving vertically
		if movement_vector.y > 0:
			if player_anim_controller.animation != "down":
				player_anim_controller.play("down")
		else:
			if player_anim_controller.animation != "up":
				player_anim_controller.play("up")
