extends Node

class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10

var current_health: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func damage(damageAmount: float) -> void:
	current_health = max(current_health - damageAmount, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()

func get_heath_pecent():
	if max_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)
