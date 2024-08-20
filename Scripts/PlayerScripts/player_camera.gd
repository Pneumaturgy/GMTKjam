extends Camera2D
class_name PlayerCamera

@onready var player := get_parent().get_node("Player")
@export var min_zoom := Vector2(2.0,2.0)
@export var max_zoom := Vector2(5.0,5.0)
@export var zoom_speed := 0.01
@export var zoom_factor := 0.15
@export var follow_speed := 1.0
@export var trink_detection_range := 5000.0  # Range to check for trink objects
var trinks
var visible_trinks = []
@onready var label = $Label
var counter = 0


func _ready():
	Global.new_trink.connect(get_trinks)
	Global.connected.connect(add_counter)
	## Detect Trinks
	get_trinks()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player != null:
		## Move the camera
		var target_position = player.position
		var current_position = self.position
		self.position = current_position.lerp(target_position, follow_speed * delta)
		## Zoom the camera
		var movement_speed = (position - current_position).length()
		var zoom_adjustment = movement_speed * zoom_factor
		var target_zoom = Vector2(max_zoom.x - zoom_adjustment, max_zoom.y - zoom_adjustment)
			
		## Clamp and apply zoom
		target_zoom = target_zoom.clamp(min_zoom, max_zoom)
		zoom = zoom.lerp(target_zoom, zoom_speed)
	else:
		zoom = zoom.lerp(min_zoom, zoom_speed)

func get_trinks():
	visible_trinks.clear()
	trinks = get_tree().get_nodes_in_group("trink")
	for trink in trinks:
		if trink.position.distance_to(player.position) <= trink_detection_range:
			visible_trinks.append(trink)
	
func add_counter():
	counter += 1
	label.text = str(counter)
