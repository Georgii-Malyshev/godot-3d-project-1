extends CanvasLayer


func _process(_delta: float) -> void:
	# TODO decouple from parent using signals
	$HealthLabel.text = (
		str(get_parent().get_parent().current_health) 
		+ "/" 
		+ str(get_parent().get_parent().max_health)
	)
	$ManaLabel.text = (
		str(get_parent().get_parent().current_mana) 
		+ "/" 
		+ str(get_parent().get_parent().max_mana)
	)
