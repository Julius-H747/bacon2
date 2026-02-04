extends CharacterBody2D

@export var speed: float = 200.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction := Vector2.DOWN
var was_moving := false

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * speed
	move_and_slide()

	update_animation(input_vector)

func update_animation(input_vector: Vector2):
	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		was_moving = true
		play_run_animation(input_vector)
	else:
		if was_moving:
			play_run_to_idle_animation()
			was_moving = false
		else:
			play_idle_animation()

func play_run_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			sprite.play("run_right")
		else:
			sprite.play("run_left")
	else:
		if dir.y > 0:
			sprite.play("run_down")
		else:
			sprite.play("run_up")

func play_idle_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			sprite.play("idle_right")
		else:
			sprite.play("idle_left")
	else:
		if last_direction.y > 0:
			sprite.play("idle_down")
		else:
			sprite.play("idle_up")

func play_run_to_idle_animation():
	var anim_name := ""

	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			anim_name = "run_to_idle_right"
		else:
			anim_name = "run_to_idle_left"
	else:
		if last_direction.y > 0:
			anim_name = "run_to_idle_down"
		else:
			anim_name = "run_to_idle_up"

	if sprite.sprite_frames.has_animation(anim_name):
		sprite.play(anim_name)
	else:
		play_idle_animation()
