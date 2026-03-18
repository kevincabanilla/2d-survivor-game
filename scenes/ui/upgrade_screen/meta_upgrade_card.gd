extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	name_label.text = upgrade.name
	desc_label.text = upgrade.description


func select_card() -> void:
	animation_player.play("click")	


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		select_card()
