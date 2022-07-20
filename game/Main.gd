extends Node


func _enter_tree():
	SignalBus.connect("spawnPlayer", self, "_on_Player_spawn")


func _ready():
	SignalBus.connect("shootProjectile", self, "_on_Player_shoot")


func _on_Player_spawn(spawnPoint):
	print("function _on_Player_spawn called")  # TODO delete after debug
	var player = $Player
	player.set_global_transform(spawnPoint.global_transform)


func _on_Player_shoot(projectileScene, spawnPoint):
	var projectile = projectileScene.instance()
	add_child(projectile)
	projectile.set_global_transform(spawnPoint.global_transform)
