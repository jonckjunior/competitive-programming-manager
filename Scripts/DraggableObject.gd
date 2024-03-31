extends Node2D

var is_dragging = false
var draggable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
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
	if draggable:
		if Input.is_action_just_pressed("click"):
			initial_position = global_position
			offset = get_global_mouse_position() - global_position
			is_dragging = true
		
		if not is_dragging:
			return
		
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable and currentParent != body_ref:
				if currentParent != null:
					currentParent.numberOfObjects -= 1
				
				tween.tween_property(self, "global_position", body_ref.get_dropped_position(), 0.2).set_ease(Tween.EASE_OUT)

				currentParent = body_ref
				currentParent.numberOfObjects += 1
			else:
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)

func _on_mouse_entered() -> void:
	if not is_dragging:
		draggable = true
		$Button.scale = Vector2(1.05, 1.05)

func _on_mouse_exited() -> void:
	if not is_dragging:
		draggable = false
		$Button.scale = Vector2(1.0, 1.0)

func _on_body_entered(body) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body.modulate = Color(Color.PALE_GREEN, 0.3)
		body_ref = body

func _on_body_exited(body) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(Color.WHITE, 1.0)
