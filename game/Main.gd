extends Node


func _enter_tree():
	SignalBus.connect("spawnPlayer", self, "_on_Player_spawn")
	SignalBus.connect("spawn_projectile", self, "_on_spawn_projectile")


# TODO define args types, return type
func _on_Player_spawn(spawnPoint):
	var player = $Player
	player.set_global_transform(spawnPoint.global_transform)


func _on_spawn_projectile(
	_original_emitter: NodePath, 
	projectile_scene: PackedScene, 
	projectile_spawn_spatial: Spatial
	) -> void:
	
	var projectile: Node = projectile_scene.instance()
	add_child(projectile)
	projectile.set_global_transform(projectile_spawn_spatial.global_transform)
