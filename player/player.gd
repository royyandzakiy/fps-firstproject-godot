extends CharacterBody3D

### ================ MOUSE DIRECTION ================ 

const MOUSE_SENSITIVITY = 0.05

@onready var camera = $CamRoot/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	window_activity()

func _input(event):
		if event is InputEventMouseMotion:
			# rotates view vertically
			$CamRoot.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			$CamRoot.rotation_degrees.x = clamp($CamRoot.rotation_degrees.x, -75, 75)
			
			# rotates view horizontally
			self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))	

# to show/hide the cursor
func window_activity():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

### ================ KEYBOARD MOVEMENT ================ 

const SPEED = 3.0
const SPRINT_SPEED = 9.0
const JUMP_VELOCITY = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 5

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var move_speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
	
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()
