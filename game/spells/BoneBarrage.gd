extends Node

# TODO use specific projectile
var projectile: PackedScene = preload("res://game/spells/AbstractProjectile.tscn")


func cast(caster: NodePath, spatial_to_cast_in: Spatial) -> void:
	# TODO rename signal, consider using different strategy to spawn projectiles
	SignalBus.emit_signal("spawn_projectile", caster, projectile, spatial_to_cast_in)
