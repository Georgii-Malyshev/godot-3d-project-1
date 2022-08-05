extends KinematicBody
class_name Player

# stats
var max_health: int = 100
var max_mana: int = 100
var move_speed: float = 1.8
var sneak_speed_modifier: float = 0.3
var run_speed_modifier: float = 5

# state
var is_casting: bool = false
var current_health: int = max_health setget set_current_health, get_current_health
var current_mana: int = max_mana setget set_current_mana, get_current_mana

# camera look
var min_look_angle: float = -60.0
var max_look_angle: float = 75.0
var look_sensitivity: float = 0.60

# physics
var gravity: float = 18.0
var snap: Vector3 = Vector3.DOWN
var default_speed_modifier: float = 1
var speed_modifier: float = default_speed_modifier  # gets reset, don't change here
var speed_modifier_input: float = default_speed_modifier  # gets reset, don't change here
# vectors
var velocity: Vector3 = Vector3.ZERO
var mouse_delta: Vector2 = Vector2()

# components
# TODO decouple
# TODO implement spell switching, call spell's 'equip' method when equipping it
var spell: Node = preload("res://game/spells/BoneBarrage.tscn").instance()
#var spell: Node = preload("res://game/spells/HexMark.tscn").instance()
onready var camera: Node = $FpsCamera
onready var animation_player: AnimationPlayer = $FpsCamera/AnimationPlayer
# TODO switch cast_spatial node based on the type of spell
# (spawn projectiles from one spatial, cast line-of-sight ray from another etc.)
onready var cast_spatial: Spatial = $FpsCamera/SpellcastingRightArm/ProjectileSpawnPoint
#onready var cast_spatial: Spatial = $FpsCamera/CastSpellPoint
onready var cast_transform: Transform setget set_cast_transform, get_cast_transform
onready var ground_detection_ray_cast: RayCast = $GroundDetectionRayCast


func set_current_health(value: int) -> void:
	# warning-ignore:narrowing_conversion
	current_health = clamp(value, 0, max_health)


func get_current_health() -> int:
	return current_health


func set_current_mana(value: int) -> void:
	# warning-ignore:narrowing_conversion
	current_mana = clamp(value, 0, max_mana)


func get_current_mana() -> int:
	return current_mana


func set_cast_transform(_value: Transform) -> void:
	print("Attempt to set cast_transform, ignoring")


func get_cast_transform() -> Transform:
	return cast_spatial.get_global_transform()


func _ready():
	# hide mouse cursor and lock it to the game's window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# make preloaded&instanced scene a child of player
	add_child(spell)
	
	spell.equip(self.get_path())  # TODO delete after implementing spell switching


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
	var velocity_intermediate := move_and_slide_with_snap(
		velocity, snap, Vector3.UP, true, 4, deg2rad(45)
	)
	
	if is_on_wall():
		ground_detection_ray_cast.set_enabled(true)
		ground_detection_ray_cast.force_raycast_update()
		if not ground_detection_ray_cast.is_colliding():
			velocity_intermediate.y = min(0, velocity.y)
	
	velocity = velocity_intermediate
	
	# TODO adjust animation speed and/or headbob strength based on movement speed
	if (velocity.x != 0) or (velocity.z != 0):
		animation_player.play("HeadBob")


func _input(event):
	
	# First-person camera movement
	if event is InputEventMouseMotion:
		# get direction and length that the mouse moved
		mouse_delta = event.relative
		# rotate camera along X axis
		camera.rotation_degrees -= Vector3(rad2deg(mouse_delta.y), 0, 0) * look_sensitivity * get_process_delta_time()
		# clamp vertical camera rotation
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, min_look_angle, max_look_angle)
		# rotate player along Y axis
		rotation_degrees -= Vector3(0, rad2deg(mouse_delta.x), 0) * look_sensitivity * get_process_delta_time()
		# reset the mouse delta vector
		mouse_delta = Vector2()
	
	# Actions
	if Input.is_action_just_pressed("cast_spell"):
		cast_spell()


func _reset_speed_modifier():
	speed_modifier = default_speed_modifier


func _reset_speed_modifier_input():
	speed_modifier_input = default_speed_modifier


func _on_CastSpellTimer_timeout():
	is_casting = false
	_reset_speed_modifier()


func add_health(amount):
	set_current_health(current_health + amount)


func add_mana(amount):
	set_current_mana(current_mana + amount)


func take_damage(damage):
	set_current_health (current_health - damage)
	
	if current_health == 0:
		die()

func die():
	print("Player dies!")  # TODO implement player death mechanic


func cast_spell():
	var spell_mana_cost: int = spell.get_mana_cost()
	if (not is_casting) and (current_mana >= spell_mana_cost):
		# try to cast spell
		spell.cast(self.get_path())
		is_casting = true
		set_current_mana(current_mana - spell_mana_cost)
		$CastSpellTimer.start(spell.get_cast_time())
		speed_modifier = speed_modifier * spell.get_cast_slowdown_modifier()
