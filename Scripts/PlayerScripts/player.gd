extends CharacterBody2D
class_name Player

@export var joypad_dead_zone = 0.1
@export var speed = 1000
@export var rotation_speed = 0.05

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_rotate = Input.get_axis("rotate_counterclockwise", "rotate_clockwise")
	rotation += input_rotate * rotation_speed
	velocity = input_direction * speed


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()


func _physics_process(_delta):
	get_input()
	move_and_slide()
