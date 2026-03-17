extends PanelContainer
class_name AbilityUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer

signal selected()

var disabled := false


func play_popup_animation(delay := 0.0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func play_discard() -> void:
	animation_player.play("discard")
	await animation_player.animation_finished


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	desc_label.text = upgrade.description


func select_card() -> void:
	disabled = true
	animation_player.play("click")
	
	for other_card: AbilityUpgradeCard in get_tree().get_nodes_in_group(Utils.UPGRADE_CARD_GROUP):
		if (other_card == self):
			continue
		other_card.play_discard()
	
	await animation_player.animation_finished
	selected.emit()


func _on_gui_input(event: InputEvent) -> void:
	if (disabled):
		return
	if event.is_action_pressed("left_click"):
		select_card()


func _on_mouse_entered() -> void:
	if (disabled):
		return
	hover_animation_player.play("hover")
