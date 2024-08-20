extends Trink
class_name HazardTrink

# Called when the node enters the scene tree for the first time.
func _ready():
	no_spawn_growth_factor = 10
	no_spawn_chance = 100
	super._ready()
