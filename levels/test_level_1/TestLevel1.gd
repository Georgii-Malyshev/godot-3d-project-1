extends Spatial


export var spawnLocation := Vector3(0, 0, 0)


func _ready():
	SignalBus.emit_signal("spawnPlayer", spawnLocation)
	
