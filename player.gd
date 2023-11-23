extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position


func _physics_process(delta):
	add_gravity(delta)
	handle_jump()
	handle_wall_jump()
	var direction = Input.get_axis("move_left", "move_right")
	handle_movement(direction, delta)
	update_animations(direction)
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()


func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta
		
		
func handle_jump():
	if is_on_floor():
		air_jump = true
	
	if is_on_floor() or coyote_jump_timer.time_left > 0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movement_data.jump_velocity
	
	elif not is_on_floor():
		var short_jump = movement_data.jump_velocity / 2
		
		if Input.is_action_just_released("jump") and velocity.y < short_jump:
			velocity.y = short_jump
			
		if Input.is_action_just_pressed("jump") and air_jump:
			velocity.y = movement_data.jump_velocity
			air_jump = false
			
			
func handle_wall_jump():
	if not is_on_wall_only():
		return
		
	var wall_normal = get_wall_normal()

	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
		
	air_jump = true

			
			
func handle_movement(direction, delta):
	if direction:
		apply_acceleration(direction, delta)
	else:
		apply_friction(direction, delta)
		apply_air_resistance(direction, delta)
	
	
func apply_acceleration(direction, delta):
	if direction == 0:
		return
		
	if is_on_floor():
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.air_acceleration * delta)
	
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


func _on_hazard_detector_area_entered(area):
	global_position = starting_position
	animated_sprite_2d.flip_h = false
