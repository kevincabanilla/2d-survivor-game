class_name LootChest extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



func _on_area_2d_area_entered(area: Area2D) -> void:
	var player_layer := 2
	if (!area.collision_layer & (1 << (player_layer - 1))):
		return
	$RandomAudioPlayerComponent.play_random()
	animated_sprite.play("open")
	await animated_sprite.animation_finished
	GameEvents.loot_chest_collected.emit()
	
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate", Color.TRANSPARENT, 1)
	tween.tween_callback(queue_free)
