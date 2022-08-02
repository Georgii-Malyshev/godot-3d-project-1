extends "res://game/spells/AbstractSpell.gd"

# Curse a single target with a 'Hex' curse by holding it in "crosshair" for a short time

# Hex curse applies a medium-timed debuff that lowers target's resistances and 
# kills it if has less than 20% of health while the debuff is active

var max_distance: float = 50
var hold_line_of_sight_time: float = 2.0

# components
var is_equipped: bool = false
var is_casting: bool = false
var line_of_sight_was_broken: bool = false
var cast_to_vector := Vector3(0, 0, -(max_distance))
var collider: Object
var picked_target: Object
onready var ray_cast = $RayCast
onready var casting_timer: Timer = $CastingTimer
onready var hex = "hex_effect"  # TODO add type, create&use an actual "hex" resource


func _ready():
	set_mana_cost(1)
	set_cooldown_time(0.5)
	set_warmup_time(0.1)
	set_cast_time(2.1)
	set_cast_slowdown_modifier(0.8)


func _physics_process(_delta) -> void:
	if is_equipped:
		# Cast target-picking ray from caster
		ray_cast.set_global_transform(caster.get_cast_transform())
		collider = ray_cast.get_collider()  # TODO use to give hint on target currently looked at?
	if is_casting:
		if ray_cast.get_collider() != picked_target:
			line_of_sight_was_broken = true


func equip(caster_node_path: NodePath) -> void:
	is_equipped = true
	# Enable target-picking ray
	caster = get_node(caster_node_path)
	ray_cast.set_cast_to(cast_to_vector)
	ray_cast.set_enabled(true)


func execute_spell(_caster_node_path: NodePath) -> bool:
	
	line_of_sight_was_broken = false
	
	if collider and ("active_effects" in collider):
		picked_target = collider
		print(picked_target)  # TODO delete
		is_casting = true
		casting_timer.start(hold_line_of_sight_time)
		yield(casting_timer, "timeout")
		
		if line_of_sight_was_broken:
			print("Spell failed!")  # TODO delete
			return false
		
		# Set "hex" effect to target
		
		var target_active_effects: Dictionary = picked_target.active_effects
		if not target_active_effects.has("hex"):
			target_active_effects["hex"] = hex  # Add "hex" as a key and assign 'hex' as its value
		
		is_casting = false
		return true
	else:
		return false
