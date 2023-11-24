extends ColorRect

signal restart
signal next_level

@onready var restart_button = %RestartButton
@onready var next_level_button = %NextLevelButton


func _ready():
	next_level_button.grab_focus()


func _on_restart_button_pressed():
	restart.emit()


func _on_next_level_button_pressed():
	next_level.emit()
