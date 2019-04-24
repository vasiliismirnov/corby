extends Node2D

enum GameAction {RESTART, EXIT, GAME_OVER}

signal dialog_proceeded(game_action)
signal dialog_canceled(game_action)

var game_action

onready var popup_panel = $CanvasLayer/PopupPanel

func _ready():
	pass

func _on_game_over():
	game_action = GameAction.GAME_OVER
	_setup_labels("That's it!\nBetter luck next time", "Would you like to restart?")
	_show_popup()

func _on_restart():
	game_action = GameAction.RESTART
	_setup_labels("Would you like to\nrestart?", "Current progress\nwill be lost")
	_show_popup()

func _on_quit():
	game_action = GameAction.EXIT
	_setup_labels("Would you like to\nexit game?", "Current progress\nwill be lost")
	_show_popup()

func _setup_labels(title_text, subtitle_text):
	$CanvasLayer/PopupPanel/MarginContainer/VBoxContainer/TitleLabel.text = title_text
	$CanvasLayer/PopupPanel/MarginContainer/VBoxContainer/SubtitleLabel.text = subtitle_text

func _show_popup():
	popup_panel.popup()
	_animate_panel_position()

func _animate_panel_position():
	var screen_center_position = get_viewport_rect().size.y / 2 - popup_panel.rect_size.y / 2
	$PositionTween.interpolate_property(popup_panel, "rect_position", Vector2(2.5, -200), Vector2(2.5, screen_center_position), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$PositionTween.start()

func _on_YesButton_pressed():
	popup_panel.hide()
	emit_signal("dialog_proceeded", game_action)

func _on_NoButton_pressed():
	popup_panel.hide()
	emit_signal("dialog_canceled", game_action)
