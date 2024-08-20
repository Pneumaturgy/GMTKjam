extends CharacterBody2D
class_name Player

@export var joypad_dead_zone = 0.1
@export var speed = 1000
@export var rotation_speed = 120
@onready var right_slot = $RightSlot
@onready var left_slot = $LeftSlot
@onready var down_slot = $DownSlot

var target_rotation = 0  # Variable to store the target rotation angle


func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var input_rotate = Input.get_axis("rotate_counterclockwise", "rotate_clockwise")
	#rotation += input_rotate * rotation_speed
	velocity = input_direction * speed



func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
	if event is InputEventMouseButton and event.pressed:
		if Input.is_action_just_pressed("rotate_clockwise"):
			target_rotation += 60
		if Input.is_action_just_pressed("rotate_counterclockwise"):
			target_rotation -= 60
		target_rotation = wrapf(target_rotation, 0, 360) # Wrap the rotation between 0 and 360 degrees

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	var current_rotation = wrapf(rotation_degrees, 0, 360)
	var shortest_angle = wrapf(target_rotation - current_rotation, -180, 180)
	var rotation_step = sign(shortest_angle) * min(abs(shortest_angle), rotation_speed * delta)
	rotation_degrees += rotation_step
	#if rotation_degrees != target_rotation:
		#var difference = target_rotation - rotation_degrees
		#var step = rotation_speed * delta
		#if abs(difference) <= step:
			#rotation_degrees = target_rotation
		#else:
			#rotation_degrees += sign(difference) * step

func _on_right_slot_area_entered(area):
	new_child(area,right_slot)
	right_slot.set_deferred("monitoring", false)


func _on_left_slot_area_entered(area):
	new_child(area,left_slot)
	left_slot.set_deferred("monitoring", false)


func _on_down_slot_area_entered(area):
	new_child(area,down_slot)
	down_slot.set_deferred("monitoring", false)



func new_child(area,slot):
	var target_trink = area.get_parent().get_parent().get_parent()
	if target_trink == get_tree().root:
		#print("geetting child")
		target_trink = area.get_parent()
	#else:
		#var new_child = area.get_parent().get_parent()
	#target_trink.get_children()
	#for child in target_trink.get_children():
		#queue_free()
	#var new_child = target_trink.remove_child(area.get_parent().get_parent())
	#var new_trink = area.get_parent()
	#var new_trink_file_path = new_trink
	#print("new_child: ", new_child)
	if target_trink != self:
		target_trink.call_deferred("reparent",slot)
		target_trink.global_position = slot.global_position
		target_trink.global_rotation = slot.global_rotation
		
	#call_deferred(target_trink.reparent())
	print(target_trink)
	#new_child.queue_free()
	#add_child(new_child)
	#slot.add_child(new_trink)
	#new_child.position = slot.position
