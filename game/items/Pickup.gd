extends Area

enum PickupType {
	Health,
	Mana
}

# stats
export (PickupType) var type = PickupType.Health
export var amount : int = 10


func _on_Pickup_body_entered(body):
	if body.name == "Player":
		pickup(body)
		queue_free()


func pickup(player):
	if type == PickupType.Health:
		player.add_health(amount)
	elif type == PickupType.Mana:
		player.add_mana(amount)
