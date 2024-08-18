extends Node2D
class_name Trink

var rarity : float
var spawn_chance = 10.0
var size : int
var sides = [
	0.5,
	0.5,
	0.5
]
var siblings = {}

func _ready():
	spawn_chance -= 5
	var index = 0
	for side in sides:
		index += 1
		if can_spawn(side):
			print('spawning ', index)
			var trink_to_spawn = choose_new_trink()
			#var instantiated_trink = trink_to_spawn.instantiate()
			var instantiated_trink = load(trink_to_spawn).instantiate()
			add_child(instantiated_trink)
			instantiated_trink.transform = get_new_transform(index)
			siblings[side] = instantiated_trink


func choose_new_trink():
	var rng = RandomNumberGenerator.new()
	var num = rng.randi_range(1, Global.total_spawn_chance)
	for path in Global.all_trinks:
		num -= Global.all_trinks[path]
		if num <= 0:
			#var trink = load(path).instantiate()
			#print("Chosen Trink: ", path)
			return path
	
	
	#var rng = RandomNumberGenerator.new()
	#var num = rng.randi_range(1, Global.total_spawn_chance)
	##var chosen_trink = Global.all_trinks.keys()[0]
	#for trink in Global.all_trinks:
		#num -= Global.all_trinks[trink]
		#if num <= 0:
			#print("Chosen Trink: ", trink)
			#return trink 
			
	#print("Chosen Trink: ", trink)
	#return trink
	

func get_new_transform(side):
	var new_transform
	#print(side)
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


func can_spawn(side):
	print('side:', side)
	var rng = RandomNumberGenerator.new()
	var num = rng.randf_range(0, 1)
	print(num)
	if num >= side:
		return true
	else:
		return false
