extends ColorRect

signal restart
signal next_level

@onready var restart_button = %RestartButton
@onready var next_level_button = %NextLevelButton
@onready var your_time_label = %YourTimeLabel
@onready var best_time_label = %BestTimeLabel


func _ready():
	next_level_button.grab_focus()


func set_times(your_time, best_time):
	your_time_label.text = "Your Time: " + str(your_time / 1000.0)
	best_time_label.text = "Best Time: " + str(best_time / 1000.0)


func _on_restart_button_pressed():
	restart.emit()


func _on_next_level_button_pressed():
	next_level.emit()
