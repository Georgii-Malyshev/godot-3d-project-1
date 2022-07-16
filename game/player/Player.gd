extends KinematicBody

# stats
var currentHp : int = 66
var maxHp : int = 100
var currentAmmo : int = 15
var killsTotal : int = 0

# physics
var moveSpeed : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 12.0

# camera look
var minLookAngle : float = -85.0
var maxLookAngle : float = 85.0
var lookSensitivity : float = 1.5

# vectors
var velocity : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# player components
onready var camera = get_node("Camera")
onready var muzzle = get_node("Camera/Gun/Muzzle")
# TODO don't use absolute path to the scene
onready var projectileScene = preload("res://game/actors/projectiles/Projectile.tscn")


# Called whenever an input is detected
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative  # get direction and length that the mouse moved


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide mouse cursor and lock it to the game's window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Controls
	
	# rotate camera along X axis
	camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y), 0, 0) * lookSensitivity * delta	
	
	# clamp vertical camera rotation
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate player along Y axis
	rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity * delta
	
	# reset the mouse delta vector
	mouseDelta = Vector2()
	
	if Input.is_action_just_pressed("fire"):  # TODO keep input detection out of _process function
		fire_projectile()


# Called every physics step
func _physics_process (Delta):
	# Player movement
	
	# reset the X and Z velocity
	velocity.x = 0
	velocity.z = 0
	
	var input = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	# normalize diagonal movement speed
	input = input.normalized()
	
	# get player's forward and right direction to know which way the player is facing
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	# set player movement velocity
	velocity.z = (forward * input.y + right * input.x).z * moveSpeed
	velocity.x = (forward * input.y + right * input.x).x * moveSpeed
	
	# apply gravity
	velocity.y -= gravity * Delta
	
	# move the player
	velocity = move_and_slide(velocity, Vector3.UP)
	
	# jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpForce


func fire_projectile():
	# TODO only allow firing if currentAmmo is > 0
	
	var projectile = projectileScene.instance()
	# TODO get rid of absolute node path and don't use node that is higher up in the hierarchy
	get_node("/root/TestLevel1").add_child(projectile)
	
	projectile.global_transform = muzzle.global_transform
	projectile.scale = Vector3.ONE
	
	currentAmmo -= 1

# Called when the player kills somebody
# Receives the number of kills to add to the total
func increase_kills_total(killsToAdd):
	killsTotal += killsToAdd


func take_damage(damage):
	currentHp -= damage
	
	if currentHp <= 0:
		die()

func die():
	pass  # TODO implement some player death mechanic


func add_health(amount):
	currentHp += amount


func add_ammo(amount):
	currentAmmo += amount
