extends Spatial

# Abstract scene which all levels should extend. 

onready var spawn_position := $PlayerSpawnPoint


func _ready() -> void:
	SignalBus.emit_signal("spawn_player", spawn_position)
