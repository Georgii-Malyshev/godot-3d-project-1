extends Node

var projectiles_number: int = 4
# TODO use specific projectile
var projectile: PackedScene = preload("res://game/spells/AbstractProjectile.tscn")
onready var CooldownTimer: Timer = $CooldownTimer
onready var BarrageRateTimer: Timer = $BarrageRateTimer


func cast(caster: NodePath, spatial_to_cast_in: Spatial) -> void:
	if CooldownTimer.is_stopped():
		BarrageRateTimer.start()
		for i in projectiles_number:
			SignalBus.emit_signal("spawn_projectile", caster, projectile, spatial_to_cast_in)
			yield(BarrageRateTimer,"timeout")
		BarrageRateTimer.stop()
