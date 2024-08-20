extends Node2D

const BLANK_TRINK = preload("res://Scenes/Trinks/BlankTrink.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connected.connect(spawn_trink)



func spawn_trink():
	var new_trink = BLANK_TRINK.instantiate()
	call_deferred("add_child",new_trink)
	new_trink.position.y = randi_range(-2048,2048)
	new_trink.position.x = randi_range(-2048,2048)
	#print("spawning new trink: ", new_trink.position.y, new_trink.position.x)
