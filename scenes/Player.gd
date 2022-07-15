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
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# player components
onready var camera = get_node("Camera")


# Called whenever an input is detected
func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative  # get direction and length that the mouse moved


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide mouse cursor and don't allow it to leave the game's window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# rotate camera along X axis
	camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y), 0, 0) * lookSensitivity * delta	
	
	# clamp vertical camera rotation
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	# rotate player along Y axis
	rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity * delta
	
	# reset the mouse delta vector
	mouseDelta = Vector2()
