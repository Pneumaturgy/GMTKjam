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

var belongs_to_player = false


func _ready():
	add_to_group("trinks")
	Global.new_trink.emit()
	right_slot = get_node_or_null("RightSlot")
	left_slot = get_node_or_null("LeftSlot")
	down_slot = get_node_or_null("DownSlot")
	size = small_trink_size
	for side in sides:
		## Check if it is possible to spawn a new trink
		if !can_trink: continue
		if parent_trink and side == 2: 
			down_slot.queue_free()
			continue # If a child trink, don't spawn anything directly below
		if sides[side] != null: 
			#get_slot(side).monitoring = false
			#get_slot(side).monitorable = false
			continue # Don't replace an existing trink
		if get_slot(side).has_overlapping_bodies(): continue #skip this side if it's colliding

		
		## Let's find a new trink
		var new_trink_type = choose_new_trink(no_spawn_chance)
		if new_trink_type == null: continue # No new trinks on this side

		
		## Load the trink
		var new_trink = load(new_trink_type).instantiate()
		if new_trink_type != "res://Scenes/Trinks/BlankTrink.tscn":
			new_trink.can_trink = false # if it's a hazard, it shouldn't spawn anything else after it
		else:
			#get_slot(side).monitoring = false
			#get_slot(side).monitorable = false
			new_trink.no_spawn_chance = no_spawn_chance * no_spawn_growth_factor
		# update the spawn chance
		new_trink.sides[get_sibling_side(side)] = self 

		## Update variables
		label.text = (str(Global.index))
		Global.index += 1
		sides[side] = new_trink
		new_trink.parent_trink = true
		get_slot(side).add_child(new_trink)


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
	
