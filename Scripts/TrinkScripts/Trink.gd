extends Node2D
class_name Trink

var rarity : float
var spawn_chance = 50
var size : int
var sides = {
	side_1 = 0.5,
	side_2 = 0.5,
	side_3 = 0.5
}
# Called when the node enters the scene tree for the first time.
func _ready():
	for side in sides:
		if can_spawn(side):
			var rng = RandomNumberGenerator.new()
			var num = rng.randi_range(0, 100)
			var trink_to_spawn
			for trink in Global.all_trinks:
				if num <= Global.all_trinks[trink.spawn_chance]:
					trink_to_spawn = Global.all_trinks[trink]
				else:
					trink += 1
			trink_to_spawn.instantiate()
			add_child(trink_to_spawn)
			self.transform
			trink_to_spawn.transform = get_side_position(side)
			sides[side] = trink_to_spawn
	# for each side
	# should I spawn? coin toss
	# if yes
		# rng 100
		# if number is <= rarity of each
			# new trink = this selected trink
			# instantiate
			# add child
			# set position = side 1
			# set rotation = side 2
		# sides += 1
	# else:
		# sides += 1

func get_side_position(side):
	var new_transform
	if side == 0:
		var position = Vector2(11.75,-7.5)
		var rotation = self.rotation + 60.0
		new_transform = Transform2D(rotation, position)
	elif side == 1:
		var position = Vector2(-11.75,-7.5)
		var rotation = self.rotation + 60.0
		new_transform = Transform2D(rotation, position)
	elif side == 2: 
		var position = Vector2(0,11.75)
		var rotation = self.rotation + 60.0
		new_transform = Transform2D(rotation, position)
	return new_transform


func can_spawn(side):
	var rng = RandomNumberGenerator.new()
	var num = rng.randi_range(0, 1)
	if num >= sides[side]:
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
