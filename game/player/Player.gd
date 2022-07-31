extends KinematicBody
class_name Player

# stats
var current_health: int = 66
var max_health: int = 100
var current_mana: int = 15

# physics
var gravity: float = 18.0
var snap: Vector3 = Vector3.DOWN

var move_speed: float = 2.5
var sneak_speed_modifier: float = 0.35
var run_speed_modifier: float = 5
var default_speed_modifier: float = 1
var speed_modifier: float = default_speed_modifier  # gets reset, don't change here
var speed_modifier_input: float = default_speed_modifier  # gets reset, don't change here

# camera look
var min_look_angle: float = -85.0
var max_look_angle: float = 85.0
var look_sensitivity: float = 0.66

# vectors
var velocity: Vector3 = Vector3.ZERO
var mouse_delta: Vector2 = Vector2()

var is_casting: bool = false

# player components
# TODO decouple
var spell: Node = preload("res://game/spells/BoneBarrage.tscn").instance()
onready var camera: Node = $FpsCamera
onready var cast_spatial: Spatial = $FpsCamera/SpellcastingRightArm/ProjectileSpawnPoint
onready var cast_transform: Transform setget set_cast_transform, get_cast_transform


func set_cast_transform(_value: Transform) -> void:
	print("Attempt to set cast_transform, ignoring")


func get_cast_transform() -> Transform:
	return cast_spatial.get_global_transform()


func _input(event):
	
	# First-person camera movement
	
	if event is InputEventMouseMotion:
		mouse_delta = event.relative  # get direction and length that the mouse moved
		# rotate camera along X axis
		camera.rotation_degrees -= Vector3(rad2deg(mouse_delta.y), 0, 0) * look_sensitivity * get_process_delta_time()
		
		# clamp vertical camera rotation
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, min_look_angle, max_look_angle)
		
		# rotate player along Y axis
		rotation_degrees -= Vector3(0, rad2deg(mouse_delta.x), 0) * look_sensitivity * get_process_delta_time()
		
		# reset the mouse delta vector
		mouse_delta = Vector2()

	# Actions
	if Input.is_action_just_pressed("cast_spell1"):
		cast_spell1()


func cast_spell1():
	# TODO take into account spell's mana cost
	if (not is_casting) and (current_mana > 0):
		# try to cast spell
		if spell.cast(self.get_path()):
			is_casting = true
			$CastSpellTimer.start(spell.get_cast_time())
			speed_modifier = speed_modifier * spell.get_cast_slowdown_modifier()
			current_mana -= 1  # TODO take into account spell's mana cost


func _ready():
	# hide mouse cursor and lock it to the game's window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# make preloaded&instanced scene a child of player
	add_child(spell)


func _physics_process (delta):
	
	# Player movement in space
	
	velocity.x = 0
	velocity.z = 0
	_reset_speed_modifier_input()
	
	var input = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if Input.is_action_pressed("run"):
		speed_modifier_input = run_speed_modifier
	elif Input.is_action_pressed("sneak"):
		speed_modifier_input = sneak_speed_modifier
	
	# normalize diagonal movement speed
	input = input.normalized()
	
	# get player's forward and right direction to know which way the player is facing
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	# set player movement velocity
	velocity.z = (forward * input.y + right * input.x).z * move_speed * speed_modifier_input * speed_modifier
	velocity.x = (forward * input.y + right * input.x).x * move_speed * speed_modifier_input * speed_modifier
	
	# apply gravity
	velocity.y -= gravity * delta
	
	# move the player, snap to the ground, stop on slopes
	var velocity_itermediate := move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, deg2rad(45))
	if is_on_wall():
		velocity_itermediate.y = min(0, velocity.y)
	velocity = velocity_itermediate


func take_damage(damage):
	current_health -= damage
	
	if current_health <= 0:
		die()

func die():
	print("Player dies!")  # TODO implement player death mechanic


func add_health(amount):
	current_health += amount


func add_mana(amount):
	current_mana += amount


func _reset_speed_modifier():
	speed_modifier = default_speed_modifier


func _reset_speed_modifier_input():
	speed_modifier_input = default_speed_modifier


func _on_CastSpellTimer_timeout():
	is_casting = false
	_reset_speed_modifier()
