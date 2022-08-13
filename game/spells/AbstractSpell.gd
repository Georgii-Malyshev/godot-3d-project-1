extends Node
class_name Spell

# Abstract spell; don't use directly, extend it to create actual spells

# stats
var mana_cost: int = 25 setget set_mana_cost, get_mana_cost
var cooldown_time: float = 1.0 setget set_cooldown_time, get_cooldown_time
var warmup_time: float = 0.2 setget set_warmup_time, get_warmup_time
var cast_time: float = 0.8 setget set_cast_time, get_cast_time
var cast_slowdown_modifier: float = 0.15 setget set_cast_slowdown_modifier, get_cast_slowdown_modifier

# components
var caster: Node
var cast_transform: Transform
var is_on_cooldown: bool = false setget set_is_on_cooldown, get_is_on_cooldown
onready var WarmupTimer: Timer = $WarmupTimer
onready var CooldownTimer: Timer = $CooldownTimer


func set_mana_cost(value: int) -> void:
	mana_cost = value


func get_mana_cost() -> int:
	return mana_cost


func set_cooldown_time(value: float) -> void:
	cooldown_time = value


func get_cooldown_time() -> float:
	return cooldown_time


func set_warmup_time(value: float) -> void:
	warmup_time = value


func get_warmup_time() -> float:
	return warmup_time


func set_cast_time(value: float) -> void:
	cast_time = value


func get_cast_time() -> float:
	return cast_time


func set_cast_slowdown_modifier(value: float) -> void:
	cast_slowdown_modifier = value

func get_cast_slowdown_modifier() -> float:
	return cast_slowdown_modifier

func set_is_on_cooldown(_value: bool) -> void:
	print("Attempt to change set_is_on_cooldown, ignoring")

func get_is_on_cooldown() -> bool:
	return not CooldownTimer.is_stopped()


func equip(_caster_node_path: NodePath) -> void:
	# Override in your spell if needed
	pass


func cast(caster_node_path: NodePath) -> bool:
	"""
	Returns true if cast was successfull, false if cast failed
	"""
	if CooldownTimer.is_stopped():
		# cast spell
		CooldownTimer.start(cooldown_time)
		is_on_cooldown = true
		WarmupTimer.start(warmup_time)
		yield(WarmupTimer, "timeout")
		return execute_spell(caster_node_path)
	else:
		return false


func execute_spell(_caster_node_path: NodePath) -> bool:
	# Implement actual actions for your spell to do here
	# Return true if spell actions were executed successfully
	return false


func _on_CooldownTimer_timeout():
	is_on_cooldown = false
