extends Node2D
class_name Trink

@onready var label = $Label
var ray_cast_2d : RayCast2D

var no_spawn_chance = 50
var no_spawn_growth_factor = 1.5 # 20%
var rarity : float
var size = 10
var small_trink_size = 10
var parent_trink = false


var sides = {
	0: null, # This is the right side
	1: null, # This is the left side
	2: null # This is the base, or bottom side
}


func _ready():
	size = small_trink_size
	for side in sides:
		
		## Check if it is possible to spawn a new trink
		if parent_trink and side == 2: continue # If a child trink, don't spawn anything directly below
		if sides[side] != null: continue # Don't replace an existing trink
		if await check_for_obstacles(): continue
		print("we all good for spawning trinks chief")
		
		## Let's find a new trink
		var new_trink_type = choose_new_trink(no_spawn_chance)
		if new_trink_type == null: continue # No new trinks on this side
		print('new trink type: ', new_trink_type)
		await get_tree().create_timer(1).timeout
		
		## Load the trink
		var new_trink = load(new_trink_type).instantiate()
		new_trink.no_spawn_chance = no_spawn_chance * no_spawn_growth_factor
		# update the spawn chance
		new_trink.sides[get_sibling_side(side)] = self 
		# I set myself as one of the existing siblings for the next trink
		print('new trink type: ', new_trink, " new spawn chance: ", new_trink.no_spawn_chance)
		await get_tree().create_timer(1).timeout
		
		## Position the Trink
		var new_transform = get_new_transform(side)
		new_trink.position = new_transform[0]
		new_trink.rotation = deg_to_rad(new_transform[1])
		print('new trink transform: ', new_trink.position, " ", new_trink.rotation)
		await get_tree().create_timer(1).timeout
		
		## Update variables
		label.text = (str(Global.index))
		Global.index += 1
		sides[side] = new_trink
		new_trink.parent_trink = true
		add_child(new_trink)
		print("new trink! ", new_trink)
		await get_tree().create_timer(1).timeout
		
		
		

func check_for_obstacles():
	ray_cast_2d = RayCast2D.new()
	ray_cast_2d.target_position = Vector2(0,size+1)
	add_child(ray_cast_2d)
	#ray_cast_2d.add_exception(get_node("TrinkBody"))
	for side in sides.size():
		if ray_cast_2d.is_colliding():
			return ray_cast_2d.is_colliding()
			print("hit: ",ray_cast_2d.get_collider())
			ray_cast_2d.queue_free()
		else:
			await get_tree().create_timer(.5).timeout
			print(ray_cast_2d.get_collider())
			ray_cast_2d.rotation += deg_to_rad(120)
	print("hit nothing: ",ray_cast_2d.get_collider())
	ray_cast_2d.queue_free()
	return ray_cast_2d.is_colliding()

func choose_new_trink(chance):
	var rng = RandomNumberGenerator.new()
	var num = rng.randi_range(1, Global.total_spawn_chance + chance)
	for path in Global.all_trinks:
		num -= Global.all_trinks[path]
		if num <= 0:
			return path
	return null


func get_new_transform(side):
	#var offset = size /2 * sqrt(3)
	#print("current offset: ", offset)
	#var new_transform
	var new_position
	var new_rotation
	if side == 0:
		print("right")
		new_position = get_parent().position + Vector2(size, (-size/2 - 1))
		new_rotation = get_parent().rotation + 60.0
	elif side == 1:
		print("left")
		new_position = get_parent().position + Vector2(-size, (-size/2 - 1))
		new_rotation = get_parent().rotation - 60.0
	elif side >= 2: 
		print("down")
		new_position = get_parent().position + Vector2(0,size+1)
		new_rotation = get_parent().rotation + 180
	#new_transform = Transform2D(new_rotation, new_position)
	print(new_rotation, ' new rotation ', new_position, ' new position ')
	return [new_position,new_rotation]

	

	
func get_sibling_side(side):
	if side == 0:
		return 1
	elif side == 1:
		return 0
	elif side == 2:
		return 2
	
