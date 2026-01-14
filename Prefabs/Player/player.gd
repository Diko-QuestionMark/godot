extends CharacterBody2D

@onready var coyote_timer = $CoyoJumpTimer #persiapan node coyote timer
@export var Coyote_Time = 0.15 #Lama waktu coyote
@export var double_jump_unclocked = false #Apakah player sudah membuka kemampuan double jump?

#pergerakan karakter
const SPEED = 250.0 #Kecepatan karakter
const JUMP_VELOCITY = -400.0 #Ketinggian lompat karakter
var jump_available = true #Apakah karakter bisa lompat
var can_double_jump = false #Apakah karakter bisa double jump
var after_jump = true #Apakah karakter sudah lompat
var near_ground = false # Apakah karakter hampir menyentuh tanah
var ground_count = 0

#untuk kamera
var target_offset = 0.0 #Target pergeseran offset kamera
var offset_the_camera = true #Apakah offset kamera diaktifkan

#debug
var buffer_jump_active
var coyote_timer_active

#Jalan tiap frame
func _physics_process(delta: float) -> void:
	#Ngecek apakah udah dapat double jump?
	#double_jump_unclocked = GlobalData.double_jump_unclocked
	
	
	#Ketika tidak menyentuh lantai
	if not is_on_floor():
		velocity += get_gravity() * delta #Gravitasi
		if velocity.y <  0:
			$AnimatedSprite2D.play("jump") #Animasi lompat jika karakter naik ke atas
		if velocity.y > 0: 
			$AnimatedSprite2D.play("fall")#Animasi turun jika karakter sedang terjatuh
			
		#jika jump_available true,  maka mulai perhitungan waktu coyote
		if jump_available == true:
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time) #Jalankan coyote timer dengan waktu bedasarkan variabel
	#Jika menyentuh lantai
	else:
		jump_available = true #Lompat tersedia aktif
		coyote_timer.stop() #coyote timer diberhentikan
		can_double_jump = true #bisa double jump jadi aktif
		after_jump = false # setelah loncat, salah
	
	
	#Jika menakan tombol lompat dan dekat dengan tanah 
	if Input.is_action_just_pressed("jump") and near_ground == true: 
		$JumpBufferTimer.start() #Memulai waktu jump buffer
		if not is_on_floor(): #Saat tidak menyentuh tanah
			print("buffer jump") #Debug perpose
	
	#Urusan lompat dan juga buffernya
	#Ketika lompat tersedia dan jump buffer di kondisi menyala
	if jump_available and (not $JumpBufferTimer.is_stopped() or Input.is_action_just_pressed("jump") and not $CoyoJumpTimer.is_stopped()): 
		velocity.y = JUMP_VELOCITY #Melakukan lompatan+++
		jump_available = false #Lompat tidak tersedia
		can_double_jump = true #Double jump tersedia
		coyote_timer.stop() #Ngetest aja
		print("default jump") # Debug perpose
		if not $CoyoJumpTimer.is_stopped():
			print("coyote jump")
	
	#Variabel jump intinya
	if Input.is_action_just_released("jump") or is_on_ceiling():
		after_jump = true #Sudah lompat aktif
		if velocity.y < 0: #Saat karakter lagi naik
			velocity.y *= 0.5 #Velocity dibagi 2
	
	#Double jump
	if can_double_jump and double_jump_unclocked: #Jika bisa double jump dan kemampuan double jump sudah terbuka
		#Jika menekan tombol lompat dan saat masih di udara dan setelah lompat aktif dan tidak dekat dengan tilemap
		if Input.is_action_just_pressed("jump") and not is_on_floor() and after_jump and near_ground == false: 
			velocity.y = JUMP_VELOCITY #melakukan lompatan +++
			$DoubleJumpEffect.restart() #mempersiapkan efek partikel doublejump
			$DoubleJumpEffect.emitting = true #mengeluarkan efek partikel
			can_double_jump = false #double jump dinonaktifkan
			print("double jumper!!  ") #debug perpuse
	
	#Near Ground
	if ground_count > 0: #Menghitung jumlah body yang ada di area near ground
		near_ground = true #Jika ada maka true
	else:
		near_ground = false #Jika tidak ada maka false
	
	#Gak peduli, jangan di senggol lagi.
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
		$Camera2D.offset.x = lerp($Camera2D.offset.x, target_offset, 0.08)
	
	# setting sprite flip horizontal
	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	
	move_and_slide()
	
	#debug
	buffer_jump_active = not $JumpBufferTimer.is_stopped()
	coyote_timer_active = not $CoyoJumpTimer.is_stopped()
	#print(offset_the_camera)






#Jika waktu coyote selesai
func Coyote_Timeout():
	jump_available = false #lompat jadi tidak tersedia
	can_double_jump = true #double jump tersedia
	after_jump = true # Statusnya dianggap sudah melompat


#Mengecek apakah zona near ground karakter menyentuh tile?
func _on_buffer_jump_area_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		ground_count += 1
	if body.is_in_group("Mplatform"):
		ground_count += 1
func _on_buffer_jump_area_body_exited(body: Node2D) -> void:
	if body.name == "TileMap":
		ground_count -= 1
	if body.is_in_group("Mplatform"):
		ground_count -= 1
	
#Mengecek apakah player di dalam zona offset kamera?
func _on_no_offset_camera_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		offset_the_camera = false
func _on_no_offset_camera_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		offset_the_camera = true
