extends "res://game/spells/AbstractSpell.gd"

# Fires a barrage of piercing bone projectiles with some random spread

var projectiles_number: int = 4

onready var BarrageRateTimer: Timer = $BarrageRateTimer

var projectile: PackedScene = preload("res://game/spells/BoneBarrageProjectile.tscn")


func execute_spell_at_transform(cast_transform: Transform, caster: NodePath) -> bool:
		# shoot projectile barrage
		# TODO add backfire
		BarrageRateTimer.start()
		for i in projectiles_number:
			SignalBus.emit_signal("spawn_projectile", caster, projectile, cast_transform)
			yield(BarrageRateTimer, "timeout")
		BarrageRateTimer.stop()
		return true
