extends KinematicBody


# stats
var current_health : int = 66
var max_health : int = 100
var current_mana : int = 15

# physics
var move_speed : float = 3.5
var sneak_speed_modifier : float = 0.35
var run_speed_modifier : float = 2.0
var gravity : float = 20.0
var snap := Vector3.DOWN

# Must be reset to 1 every frame for input handling to work correctly
var speed_modifier : float = 1

# camera look
var min_look_angle : float = -85.0
var max_look_angle : float = 85.0
var look_sensitivity : float = 0.66

# vectors
var velocity : Vector3 = Vector3.ZERO
var mouse_delta : Vector2 = Vector2()

# player components
onready var camera : Node = $FpsCamera  # TODO need some decoupling
onready var muzzle : Node = $FpsCamera/SpellcastingRightArm/ProjectileSpawnPoint  # TODO need some decoupling
onready var projectile : PackedScene = preload("res://game/projectiles/Projectile.tscn")  # TODO don't use absolute path to scene


# Called whenever an input is detected
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
	if Input.is_action_just_pressed("fire"):
		fire_projectile()


func _ready():
	
	# Hide mouse cursor and lock it to the game's window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	
	# Must be reset to 1 every frame for input handling to work correctly
	speed_modifier = 1


# Called every physics step
func _physics_process (Delta):
	
	# Player movement in space
	
	# reset the X and Z velocity
	velocity.x = 0
	velocity.z = 0
	
	var input = Vector2()  # TODO move declaration out of function and only reset to 0 in the function call?
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if Input.is_action_pressed("run"):
		speed_modifier = run_speed_modifier
	elif Input.is_action_pressed("sneak"):
		speed_modifier = sneak_speed_modifier
	
	# normalize diagonal movement speed
	input = input.normalized()
	
	# get player's forward and right direction to know which way the player is facing
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	# set player movement velocity
	velocity.z = (forward * input.y + right * input.x).z * move_speed * speed_modifier
	velocity.x = (forward * input.y + right * input.x).x * move_speed * speed_modifier
	
	# apply gravity
	velocity.y -= gravity * Delta
	
	# move the player, snap to the ground, stop on slopes
	var velocity_itermediate := move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, deg2rad(45))
	if is_on_wall():
		velocity_itermediate.y = min(0, velocity.y)
	velocity = velocity_itermediate


func fire_projectile():
	if current_mana > 0:
		SignalBus.emit_signal("shootProjectile", projectile, muzzle)
		current_mana -= 1


func take_damage(damage):
	current_health -= damage
	
	if current_health <= 0:
		die()

func die():
	pass  # TODO implement some player death mechanic


func add_health(amount):
	current_health += amount


func add_mana(amount):
	current_mana += amount
