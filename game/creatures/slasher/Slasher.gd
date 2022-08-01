extends "res://game/creatures/abstract_enemy/AbstractEnemy.gd"


func _ready() -> void:
	# override inherited stats
	max_health = 35
	set_current_health(35)
	movement_speed = 5.8
	attack_range = 1.5
