extends Node
class_name ArenaTimeManager

const DIFFICULTY_INTERVAL = 5

@export var time_limit := 1.0
@export var end_screen_scene: PackedScene

@onready var timer = $Timer

signal arena_difficulty_increased(arena_difficulty: int)

var arena_difficulty: int = 0

func _ready() -> void:
	timer.wait_time = time_limit * 60.0
	timer.start()


func _process(_delta: float) -> void:
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
		#print(arena_difficulty)

func get_time_elapsed():
	return timer.wait_time - timer.time_left


func _on_timer_timeout() -> void:
	var end_screen_instance: EndScreen = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
