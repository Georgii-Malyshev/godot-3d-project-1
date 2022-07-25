extends Area


func _ready():
	self.connect("body_entered", self, "_on_FieldOfViewArea_body_entered")
	self.connect("body_exited", self, "_on_FieldOfViewArea_body_exited")


func _on_FieldOfViewArea_body_entered(body: Node) -> void:
	SignalBus.emit_signal("fieldOfViewArea_body_entered", self, body)


func _on_FieldOfViewArea_body_exited(body: Node) -> void:
	SignalBus.emit_signal("fieldOfViewArea_body_exited", self, body)
