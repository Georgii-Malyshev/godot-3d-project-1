extends "res://game/spells/AbstractSpell.gd"

# Curse a single target with a 'Hex' curse by staring at it for a short time 
# without breaking line of sight

# Hex curse applies a medium-timed debuff that lowers target's resistances and 
# kills it if has less than 20% of health while the debuff is active

onready var hex = "hex_effect"  # TODO add type, create&use an actual "hex" resource


func _ready():
	set_mana_cost(20)
	set_cooldown_time(1.0)
	set_warmup_time(0.1)
	set_cast_time(1.0)
	set_cast_slowdown_modifier(0.5)


func execute_spell(caster_node_path: NodePath) -> bool:
	# Get a target
	#var target: Creature
	# TODO implement getting target to cast the spell at
	
	# Set "hex" effect to target
	#var target_active_effects: Dictionary = target.active_effects
	#if not target_active_effects.has("hex"):
	#	target_active_effects["hex"] = hex  # Add "hex" as a key and assign 'hex' as its value
	#	return true
	#else:
	#	return false
	
	# TODO delete
	
	return false
