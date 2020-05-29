extends RigidBody

var accel:Vector3
var force = 100
var turn = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	mass = 100
	#axis_lock_angular_x = true
	#axis_lock_angular_z = true
	#angular_damp = 0.95
	#linear_damp = 0.5
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	accel = Vector3.ZERO
	turn = 0
		
	if Input.is_action_pressed("accelerate"):
		accel = (10 * Vector3.FORWARD + Vector3.UP).normalized()
	if Input.is_action_pressed("decelerate"):
		accel = (10 * Vector3.BACK + Vector3.UP).normalized()
	if Input.is_action_pressed("turn_left"):
		turn += 1
	if Input.is_action_pressed("turn_right"):
		turn -= 1
		
func _integrate_forces(state):
	if (accel.length()):
		apply_central_impulse((to_global(accel) - global_transform.origin) * force)
	if (turn):
		apply_torque_impulse(Vector3.UP * turn)
