extends Node


func _enter_tree():
	SignalBus.connect("spawn_player", self, "_on_spawn_player")
	SignalBus.connect("spawn_projectile", self, "_on_spawn_projectile")


func _on_spawn_player(spawn_point: Spatial) -> void:
	var player = $Player
	player.set_global_transform(spawn_point.global_transform)


func _on_spawn_projectile(
	_original_emitter: NodePath, 
	projectile_scene: PackedScene, 
	projectile_spawn_spatial: Spatial
	) -> void:
	
	var projectile: Node = projectile_scene.instance()
	add_child(projectile)
	projectile.set_global_transform(projectile_spawn_spatial.global_transform)
