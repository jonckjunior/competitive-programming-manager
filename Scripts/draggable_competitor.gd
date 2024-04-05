extends Node2D
class_name DraggableCompetitor

var competitor: Competitor

var is_dragging = false
var draggable = false
var is_inside_dropable : Array
var mouseOffset: Vector2
var initial_position: Vector2
var previous_cursor: int
var currentParent

func _ready():
	(get_node("Area2D") as Area2D).mouse_entered.connect(_on_mouse_entered)
	(get_node("Area2D") as Area2D).mouse_exited.connect(_on_mouse_exited)
	(get_node("Area2D") as Area2D).body_entered.connect(_on_body_entered)
	(get_node("Area2D") as Area2D).body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var areas_colliding = (get_node("Area2D") as Area2D).get_overlapping_areas()
	if areas_colliding.all(func(areaNode: Node): return areaNode.is_in_group("mouse") == false):
		_on_mouse_exited()
	else:
		_on_mouse_entered()
	
	if draggable:
		if Input.is_action_just_pressed("click"):
			initial_position = global_position
			mouseOffset = get_global_mouse_position() - global_position
			is_dragging = true

		if not is_dragging:
			return

		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - mouseOffset
		elif Input.is_action_just_released("click"):
			is_dragging = false
			var tween = get_tree().create_tween()
			if not is_inside_dropable.is_empty() and currentParent != is_inside_dropable[0]:
				tween.tween_property(self, "global_position", global_position + Vector2(1, 1), 0.2).set_ease(Tween.EASE_OUT)
				
				if currentParent != null:
					(currentParent.objectsAttached as Array).erase(self)

				currentParent = is_inside_dropable[0]
				(currentParent.objectsAttached as Array).append(self)
				print(currentParent.objectsAttached)
			else:
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)

func _on_mouse_entered() -> void:
	if not is_dragging:
		draggable = true
		$PlayerPawn.scale = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	if not is_dragging:
		draggable = false
		$PlayerPawn.scale = Vector2(1.0, 1.0)

func _on_body_entered(body) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable.append(body)

func _on_body_exited(body) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable.erase(body)
