extends CharacterBody2D

@export var speed := 250.0
@export var jump_force := 450.0
@export var gravity := 1200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var facing := "right"
var was_running := false

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		play_jump()

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * speed
		facing = "right" if direction > 0 else "left"
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation(direction)

func update_animation(direction: float):
	# In air
	if not is_on_floor():
		if velocity.y < 0:
			play_jump()
		else:
			play_fall()
		return

	# Running
	if direction != 0:
		was_running = true
		play_run()
		return

	# Run → Idle
	if was_running:
		play_run_to_idle()
		was_running = false
		return

	# Idle
	play_idle()

func play_idle():
	sprite.play("idle_" + facing)

func play_run():
	sprite.play("run_" + facing)

func play_run_to_idle():
	var anim := "run_to_idle_" + facing
	if sprite.sprite_frames.has_animation(anim):
		sprite.play(anim)
	else:
		play_idle()

func play_jump():
	sprite.play("jump_" + facing)

func play_fall():
	var anim := "fall_" + facing
	if sprite.sprite_frames.has_animation(anim):
		sprite.play(anim)
	else:
		play_jump()
