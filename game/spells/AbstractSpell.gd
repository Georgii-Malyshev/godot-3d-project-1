extends Node

# Abstract spell; don't use directly, extend it to create actual spells

# stats
var mana_cost: int = 25 setget set_mana_cost, get_mana_cost
var cast_time: float = 0.8 setget set_cast_time, get_cast_time
var cast_slowdown_modifier: float = 0.15 setget set_cast_slowdown_modifier, get_cast_slowdown_modifier
var cast_transform: Transform

# components
onready var WarmupTimer: Timer = $WarmupTimer
onready var CooldownTimer: Timer = $CooldownTimer


func set_mana_cost(_value: int) -> void:
	print("Attempt to change mana_cost value, ignoring.")


func get_mana_cost() -> int:
	return mana_cost


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
		# cast spell
		CooldownTimer.start()
		WarmupTimer.start()
		yield(WarmupTimer, "timeout")
		cast_transform = get_node(caster).get_cast_transform()
		return execute_spell_at_transform(cast_transform, caster)
	else:
		return false


func execute_spell_at_transform(_cast_transform: Transform, _caster: NodePath) -> bool:
	# Implement actual actions for your spell to do here
	# Return true if spell actions were executed successfully
	return false
