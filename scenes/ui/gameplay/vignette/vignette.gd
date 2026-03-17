extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.player_damaged.connect(on_game_events_player_damaged)
	

func on_game_events_player_damaged() -> void:
	animation_player.play("flash")
