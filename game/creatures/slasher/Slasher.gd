extends "res://game/creatures/abstract_enemy/AbstractEnemy.gd"

var melee_hit_box: Area


func _ready() -> void:
	# override inherited stats
	max_health = 30
	_set_current_health(max_health)
	movement_speed = 5.0
	attack_range = 1.8
	attack_damage = 15
	attack_cooldown_time = 0.8
	
	# set up new (non-inherited) components
	melee_hit_box = $MeleeHitBox
	# TODO add assert to parent script
	attack_cooldown_timer.set_wait_time(attack_cooldown_time)

func attack():
	if attack_cooldown_timer.is_stopped():
		attack_cooldown_timer.start()
		var hitbox_overlapping_bodies: Array = melee_hit_box.get_overlapping_bodies()
		for body in hitbox_overlapping_bodies:
			if (
				not (body is Creature)
				and (body.has_method("take_damage"))
			):
				body.take_damage(attack_damage)
	else:
		pass
