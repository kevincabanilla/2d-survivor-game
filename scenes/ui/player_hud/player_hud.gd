extends CanvasLayer

@onready var level_label: Label = %LevelLabel
@onready var exp_label: Label = %ExpLabel
@onready var upgrade_points_label: Label = %UpgradePointsLabel

func _ready() -> void:
	#GameEvents.player_leveled_up.connect(_on_game_events_player_leveled_up)
	MetaProgression.save_data_updated.connect(_on_meta_progression_save_data_updated)
	GameEvents.vial_points_collected.connect(_on_game_events_vial_points_collected)
	update_ui()


func update_ui() -> void:
	level_label.text = "Curent Level: " + str(MetaProgression.get_meta_data(MetaProgression.CURRENT_LEVEL, 1))
	exp_label.text = "Exp: %d/%d" % [MetaProgression.get_meta_data(MetaProgression.CURRENT_EXPERIENCE, 0), MetaProgression.get_meta_data(MetaProgression.TARGET_EXPERIENCE, 1)]
	upgrade_points_label.text = "Upgrade Points: %s" % Utils.format_number_with_commas(MetaProgression.get_meta_data(MetaProgression.EXPERIENCE_POINTS, 0))

#func _on_game_events_player_leveled_up(_new_level: int) -> void:
	#update_ui()


func _on_meta_progression_save_data_updated(_save_data: Dictionary) -> void:
	update_ui()


func _on_game_events_vial_points_collected(number: float) -> void:
	update_ui()
