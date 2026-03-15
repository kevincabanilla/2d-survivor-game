extends CharacterBody2D

@onready var velocity_component: VelocityComponent = $VelocityComponent

var is_moving = false

func _process(_delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	if velocity.x != 0:
		$SpriteVisuals.scale.x = sign(velocity.x) # flip the sprite depending on the direction


func set_is_moving(moving: bool) -> void:
	is_moving = moving
