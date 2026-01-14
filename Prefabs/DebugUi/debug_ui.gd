extends CanvasLayer

@onready var Player = get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$"Jump Available".text = "jump_available = " + str(Player.jump_available)
	$"Can Double Jump".text = "can_double_jump = " + str(Player.can_double_jump)
	$"Near Ground".text = "near_ground = " + str(Player.near_ground)
	$"Double Jump Unlocked".text = "double_jump_unlocked = " + str(Player.double_jump_unclocked)
	$"Buffer Jump Active".text = "buffer_jump_active = " + str(Player.buffer_jump_active)
	$"Coyote Timer Active".text = "coyote_timer_active = " + str(Player.coyote_timer_active)
	$"After Jump".text = "after_jump = " + str(Player.after_jump)
