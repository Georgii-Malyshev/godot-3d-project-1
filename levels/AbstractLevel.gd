extends Spatial

# Abstrack scene which all levels should extend. 

onready var spawnLocation := $PlayerSpawnPoint


func _ready():
	SignalBus.emit_signal("spawnPlayer", spawnLocation)
