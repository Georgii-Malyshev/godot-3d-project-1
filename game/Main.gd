extends Node


func _enter_tree():
	SignalBus.connect("spawnPlayer", self, "_on_Player_spawn")
	SignalBus.connect("spawn_projectile", self, "_on_Player_shoot")


func _on_Player_spawn(spawnPoint):
	var player = $Player
	player.set_global_transform(spawnPoint.global_transform)


func _on_Player_shoot(projectileScene, spawnPoint):
	var projectile = projectileScene.instance()
	add_child(projectile)
	projectile.set_global_transform(spawnPoint.global_transform)
