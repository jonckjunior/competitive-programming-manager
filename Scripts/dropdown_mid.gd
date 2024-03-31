extends Node2D

@onready var teamNameContainer: Node2D = $TeamNameContainer
@export var teamName: String

var problemMarkers: Array
var letters: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	problemMarkers = $ProblemMarkerContainer.get_children()
	#for node in problemMarkers:
		#node.visible = false
	
	for i in range(26):
		var letter: String = str( char(97 + i) )
		letters.append(load("res://Scenes/letter_" + letter + ".tscn"))
	render_team_name()

func pass_problem(problemNumber: int) -> void:
	problemMarkers[problemNumber].visible = true

func render_team_name():
	for i in range(teamName.length()):
		print("lendo ", teamName[i])
		if teamName[i] == ' ':
			continue
		var asciiNumber = teamName.unicode_at(i) - 97
		print("asciinumber = ", asciiNumber)
		var newLetter = letters[asciiNumber].instantiate()
		print("newLetter = ", newLetter)
		newLetter.position.x += 15 * i
		teamNameContainer.add_child(newLetter)
		
