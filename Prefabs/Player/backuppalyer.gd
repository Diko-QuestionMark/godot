extends CharacterBody2D

@export var Coyote_Time = 0.15
@onready var coyote_timer = $CoyoJumpTimer
@export var double_jump_unclocked = false


const SPEED = 270.0
const JUMP_VELOCITY = -400.0
var jump_available = true
var can_double_jump = false
var after_jump = true
var near_ground = false

#for camera
var target_offset = 0.0
var offset_the_camera = true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	double_jump_unclocked = GlobalData.double_jump_unclocked
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y <  0:
			$AnimatedSprite2D.play("jump")
		if velocity.y > 0:
			$AnimatedSprite2D.play("fall")
		if jump_available == true:
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time)
	else:
		jump_available = true
		coyote_timer.stop()
		can_double_jump = true
		after_jump = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and near_ground == true:
		if not is_on_floor():
			print("buffer jump")
		$JumpBufferTimer.start()
	if jump_available and not $JumpBufferTimer.is_stopped():
		velocity.y = JUMP_VELOCITY
		jump_available = false
		can_double_jump = true
		print("default jump")
	if (Input.is_action_just_released("jump") or is_on_ceiling()) and velocity.y < 0:
		velocity.y *= 0.5
		after_jump = true

	var direction := Input.get_axis("left", "right")
	if direction:
		#play walking animation
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
		velocity.x = direction * SPEED
	else:
		#play idle animation
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#setting camera offset
	if offset_the_camera == true:
		$Camera2D.offset.x = lerp($Camera2D.offset.x, target_offset, 0.04)
		if direction == 1:
			target_offset = 30.0
		if direction == -1:
			target_offset = -30.0
	else:
		target_offset = 0.0
	
	# setting sprite flip horizontal
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	if direction == -1:
		$AnimatedSprite2D.flip_h = true

	#Double jump
	if can_double_jump and double_jump_unclocked: 
		if Input.is_action_just_pressed("jump") and not is_on_floor() and after_jump and near_ground == false:
			velocity.y = JUMP_VELOCITY
			$DoubleJumpEffect.restart()
			$DoubleJumpEffect.emitting = true
			can_double_jump = false
			print("double jumper!!  ")
	
	move_and_slide()
	#print(offset_the_camera)

func Coyote_Timeout():
	jump_available = false
	can_double_jump = true
	after_jump = true


func _on_buffer_jump_area_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		near_ground = true
		

func _on_buffer_jump_area_body_exited(body: Node2D) -> void:
	if body.name == "TileMap":
		near_ground = false


func _on_no_offset_camera_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		offset_the_camera = false


func _on_no_offset_camera_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		offset_the_camera = true
