extends Node

var projectiles_number: int = 4
var projectile: PackedScene = preload("res://game/spells/BoneBarrageProjectile.tscn")
var cast_time: float = 0.4 setget set_cast_time, get_cast_time
var cast_slowdown_modifier: float = 0.1 setget set_cast_slowdown_modifier, get_cast_slowdown_modifier

onready var CooldownTimer: Timer = $CooldownTimer
onready var BarrageRateTimer: Timer = $BarrageRateTimer


func set_cast_time(_value: float) -> void:
	print("Attempt to change cast_time value, ignoring.")


func get_cast_time() -> float:
	return cast_time


func set_cast_slowdown_modifier(_value: float) -> void:
	print("Attempt to change cast_slowdown_modifier value, ignoring.")

func get_cast_slowdown_modifier() -> float:
	return cast_slowdown_modifier


func cast(caster: NodePath, spatial_to_cast_in: Spatial) -> void:
	# TODO add backfire, random spread and a "warm-up" timer
	if CooldownTimer.is_stopped():
		BarrageRateTimer.start()
		for i in projectiles_number:
			SignalBus.emit_signal("spawn_projectile", caster, projectile, spatial_to_cast_in)
			yield(BarrageRateTimer,"timeout")
		BarrageRateTimer.stop()
