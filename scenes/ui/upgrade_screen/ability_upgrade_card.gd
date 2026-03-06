extends PanelContainer
class_name AbilityUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel

signal selected()

func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	desc_label.text = upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		selected.emit()
