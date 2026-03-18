extends Node
class_name  AxeAbilityController

@export var axe_ability_scene: PackedScene
@export var base_damage := 10
@export var base_attack_interval := 5
@export var additional_damage_percent := 1.0

func _ready() -> void:
	$Timer.wait_time = base_attack_interval
	$Timer.start()
	attack()
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func attack() -> void:
	var player := Utils.get_player_node()
	if player == null:
		return
	
	var foreground_layer := Utils.get_foreground_node()
	if foreground_layer == null:
		return
	
	var axe_instance = axe_ability_scene.instantiate() as AxeAbility
	foreground_layer.add_child(axe_instance)
	axe_instance.hitbox_component.damage = base_damage * additional_damage_percent
	axe_instance.position = player.global_position


func _on_timer_timeout() -> void:
	attack()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		Utils.UPGRADE_ATTACK_SPEED:
			var percent_reduction = current_upgrades[Utils.UPGRADE_ATTACK_SPEED]["quantity"] * 0.1
			$Timer.wait_time = max(base_attack_interval - (base_attack_interval * percent_reduction), 0.1)
		Utils.UPGRADE_AXE_DAMAGE:
			additional_damage_percent = 1 + current_upgrades[Utils.UPGRADE_AXE_DAMAGE]["quantity"] * .1
	
	
