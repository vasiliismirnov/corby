extends Node2D

onready var score_label = preload("res://scenes/ScoreLabel.tscn")

func _ready():
	get_tree().set_quit_on_go_back(false)
	_load_scores()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_BackButton_pressed()

func _load_scores():
	var score_handler = get_node("/root/score_handler")
	var scores_container = $CanvasLayer/MarginContainer/GridContainer
	var position_counter = 1
	for score_record in score_handler.current_scores:
		var position_label = score_label.instance()
		var scores_label = score_label.instance()
		var moves_label = score_label.instance()
		position_label.text = "%s. " % position_counter
		scores_label.text = "%s" % score_record["score"]
		moves_label.text = "%s" % score_record["moves"]
		scores_container.add_child(position_label)
		scores_container.add_child(scores_label)
		scores_container.add_child(moves_label)
		position_counter += 1

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/GameMenu.tscn")
