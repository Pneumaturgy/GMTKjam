extends Node2D
class_name Trink


var no_spawn_chance = 50
var no_spawn_growth_factor = 1.5 # 20%
var rarity : float
var size : int


var siblings = {
	0: null, # This is the right side
	1: null, # This is the left side
	2: null # This is the base, or bottom side
}


func _ready():
	for father_side in siblings:
		if siblings[father_side] != null: continue # Don't replace the parent trink
		var new_trink_type = choose_new_trink(no_spawn_chance)
		if new_trink_type == null: continue # No new trinks on this side
		var new_trink = load(new_trink_type).instantiate()
		new_trink.no_spawn_chance = no_spawn_chance * no_spawn_growth_factor
		# TODO Need to SET on the new_trink.siblings the father on the correct side
		# So, for instance: new_trink.siblings[get_sibling_side(father_side)] = self
		# TODO Need to fix the get new transform function (don't hardcode but calculate the coordinates)
		new_trink.transform = get_new_transform(father_side)
		add_child(new_trink)
		siblings[father_side] = new_trink


func choose_new_trink(no_spawn_chance):
	var rng = RandomNumberGenerator.new()
	var num = rng.randi_range(1, Global.total_spawn_chance + no_spawn_chance)
	for path in Global.all_trinks:
		num -= Global.all_trinks[path]
		if num <= 0:
			return path
	return null


func get_new_transform(side):
	var new_transform
	if side == 0:
		var new_position = Vector2(11.75,-7.5)
		var new_rotation = self.rotation + 60.0
		new_transform = Transform2D(new_rotation, new_position)
	elif side == 1:
		var new_position = Vector2(-11.75,-7.5)
		var new_rotation = self.rotation + 60.0
		new_transform = Transform2D(new_rotation, new_position)
	elif side >= 2: 
		var new_position = Vector2(0,11.75)
		var new_rotation = self.rotation + 60.0
		new_transform = Transform2D(new_rotation, new_position)
	return new_transform
