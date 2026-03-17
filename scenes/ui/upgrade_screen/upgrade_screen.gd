extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]) -> void:
	var delay := 0.0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_popup_animation(delay)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += 0.2

func on_upgrade_selected(upgrade: AbilityUpgrade):
		upgrade_selected.emit(upgrade)
		$AnimationPlayer.play_backwards("in")
		await $AnimationPlayer.animation_finished
		get_tree().paused = false
		queue_free()
