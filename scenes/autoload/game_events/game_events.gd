extends Node

@onready var loot_cooldown_timer: Timer = $LootCooldownTimer

const SPAWN_COOLDOWN_INCREMENT = 3

var can_spawn_loot := false
var spawn_cooldown := 0.0

signal vial_points_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged
signal player_leveled_up(new_level: int)
signal increase_exp(exp_val: float)
signal loot_chest_collected()


func _ready() -> void:
	initialize_cooldown_timer()
	loot_cooldown_timer.timeout.connect(_on_timer_timeout)


func initialize_cooldown_timer() -> void:
	can_spawn_loot = true
	spawn_cooldown = SPAWN_COOLDOWN_INCREMENT
	loot_cooldown_timer.wait_time = spawn_cooldown
	#print("Cooldown timer initialized")


func start_spawn_loot_cooldown_timer() -> void:
	#print("Cooldown started: " + str(spawn_cooldown))
	can_spawn_loot = false
	loot_cooldown_timer.start()


func emit_vial_points_collected(number: float) -> void:
	vial_points_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrades)


func _on_timer_timeout() -> void:
	can_spawn_loot = true
	spawn_cooldown = min(spawn_cooldown + SPAWN_COOLDOWN_INCREMENT, 15)
	loot_cooldown_timer.wait_time = spawn_cooldown
	#print("New spawn cooldown: " + str(spawn_cooldown))
