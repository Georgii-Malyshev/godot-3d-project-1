extends Node


func _enter_tree():
	# TODO don't use signals to start behavior
	SignalBus.connect("spawnPlayer", self, "_on_Player_spawn")
	SignalBus.connect("shootProjectile", self, "_on_Player_shoot")


func _on_Player_spawn(spawnPoint):
	var player = $Player
	player.set_global_transform(spawnPoint.global_transform)


func _on_Player_shoot(projectileScene, spawnPoint):
	var projectile = projectileScene.instance()
	add_child(projectile)
	projectile.set_global_transform(spawnPoint.global_transform)
