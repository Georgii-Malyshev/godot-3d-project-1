extends KinematicBody
class_name Player

# Stats
var max_health: int = 100
var max_mana: int = 100

var health_regen_delay_time: float = 10.0
var health_regen_tick_time: float = 20.0
var health_regen_threshold: int = (max_health * 0.20)
var health_regen_per_tick: int = 1

var mana_regen_delay_time: float = 4.5
var mana_regen_tick_time: float = 0.5
var mana_regen_threshold: int = (max_mana * 0.25)
var mana_regen_per_tick: int = 1

var move_speed: float = 2.1
var sneak_speed_modifier: float = 0.4
var run_speed_modifier: float = 2.5

# State
var current_health: int = max_health setget _set_current_health, get_current_health
var current_mana: int = max_mana setget _set_current_mana, get_current_mana

var is_running: bool = false setget _set_is_running, get_is_running
var is_sneaking: bool = false setget _set_is_sneaking, get_is_sneaking
var is_casting: bool = false setget _set_is_casting, get_is_casting

# Camera look
var min_look_angle: float = -65.0
var max_look_angle: float = 45.0
var look_sensitivity: float = 0.60

# Physics
var _gravity: float = 18.0
var _snap_vector: Vector3 = Vector3.DOWN
var _default_speed_modifier: float = 1
var _speed_modifier: float = _default_speed_modifier  # gets reset, don't change here
var _speed_modifier_input: float = _default_speed_modifier  # gets reset, don't change here
# vectors
var _velocity: Vector3 = Vector3.ZERO
var _mouse_delta: Vector2 = Vector2()

# Components
onready var _ground_detection_ray_cast: RayCast = $GroundDetectionRayCast
onready var fps_camera: Node = $FpsCamera
onready var fps_camera_animation_player: AnimationPlayer = $FpsCamera/AnimationPlayer

onready var health_regen_delay_timer: Timer = $HealthRegenDelayTimer
onready var health_regen_tick_timer: Timer = $HealthRegenTickTimer
onready var mana_regen_delay_timer: Timer = $ManaRegenDelayTimer
onready var mana_regen_tick_timer: Timer = $ManaRegenTickTimer

# TODO implement spell switching, call spell's 'equip' method when equipping it
var spell: Node = preload("res://game/spells/BoneBarrage.tscn").instance()
#var spell: Node = preload("res://game/spells/HexMark.tscn").instance()
# TODO switch cast_spatial node based on the type of spell
# (spawn projectiles from one spatial, cast line-of-sight ray from another etc.)
onready var cast_spatial: Spatial = $FpsCamera/SpellcastingRightArm/ProjectileSpawnPoint
#onready var cast_spatial: Spatial = $FpsCamera/CastSpellPoint
onready var cast_transform: Transform setget _set_cast_transform, get_cast_transform
onready var cast_spell_timer: Timer = $CastSpellTimer


func _set_is_running(value: bool) -> void:
	if value:
		is_sneaking = false
		is_running = true
	else:
		is_running = false


func get_is_running() -> bool:
	return is_running


func _set_is_sneaking(value: bool) -> void:
	if value:
		if not is_running:
			is_sneaking = true
		else:
			print("Attempt to set is_sneaking to true while running, ignoring")
	else:
		is_sneaking = false


func get_is_sneaking() -> bool:
	return is_sneaking


func _set_is_casting(_value: bool) -> void:
	print("Attempt to set is_casting with setter, ignoring")


func get_is_casting() -> bool:
	return is_casting


func _set_current_health(value: int) -> void:
	# warning-ignore:narrowing_conversion
	current_health = clamp(value, 0, max_health)


func get_current_health() -> int:
	return current_health


func _set_current_mana(value: int) -> void:
	# warning-ignore:narrowing_conversion
	current_mana = clamp(value, 0, max_mana)


func get_current_mana() -> int:
	return current_mana


func _set_cast_transform(value: Transform) -> void:
	cast_transform = value


func get_cast_transform() -> Transform:
	return cast_spatial.get_global_transform()


func _ready():
	# hide mouse cursor and lock it to the game's window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	health_regen_tick_timer.set_wait_time(health_regen_tick_time)
	mana_regen_tick_timer.set_wait_time(mana_regen_tick_time)
	
	# make preloaded&instanced scene a child of player
	add_child(spell)
	
	spell.equip(self.get_path())  # TODO delete after implementing spell switching


