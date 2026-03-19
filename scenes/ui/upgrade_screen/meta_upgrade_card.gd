extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var progress_bar_label: Label = %ProgressBarLabel
@onready var purchase_button: Button = %PurchaseButton

var _upgrade: MetaUpgrade

func _ready() -> void:
	purchase_button.pressed.connect(_on_purchase_button_pressed)
	MetaProgression.exp_points_updated.connect(_on_meta_progression_exp_points_updated)


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	_upgrade = upgrade
	name_label.text = upgrade.title
	desc_label.text = upgrade.description
	update_progress()


func update_progress() -> void:
	var current_exp :=  MetaProgression.get_exp_points()
	var percent = max(current_exp as float / _upgrade.experience_cost, 0.01)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1
	progress_bar_label.text = "%d/%d" % [current_exp, _upgrade.experience_cost]


func _on_purchase_button_pressed() -> void:
	if (_upgrade == null):
		return
	animation_player.play("click")
	MetaProgression.add_meta_upgrade(_upgrade)
	#get_tree().call_group("meta_upgrade_card", "update_progress")


func _on_meta_progression_exp_points_updated(_new_exp: int) -> void:
	update_progress()
