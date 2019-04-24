extends Node2D

enum GameAction {RESTART, EXIT, GAME_OVER}

var score = 0
var turns = 0

signal game_state_updated(score, turns)
signal game_proceeded()

func update_score(value):
	turns += 1
	score += value
	emit_signal("game_state_updated", score, turns)

func _ready():
	randomize()
	get_tree().set_quit_on_go_back(false)

func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
        _on_exit_called()

func _on_restart_called():
	get_tree().reload_current_scene()

func _on_exit_called():
	get_tree().change_scene("res://scenes/GameMenu.tscn")

func _on_game_over():
	var score_handler = get_node("/root/score_handler")
	score_handler.save_score(score, turns)
	score_handler.save_game()

func _on_GameDialog_dialog_proceeded(game_action):
	match game_action:
		GameAction.RESTART:
			 _on_restart_called()
		GameAction.EXIT:
			 _on_exit_called()
		GameAction.GAME_OVER:
			 _on_restart_called()

func _on_GameDialog_dialog_canceled(game_action):
	match game_action:
		GameAction.RESTART:
			 emit_signal("game_proceeded")
		GameAction.EXIT:
			 emit_signal("game_proceeded")
		GameAction.GAME_OVER:
			 _on_exit_called()
