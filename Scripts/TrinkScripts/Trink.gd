extends Node2D
class_name Trink

@onready var label = $Label
var ray_cast_2d : RayCast2D

var right_slot
var left_slot
var down_slot

var sides = {
	0: null, # This is the right side
	1: null, # This is the left side
	2: null # This is the base, or bottom side
}

var no_spawn_chance = 50
var no_spawn_growth_factor = 1.5 # 20%
var rarity : float
var size = 200
var small_trink_size = 200
var parent_trink = false
var can_trink = true




func _ready():
	right_slot = get_node_or_null("RightSlot")
	left_slot = get_node_or_null("LeftSlot")
	down_slot = get_node_or_null("DownSlot")
	size = small_trink_size
	for side in sides:
		if !can_trink: continue
		## Check if it is possible to spawn a new trink
		if parent_trink and side == 2: continue # If a child trink, don't spawn anything directly below
		if sides[side] != null: continue # Don't replace an existing trink
		print(get_slot(side).has_overlapping_bodies())
		if get_slot(side).has_overlapping_bodies(): continue #skip this side if it's colliding
		#if await check_for_obstacles(): continue
		print("we all good for spawning trinks chief")
		
		## Let's find a new trink
		#print("looking for trinks...")
		var new_trink_type = choose_new_trink(no_spawn_chance)
		if new_trink_type == null: continue # No new trinks on this side
		#print('new trink type: ', new_trink_type)
		await get_tree().create_timer(.25).timeout
		
		## Load the trink
		var new_trink = load(new_trink_type).instantiate()
		if new_trink_type != "res://Scenes/Trinks/BlankTrink.tscn":
			new_trink.can_trink = false # if it's a hazard, it shouldn't spawn anything else after it
		else:
			new_trink.no_spawn_chance = no_spawn_chance * no_spawn_growth_factor
		# update the spawn chance
		new_trink.sides[get_sibling_side(side)] = self 
		# I set myself as one of the existing siblings for the next trink
		print('new trink type: ', new_trink, " new spawn chance: ", new_trink.no_spawn_chance)
		await get_tree().create_timer(.25).timeout
		
		## Position the Trink
		#var new_transform = get_new_transform(side)
		#new_trink.position = new_transform[0]
		#new_trink.rotation = deg_to_rad(new_transform[1])
		#print('new trink transform: ', new_trink.position, " ", new_trink.rotation)
		await get_tree().create_timer(.25).timeout
		
		## Update variables
		label.text = (str(Global.index))
		Global.index += 1
		sides[side] = new_trink
		new_trink.parent_trink = true
		get_slot(side).add_child(new_trink)
		#print("new trink! ", new_trink)
		await get_tree().create_timer(.25).timeout
		

func choose_new_trink(chance):
	var rng = RandomNumberGenerator.new()
	var num = rng.randi_range(1, Global.total_spawn_chance + chance)
	#print("chance is: ", chance, " and I got: ", num)
	for path in Global.all_trinks:
		num -= Global.all_trinks[path]
		if num <= 0:
			#print('im trinkin ', path)
			return path
	return null


#func get_new_transform(side):
	##var offset = size /2 * sqrt(3)
	##print("current offset: ", offset)
	##var new_transform
	#var new_position
	#var new_rotation
	#if side == 0:
		#print("right")
		#new_position = get_parent().position + Vector2(size, (-size/2 - 1))
		#new_rotation = get_parent().rotation + 60.0
	#elif side == 1:
		#print("left")
		#new_position = get_parent().position + Vector2(-size, (-size/2 - 1))
		#new_rotation = get_parent().rotation - 60.0
	#elif side >= 2: 
		#print("down")
		#new_position = get_parent().position + Vector2(0,size+1)
		#new_rotation = get_parent().rotation + 180.0
	##new_transform = Transform2D(new_rotation, new_position)
	#print(new_rotation, ' new rotation ', new_position, ' new position ')
	#return [new_position,new_rotation]


func get_slot(side):
	if side == 0:
		return right_slot
	elif side == 1:
		return left_slot
	elif side == 2:
		return down_slot

func get_sibling_side(side):
	if side == 0:
		return 1
	elif side == 1:
		return 0
	elif side == 2:
		return 2
	
