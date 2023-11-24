extends Node2D

@export var next_level: PackedScene

var level_time = 0.0
var start_level_time = 0.0

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel


func _ready():
	if not next_level:
		level_completed.next_level_button.text = "Victory Screen"
		next_level = load("res://victory_screen.tscn")

	Events.level_completed.connect(show_level_completed)

	get_tree().paused = true
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false

	start_level_time = Time.get_ticks_msec()


func _process(_delta):
	level_time = Time.get_ticks_msec() - start_level_time
	level_time_label.text = str(level_time / 1000.0)


func show_level_completed():
	level_completed.show()
	get_tree().paused = true


func _on_level_completed_next_level():
	if next_level:
		await LevelTransition.fade_to_black()
		get_tree().change_scene_to_packed(next_level)
		get_tree().paused = false


func _on_level_completed_restart():
	print("signal received")
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_file_path)
