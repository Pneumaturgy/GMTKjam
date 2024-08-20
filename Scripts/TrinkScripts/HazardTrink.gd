extends Trink
class_name HazardTrink
const PLAYER = preload("res://Scenes/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	no_spawn_growth_factor = 10
	super._ready()
	#print("hazard", trink_body.monitoring)
	get_parent().monitorable = false
	get_parent().monitoring = false
	#get_parent().call_deferred("monitorable",false)


func _on_detection_slot_area_entered(area):
	#print("getting: ", area.get_parent())
	#print('yest')
	var new_parent = area.get_parent()
	new_parent.queue_free()
