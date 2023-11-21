extends CharacterBody2D

@export var movement_data : PlayerMovementData

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer


func _physics_process(delta):
	add_gravity(delta)
	handle_jump()
	var direction = Input.get_axis("ui_left", "ui_right")
	handle_movement(direction, delta)
	update_animations(direction)
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()
		
	if Input.is_action_just_pressed("ui_up"):
		movement_data = load("res://FastMovementData.tres")
	if Input.is_action_just_pressed("ui_down"):
		movement_data = load("res://SlowMovementData.tres")


func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta
		
		
func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = movement_data.jump_velocity
	
	if not is_on_floor():
		var short_jump = movement_data.jump_velocity / 2
		
		if Input.is_action_just_released("ui_accept") and velocity.y < short_jump:
			velocity.y = short_jump
			
			
func handle_movement(direction, delta):
	if direction:
		apply_acceleration(direction, delta)
	else:
		apply_friction(direction, delta)
		apply_air_resistance(direction, delta)
	
	
func apply_acceleration(direction, delta):
	velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.acceleration * delta)

	
func apply_friction(direction, delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
		
		
func apply_air_resistance(direction, delta):
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
	
	
func update_animations(direction):
	if direction:
		animated_sprite_2d.flip_h = direction < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
		animated_sprite_2d.play("jump")
