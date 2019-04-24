extends Node2D

func _ready():
	get_tree().set_quit_on_go_back(false)

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		_on_BackButton_pressed()

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/GameMenu.tscn")
