extends Node2D

@onready var eloNumberController: Node2D = $EloController/EloNumberController
@onready var tagLevelControllers: Array[Node2D] = [$CompetencesController/AnimatedProblemTagController/AnimatedProblemTag/TagLevelController, $CompetencesController/AnimatedProblemTagController/AnimatedProblemTag2/TagLevelController, $CompetencesController/AnimatedProblemTagController/AnimatedProblemTag3/TagLevelController]
@onready var tagTextControllers: Array[Node2D] = [$CompetencesController/AnimatedProblemTagController/AnimatedProblemTag/TagTextController, $CompetencesController/AnimatedProblemTagController/AnimatedProblemTag2/TagTextController, $CompetencesController/AnimatedProblemTagController/AnimatedProblemTag3/TagTextController]
@onready var animatedProblemTags: Array[Node2D] = [$CompetencesController/AnimatedProblemTagController/AnimatedProblemTag, $CompetencesController/AnimatedProblemTagController/AnimatedProblemTag2, $CompetencesController/AnimatedProblemTagController/AnimatedProblemTag3]

var competitor: Competitor
var letters: Array
var numbers: Array

func _ready():
	for i in range(10):
		numbers.append(load("res://Scenes/number_" + str(i) + ".tscn"))

	for i in range(26):
		var letter: String = str( char(97 + i) )
		letters.append(load("res://Scenes/letter_" + letter + ".tscn"))
	
	var colorArray = [Color.BROWN, Color.DARK_ORANGE, Color.DARK_SLATE_BLUE]
	for animatedTag in animatedProblemTags:
		animatedTag.modulate = colorArray.pick_random()
	
	mock_competitor()
	render_competitor()

func mock_competitor():
	competitor = Competitor.new()
	competitor.elo = 1500
	for competence in Auxiliary.TAGS:
		competitor.competences[competence] = 5
		

func render_competitor() -> void:
	render_elo()
	render_tags()

func render_elo() -> void:
	for child in eloNumberController.get_children():
		eloNumberController.remove_child(child)
	
	var elo = str(competitor.elo)
	for i in range(elo.length()):
		var asciiNumber = int(elo[i])
		var newNumber = numbers[asciiNumber].instantiate()
		newNumber.position.x += 10 * i
		eloNumberController.add_child(newNumber)

func render_tags() -> void:
	for i in range(3):
		for child in tagTextControllers[i].get_children():
			tagTextControllers[i].remove_child(child)
		for child in tagLevelControllers[i].get_children():
			tagLevelControllers[i].remove_child(child)
	
	var tags = []
	for key in competitor.competences:
		tags.append([competitor.competences[key], key])
	tags.sort()
	
	for i in range(3):
		var level: int = tags.back()[0]
		var tag: String = tags.back()[1].to_lower()
		tags.pop_back()
		
		var newNumber = numbers[level].instantiate()
		tagLevelControllers[i].add_child(newNumber)
		
		print("adicionando numero = ", newNumber)
		
		for j in range(tag.length()):
			var asciiNumber = tag.unicode_at(j) - 97
			var newLetter = letters[asciiNumber].instantiate()
			newLetter.position.x += 15 * j
			tagTextControllers[i].add_child(newLetter)
