extends Node

# Fires a barrage of piercing bone projectiles with some random spread

# stats
var projectiles_number: int = 4
var cast_time: float = 0.8 setget set_cast_time, get_cast_time
var cast_slowdown_modifier: float = 0.15 setget set_cast_slowdown_modifier, get_cast_slowdown_modifier
var cast_transform: Transform

# components
var projectile: PackedScene = preload("res://game/spells/BoneBarrageProjectile.tscn")
onready var WarmupTimer: Timer = $WarmupTimer
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


func cast(caster: NodePath) -> bool:
	"""
	Returns true if cast was successfull, false if cast failed
	"""
	if CooldownTimer.is_stopped():
		# begin casting
		CooldownTimer.start()
		WarmupTimer.start()
		yield(WarmupTimer, "timeout")
		
		# shoot projectile barrage
		# TODO add backfire
		BarrageRateTimer.start()
		for i in projectiles_number:
			cast_transform = get_node(caster).get_cast_transform()
			SignalBus.emit_signal("spawn_projectile", caster, projectile, cast_transform)
			yield(BarrageRateTimer, "timeout")
		BarrageRateTimer.stop()
		return true
	else:
		return false
