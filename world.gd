extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer

func _ready():
	Events.level_completed.connect(show_level_completed)
	
	get_tree().paused = true
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	
func show_level_completed():
	level_completed.show()
	get_tree().paused = true
	
	await get_tree().create_timer(.5).timeout
	
	if next_level:
		await LevelTransition.fade_to_black()
		get_tree().change_scene_to_packed(next_level)
		get_tree().paused = false
		
