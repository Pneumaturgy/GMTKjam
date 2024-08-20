extends CharacterBody2D
class_name Player

@export var joypad_dead_zone = 0.1
@export var speed = 1000
@export var rotation_speed = 120
@export var trink_move_speed = 10.0  # Speed for trink movement
@export var trink_rotation_speed = 5.0  # Speed for trink rotation

@onready var right_slot = $RightSlot
@onready var left_slot = $LeftSlot
@onready var down_slot = $DownSlot
var belongs_to_player = true
var target_rotation = 0  # Variable to store the target rotation angle

#func _ready():
	#Global.connect_to.connect(new_child)


func get_input():
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
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
	
	
	for slot in [right_slot, left_slot, down_slot]:
		if slot and slot.get_child_count() > 1:
			var trink = slot.get_child(1)
			trink.global_position = trink.global_position.lerp(slot.global_position, trink_move_speed * delta)
			trink.global_rotation = lerp_angle(trink.global_rotation, slot.global_rotation, trink_rotation_speed * delta)
		else:
			slot.set_deferred("monitoring",true)

func _on_right_slot_area_entered(area):
	new_child(area,right_slot)


func _on_left_slot_area_entered(area):
	new_child(area,left_slot)


func _on_down_slot_area_entered(area):
	new_child(area,down_slot)



func new_child(area,slot):
	var target_trink
	#print("we got: ",area)
	if target_trink == null:
		target_trink = area.get_parent()
		#print(target_trink, " is a base trink")
		if target_trink is not Trink:
			print('Not Trink')
	#if area.get_children().size()>=2:
		#target_trink = area.get_child(1)
		#print(target_trink, " is a normal trink")
	
	
	#if target_trink is CollisionShape2D:
		#target_trink = area.get_parent().get_parent()
		#print(target_trink, " is a hazard trink")
	#if target_trink is Area2D:
		#target_trink = area.get_parent()
		#print(target_trink, " is a ? trink")
	#if target_trink == Node2D:
	#print(target_trink)
	#if target_trink != Player:
		
	if "down_slot" in target_trink and target_trink.down_slot != null:
		target_trink.down_slot.queue_free()
	if !target_trink is CollisionShape2D:
		target_trink.call_deferred("reparent",slot)
		if "belongs_to_player" in target_trink:
			target_trink.belongs_to_player = true
		if target_trink.right_slot != null:
			target_trink.right_slot.set_deferred("monitoring",false)
		if target_trink.left_slot != null:
			target_trink.left_slot.set_deferred("monitoring",false)
		slot.set_deferred("monitoring",false)
		#if "down_slot" in target_trink:
			#target_trink.down_slot.set_deferred("monitoring",false)
		#if target_trink.right_slot != null:
			#target_trink.right_slot.set_deferred("monitoring",false)
		#if target_trink.left_slot != null:
			#target_trink.left_slot.set_deferred("monitoring",false)
		#if target_trink.down_slot != null:
			#target_trink.down_slot.set_deferred("monitoring",false)
		Global.connected.emit()
#print(target_trink)