func _physics_process (delta):
	
	# Player movement
	
	_velocity.x = 0
	_velocity.z = 0
	_reset_speed_modifier_input()
	is_running = false
	is_sneaking = false
	
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
		is_running = true
		_speed_modifier_input = run_speed_modifier
	elif Input.is_action_pressed("sneak"):
		is_sneaking = true
		_speed_modifier_input = sneak_speed_modifier
	
	# normalize diagonal movement speed
	input = input.normalized()
	
	# get player's forward and right direction to know which way the player is facing
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	# set player movement velocity
	_velocity.z = (forward * input.y + right * input.x).z * move_speed * _speed_modifier_input * _speed_modifier
	_velocity.x = (forward * input.y + right * input.x).x * move_speed * _speed_modifier_input * _speed_modifier
	
	# apply _gravity
	_velocity.y -= _gravity * delta
	
	# move the player, snap to the ground, stop on slopes
	var _velocity_intermediate := move_and_slide_with_snap(
		_velocity, _snap_vector, Vector3.UP, true, 4, deg2rad(45)
	)
	
	if is_on_wall():
		_ground_detection_ray_cast.set_enabled(true)
		_ground_detection_ray_cast.force_raycast_update()
		if not _ground_detection_ray_cast.is_colliding():
			_velocity_intermediate.y = min(0, _velocity.y)
	
	_velocity = _velocity_intermediate
	
	if (_velocity.x != 0) or (_velocity.z != 0):
		if is_running:
			fps_camera_animation_player.play("HeadBobRunning")
		elif is_sneaking:
			fps_camera_animation_player.play("HeadBobSneaking")
		else:
			fps_camera_animation_player.play("HeadBob")
	
	# Passive health & mana regen
	_try_health_regen()
	_try_mana_regen()


func _input(event):
	
	# FPS camera movement
	if event is InputEventMouseMotion:
		# get direction and length that the mouse moved
		_mouse_delta = event.relative
		# rotate camera along X axis
		fps_camera.rotation_degrees -= Vector3(rad2deg(_mouse_delta.y), 0, 0) * look_sensitivity * get_process_delta_time()
		# clamp vertical camera rotation
		fps_camera.rotation_degrees.x = clamp(fps_camera.rotation_degrees.x, min_look_angle, max_look_angle)
		# rotate player along Y axis
		rotation_degrees -= Vector3(0, rad2deg(_mouse_delta.x), 0) * look_sensitivity * get_process_delta_time()
		# reset the mouse delta vector
		_mouse_delta = Vector2()
	
	# Actions
	if Input.is_action_just_pressed("cast_spell"):
		_cast_spell()


func _reset_speed_modifier():
	_speed_modifier = _default_speed_modifier


func _reset_speed_modifier_input():
	_speed_modifier_input = _default_speed_modifier

func _try_health_regen() -> void:
	# Should be called every physics step to work correctly
	
	# Stop regeneration if threshold is reached
	if current_health >= health_regen_threshold:
		health_regen_tick_timer.stop()
	# Otherwise keep regenerating
	elif (
		health_regen_delay_timer.is_stopped()
		and health_regen_tick_timer.is_stopped()
	):
		health_regen_tick_timer.start()


func _try_mana_regen() -> void:
	# Should be called every physics step to work correctly
	
	# Stop regeneration if threshold is reached
	if current_mana >= mana_regen_threshold:
		mana_regen_tick_timer.stop()
	# Otherwise keep regenerating
	elif (
		mana_regen_delay_timer.is_stopped()
		and mana_regen_tick_timer.is_stopped()
	):
		mana_regen_tick_timer.start()


func _on_HealthRegenTickTimer_timeout():
	restore_health(health_regen_per_tick)


func _on_ManaRegenTickTimer_timeout():
	restore_mana(mana_regen_per_tick)


func _on_CastSpellTimer_timeout():
	is_casting = false
	_reset_speed_modifier()


func lose_health(amount):
	health_regen_delay_timer.start()
	_set_current_health(current_health - amount)
	if current_health <= 0:
		_die()


func lose_mana(amount):
	mana_regen_delay_timer.start()
	_set_current_mana(current_mana - amount)


func restore_health(amount):
	_set_current_health(current_health + amount)


func restore_mana(amount):
	_set_current_mana(current_mana + amount)


func take_damage(damage):
	lose_health(damage)


func _die():
	print("Player dies!")  # TODO implement player death mechanic


func _cast_spell():
	var spell_mana_cost: int = spell.get_mana_cost()
	if (not is_casting) and (current_mana >= spell_mana_cost):
		# try to cast spell
		if not spell.get_is_on_cooldown():
			spell.cast(self.get_path())
			is_casting = true
			lose_mana(spell_mana_cost)
			cast_spell_timer.start(spell.get_cast_time())
			_speed_modifier = _speed_modifier * spell.get_cast_slowdown_modifier()
