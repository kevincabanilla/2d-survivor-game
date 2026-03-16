extends Node
class_name  AxeAbilityController

@export var axe_ability_scene: PackedScene
@export var base_damage = 10
@export var base_attack_interval = 5

func _ready() -> void:
	$Timer.wait_time = base_attack_interval
	$Timer.start()
	attack()

func attack() -> void:
	var player := Utils.get_player_node()
	if player == null:
		return
	
	var foreground_layer := Utils.get_foreground_node()
	if foreground_layer == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as AxeAbility
	foreground_layer.add_child(axe_instance)
	axe_instance.hitbox_component.damage = base_damage
	axe_instance.position = player.global_position

func _on_timer_timeout() -> void:
	attack()
