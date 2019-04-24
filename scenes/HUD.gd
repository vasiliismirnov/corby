extends CanvasLayer

signal exit_called()
signal restart_called()

func _ready():
	_set_score_lable(0)
	_set_turn_lable(0)

func update_hud(score, turns):
	_set_score_lable(score)
	_set_turn_lable(turns)

func _set_score_lable(score):
	$ScoreLabel.text = 'Score: %s' % score
	
func _set_turn_lable(turns):
	$TurnsLabel.text = 'Turns: %s' % turns

func _on_RestartButton_pressed():
	_set_buttons_visibility(false)
	emit_signal("restart_called")

func _on_ExitButton_pressed():
	_set_buttons_visibility(false)
	emit_signal("exit_called")

func _on_game_over():
	_set_buttons_visibility(false)

func _set_buttons_visibility(state):
	$RestartButton.visible = state
	$ExitButton.visible = state

func _on_Main_game_proceeded():
	_set_buttons_visibility(true)
