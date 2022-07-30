extends Node

var projectiles_number: int = 4
var projectile: PackedScene = preload("res://game/spells/BoneBarrageProjectile.tscn")
onready var CooldownTimer: Timer = $CooldownTimer
onready var BarrageRateTimer: Timer = $BarrageRateTimer


func cast(caster: NodePath, spatial_to_cast_in: Spatial) -> void:
	# TODO add backfire, random spread and a "warm-up" timer
	if CooldownTimer.is_stopped():
		BarrageRateTimer.start()
		for i in projectiles_number:
			SignalBus.emit_signal("spawn_projectile", caster, projectile, spatial_to_cast_in)
			yield(BarrageRateTimer,"timeout")
		BarrageRateTimer.stop()
