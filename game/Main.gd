extends Node


func _ready():
	SignalBus.connect("shootProjectile", self, "_on_Player_shoot")


func _on_Player_shoot(projectileScene, spawnPoint):
	var projectile = projectileScene.instance()
	add_child(projectile)
	projectile.global_transform = spawnPoint.global_transform
