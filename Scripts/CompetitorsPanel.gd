extends StaticBody2D

var positions = [Vector2(0, -40), Vector2(0, 0), Vector2(0, 40)]
var numberOfObjects = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(numberOfObjects)
	pass

func get_dropped_position():
	return position + positions[numberOfObjects]
