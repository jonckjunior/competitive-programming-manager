extends ScrollContainer
class_name StandingController

@export var timeToUpdateTheme = 0.5

var grabberTextures = [
	preload("res://Assets/scrollbar/scrollbar_grabber_selected1.png"),
	preload("res://Assets/scrollbar/scrollbar_grabber_selected2.png"),
	preload("res://Assets/scrollbar/scrollbar_grabber_selected3.png"),
	preload("res://Assets/scrollbar/scrollbar_grabber_selected4.png"),
	preload("res://Assets/scrollbar/scrollbar_grabber_selected5.png"),
]

var topDropdown = preload("res://Scenes/dropdown_top.tscn")
var bottomDropdown = preload("res://Scenes/dropdown_bottom.tscn")
var midDropdown = preload("res://Scenes/dropdown_mid.tscn")
var offsetVector: Vector2 = Vector2(0, 0)
var timeSinceLastUpdated = 0.0

var teams : Array[Manager]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceLastUpdated += delta
	
	if timeSinceLastUpdated > timeToUpdateTheme:
		var grabberTexture = grabberTextures.pick_random()
		var grabberStyle = StyleBoxTexture.new()
		grabberStyle.texture = grabberTexture
		theme.set_stylebox("grabber", "VScrollBar", grabberStyle)

		timeSinceLastUpdated = 0
	
func render_standings():
	#var topDrop = topDropdown.instantiate()
	#topDrop.position += offsetVector
	#$Control.add_child(topDrop)
	for i in range(teams.size()):
		var team : Manager = teams[i]
		var teamLine = midDropdown.instantiate()
		$Control.add_child(teamLine)
		teamLine.teamName = team.teamName
		teamLine.position.y += 30 * i
		teamLine.position += offsetVector
	
	#var bottomDrop = bottomDropdown.instantiate()
	#bottomDrop.position.y += 40 * (teams.size() + 1)
	#bottomDrop.position += offsetVector
	#$Control.add_child(bottomDrop)
	
	($Control as Control).custom_minimum_size.y = teams.size() * 30
