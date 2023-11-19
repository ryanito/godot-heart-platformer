extends CharacterBody2D


const SPEED = 100.0
const ACCELERATION = 600.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0

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


func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
		
func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	
	if not is_on_floor():
		var short_jump = JUMP_VELOCITY / 2
		
		if Input.is_action_just_released("ui_accept") and velocity.y < short_jump:
			velocity.y = short_jump
			
			
func handle_movement(direction, delta):
	if direction:
		apply_acceleration(direction, delta)
	else:
		apply_friction(delta)
	
	
func apply_acceleration(direction, delta):
	velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)

	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	
func update_animations(direction):
	if direction:
		animated_sprite_2d.flip_h = direction < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
		
	if not is_on_floor():
		animated_sprite_2d.play("jump")
