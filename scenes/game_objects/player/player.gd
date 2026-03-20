extends CharacterBody2D

#const MAX_SPEED = 60
#const ACCELERATION_SMOOTING = 25

var base_speed := 0

var number_of_colliding_bodies = 0

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var velocity_component: VelocityComponent = $VelocityComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_speed = velocity_component.max_speed
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	#var target_velocity = direction * MAX_SPEED	
	#velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTING))	
	#move_and_slide()
	
	if movement_vector != Vector2.ZERO:
		animation_player.play("walk_animation")
	else:
		animation_player.play("idle")
	
	if velocity.x > 0:
		# Moving to right
		#$Sprite2D.flip_h = false;
		$SpriteVisual.scale.x = 1
	elif velocity.x < 0:
		# Moving to left
		#$Sprite2D.flip_h = true;
		$SpriteVisual.scale.x = -1 # this will flip both sprite and animation horizontally
	#else:
		# Not moving horizontally
		


func get_movement_vector():	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")	
	return Vector2(x_movement, y_movement)


func check_deal_damage() -> void:
	if number_of_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	
	health_component.damage(1)
	damage_interval_timer.start()
	#print(health_component.current_health)


func update_health_display():
	health_bar.value = health_component.get_heath_pecent()


func _on_collision_area_2d_body_entered(body: Node2D) -> void:
	number_of_colliding_bodies += 1
	check_deal_damage()


func _on_collision_area_2d_body_exited(body: Node2D) -> void:
	number_of_colliding_bodies -= 1


func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func on_health_changed() -> void:
	update_health_display()
	GameEvents.player_damaged.emit()
	$RandomHitAudioPlayer.play_random()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade is WeaponAbility:
		var axe_ability: AxeAbilityController = (upgrade as WeaponAbility).ability_controller_scene.instantiate()
		abilities.add_child(axe_ability)
	elif upgrade.id == Utils.UPGRADE_PLAYER_SPEED:
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades[Utils.UPGRADE_PLAYER_SPEED]["quantity"] * .1)
