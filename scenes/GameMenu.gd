extends Node2D

const MAIN_SCENE = preload("res://scenes/Main.tscn")
const HELP_SCENE = preload("res://scenes/Help.tscn")
const HIGH_SCORES_SCENE = preload("res://scenes/HighScores.tscn")

func _ready():
	get_tree().set_quit_on_go_back(true)

func _on_StartButton_pressed():
	get_tree().change_scene_to(MAIN_SCENE)

func _on_ScoresButton_pressed():
	get_tree().change_scene_to(HIGH_SCORES_SCENE)

func _on_HelpButton_pressed():
	get_tree().change_scene_to(HELP_SCENE)

func _on_ExitButton_pressed():
	get_tree().quit()
