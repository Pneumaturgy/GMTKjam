extends Node2D

const BLANK_TRINK = preload("res://Scenes/Trinks/BlankTrink.tscn")
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connected.connect(spawn_trink)



func spawn_trink():
	var new_trink = BLANK_TRINK.instantiate()
	call_deferred("add_child",new_trink)
	var new_trink_py = player.global_position.y + 500
	var new_trink_ny = player.global_position.y - 500
	var new_trink_px = player.global_position.x + 500
	var new_trink_nx = player.global_position.x - 500
	var y_positive_or_negative = randi_range(0, 1)
	var x_positive_or_negative = randi_range(0, 1)
	if y_positive_or_negative == 0:
		new_trink.position.y = randi_range(-2048,new_trink_ny)
	else:
		new_trink.position.y = randi_range(new_trink_py,2048)
	if x_positive_or_negative == 0:
		new_trink.position.x = randi_range(-2048,new_trink_nx)
	else:
		new_trink.position.x = randi_range(new_trink_px,2048)
	#var new_trink_position_y = Vector2(new_trink_py,)
	#new_trink.position.y = randi_range(-2048,2048)
	#new_trink.position.x = randi_range(-2048,2048)
	#print("spawning new trink: ", new_trink.position.y, new_trink.position.x)
