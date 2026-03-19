extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var desc_label: Label = %DescLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var progress_bar_label: Label = %ProgressBarLabel
@onready var purchase_button: Button = %PurchaseButton
@onready var upgrade_count_label: Label = %UpgradeCountLabel

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
	progress_bar_label.text = "%d/%d" % [current_exp, _upgrade.experience_cost]
	
	var upgrade_save_data = MetaProgression.get_meta_upgrade_save_data(_upgrade.id)
	if (!upgrade_save_data.is_empty()):
		var quantity = upgrade_save_data["quantity"]
		var is_maxed = quantity >= _upgrade.max_quantity
		purchase_button.disabled = percent < 1 || is_maxed
		upgrade_count_label.text = "x%d" % quantity
		if is_maxed:
			purchase_button.text = "Max"
	else:
		purchase_button.disabled = percent < 1
		upgrade_count_label.text = "x0"


func _on_purchase_button_pressed() -> void:
	if (_upgrade == null):
		return
	animation_player.play("click")
	MetaProgression.add_meta_upgrade(_upgrade)
	#get_tree().call_group("meta_upgrade_card", "update_progress")


func _on_meta_progression_exp_points_updated(_new_exp: int) -> void:
	update_progress()
