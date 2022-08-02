extends "res://game/spells/AbstractSpell.gd"

# Fires a barrage of piercing bone projectiles with some random spread

var projectiles_number: int = 5

onready var BarrageRateTimer: Timer = $BarrageRateTimer

var projectile: PackedScene = preload("res://game/spells/BoneBarrageProjectile.tscn")


func _ready():
	set_mana_cost(25)
	set_cooldown_time(1.0)
	set_warmup_time(0.2)
	set_cast_time(0.8)
	set_cast_slowdown_modifier(0.15)


func execute_spell(caster_node_path: NodePath) -> bool:
		# Shoot projectile barrage
		# TODO add backfire
		caster = get_node(caster_node_path)
		BarrageRateTimer.start()
		for i in projectiles_number:
			SignalBus.emit_signal(
				"spawn_projectile", 
				caster_node_path, 
				projectile, 
				caster.get_cast_transform()
			)
			yield(BarrageRateTimer, "timeout")
		BarrageRateTimer.stop()
		return true
