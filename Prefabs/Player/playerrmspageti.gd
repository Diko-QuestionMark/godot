extends CharacterBody2D

@export var Coyote_Time = 1
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


func _physics_process(delta: float) -> void:
	#Ngecek apakah udah dapat double jump?
	double_jump_unclocked = GlobalData.double_jump_unclocked
	
	#Ketika tidak menyentuh lantai
	if not is_on_floor():
		velocity += get_gravity() * delta #Gravitasi
		if velocity.y <  0:
			$AnimatedSprite2D.play("jump") #Animasi lompat jika karakter naik ke atas
		if velocity.y > 0: 
			$AnimatedSprite2D.play("fall")#Animasi turun jika karakter sedang terjatuh
			
		#jika jump_available true,  coyote timer itu lagi enggak jalan
		if jump_available == true:
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time) #Jalankan coyote timer dengan waktu bedasarkan variabel
	
	#Jika menyentuh lantai
	else:
		jump_available = true #Lompat tersedia aktif
		coyote_timer.stop() #coyote timer diberhentikan
		can_double_jump = true #bisa double jump jadi aktif
		after_jump = false # setelah loncat, salah
