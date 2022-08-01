extends "res://game/spells/AbstractSpell.gd"

# Curse a single target by staring at it for a short time 
# without breaking line of sight

# Curse applies a medium-timed debuff that lowers target's resistances and 
# kills it if has less than 20% of health while the debuff is active


func execute_spell_at_transform(cast_transform: Transform, caster: NodePath) -> bool:
	# TODO set curse to target
	return true
