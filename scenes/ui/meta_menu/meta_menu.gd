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


func _on_back_button_pressed() -> void:
	ScreenTransition.transition_to_main_menu()
