extends Node

@export var end_screen_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Player.health_component.died.connect(on_player_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_player_died() -> void:
	var end_screen_scene_instance = end_screen_scene.instantiate()
	end_screen_scene_instance.set_defeat()
	add_child(end_screen_scene_instance)
