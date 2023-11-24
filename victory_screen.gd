extends CenterContainer

@onready var menu_button = $VBoxContainer/MenuButton

func _ready():
	menu_button.grab_focus()
	LevelTransition.fade_from_black()


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://start_menu.tscn")
