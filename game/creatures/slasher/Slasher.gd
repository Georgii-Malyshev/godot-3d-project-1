extends "res://game/creatures/abstract_enemy/AbstractEnemy.gd"


# stats
func _ready() -> void:
	max_health = 40
	current_health = 40
	movement_speed = 5.0
	attack_range = 1.5
