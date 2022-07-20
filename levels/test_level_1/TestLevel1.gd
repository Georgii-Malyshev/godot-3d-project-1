extends Spatial


onready var spawnLocation := $PlayerSpawnPoint


func _ready():
	SignalBus.emit_signal("spawnPlayer", spawnLocation)
