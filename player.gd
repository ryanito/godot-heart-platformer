extends CharacterBody2D


const SPEED = 100.0
const ACCELERATION = 600.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D


func _physics_process(delta):
	add_gravity(delta)
	handle_jump()
	var direction = Input.get_axis("ui_left", "ui_right")
	handle_movement(direction, delta)
	update_animations(direction)
	move_and_slide()


func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
		
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	else:
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
