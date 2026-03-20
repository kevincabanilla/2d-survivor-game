extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = %GridContainer

var meta_upgrade_card_scene = preload("res://scenes/ui/upgrade_screen/meta_upgrade_card.tscn")


func _ready() -> void:
	%BackButton.pressed.connect(_on_back_button_pressed)
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var meta_upgrade_card_instance: MetaUpgradeCard = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().root.set_input_as_handled()
		_on_back_button_pressed()
	elif event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()


func _on_back_button_pressed() -> void:
	ScreenTransition.transition_to_main_menu()
