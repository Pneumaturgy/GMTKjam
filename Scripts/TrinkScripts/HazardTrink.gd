extends Trink
class_name HazardTrink
const PLAYER = preload("res://Scenes/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	no_spawn_growth_factor = 10
	super._ready()
	#print("hazard", trink_body.monitoring)
	#get_parent().monitorable = false
	#get_parent().monitoring = false


func _on_detection_slot_area_entered(area):
	print(area)
	var target_trink
	if area is Area2D:
		target_trink = area.get_parent()
	print(target_trink)
	#print(new_parent)
	#if area.get_children().size() >= 2:
	if target_trink is Trink:
		target_trink.queue_free()
	else:
		print('yes')
