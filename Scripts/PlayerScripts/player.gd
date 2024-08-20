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

var target_rotation = 0  # Variable to store the target rotation angle


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
		if slot.get_child_count() > 1:
			var trink = slot.get_child(1)
			trink.global_position = trink.global_position.lerp(slot.global_position, trink_move_speed * delta)
			trink.global_rotation = lerp_angle(trink.global_rotation, slot.global_rotation, trink_rotation_speed * delta)


func _on_right_slot_area_entered(area):
	new_child(area,right_slot)


func _on_left_slot_area_entered(area):
	new_child(area,left_slot)


func _on_down_slot_area_entered(area):
	new_child(area,down_slot)



func new_child(area,slot):
	slot.set_deferred("monitoring", false)
	var target_trink = area.get_parent()
	
	if target_trink == get_tree().root:
		target_trink = area
		target_trink.call_deferred("reparent",slot)
		target_trink.right_slot.set_deferred("monitoring", false)
		target_trink.left_slot.set_deferred("monitoring", false)
		target_trink.down_slot.set_deferred("monitoring", false)
	else:
		var parent_trink = target_trink.get_parent().get_parent()
		print("parent: ", parent_trink)
		if parent_trink == get_tree().root:
			parent_trink = target_trink
		if parent_trink and parent_trink != get_node("Player"):
			parent_trink.remove_child(target_trink)
			target_trink.call_deferred("reparent",slot)
			target_trink.right_slot.set_deferred("monitoring", false)
			target_trink.left_slot.set_deferred("monitoring", false)
			target_trink.down_slot.set_deferred("monitoring", false)
			parent_trink.right_slot.set_deferred("monitoring", false)
			parent_trink.left_slot.set_deferred("monitoring", false)
			parent_trink.down_slot.set_deferred("monitoring", false)
			#slot.set_deferred("monitoring", false)
		
		await get_tree().create_timer(.25).timeout
		slot.set_deferred("monitoring", true)

	#var target_trink = area.get_parent().get_parent().get_parent()
	#if target_trink == get_tree().root:
		#target_trink = area.get_parent()
	#print("Target trink: ", target_trink)
	#
	#if target_trink != self:
		#target_trink.label.text = "hello"
		  #
		## Disconnect the target trink from its family
		#var parent = target_trink.get_parent()
		#print("Target parent: ", parent)
		#if parent and parent != get_tree().root:
			#parent.remove_child(target_trink)
		#
		## Remove children from the target trink's slots
		#for child_slot in [target_trink.right_slot, target_trink.left_slot, target_trink.down_slot]:
			#while child_slot.get_child_count() > 0:
				#var child = child_slot.get_child(0)
				#child_slot.remove_child(child)
				## Optionally, you can add the child back to the scene tree if needed
				##get_tree().root.add_child(child)
		#if slot.get_parent():
			#print("Reparenting trink to slot: ", slot)
			#slot.add_child(target_trink)
			##target_trink.global_position = slot.global_position
			##target_trink.global_rotation = slot.global_rotation
		#else:
			#print("Error: Slot has no parent, cannot reparent trink")
	##if target_trink != self:
		##target_trink.label.text = "hello"
		##target_trink.right_slot.call_deferred("remove_child",get_child(0))
		##target_trink.left_slot.call_deferred("remove_child",get_child(0))
		##target_trink.down_slot.call_deferred("remove_child",get_child(0))
		#
		## Reparent the isolated trink to the new slot
		##target_trink.call_deferred("reparent",slot)
		#
		## Disable monitoring on the trink's slots
		#target_trink.right_slot.set_deferred("monitoring", false)
		#target_trink.left_slot.set_deferred("monitoring", false)
		#target_trink.down_slot.set_deferred("monitoring", false)


#func _on_right_slot_area_exited(area):
	#right_slot.set_deferred("monitoring", true)
#
#
#func _on_left_slot_area_exited(area):
	#left_slot.set_deferred("monitoring", true)
#
#
#func _on_down_slot_area_exited(area):
	#down_slot.set_deferred("monitoring", true)
