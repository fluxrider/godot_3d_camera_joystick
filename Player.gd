extends KinematicBody

var speed = 20 # meters per seconds
var jump_power = 100 # meters per seconds, injected as dirac action
var velocity = Vector3()

export(NodePath) var camera

func _physics_process(delta):
	# read joystick axis
	var d = Vector2()
	d.x = Input.get_joy_axis(0, 0)
	d.y = Input.get_joy_axis(0, 1)
	# axis deadzone
	if abs(d.x) < 0.05: d.x = 0
	if abs(d.y) < 0.05: d.y = 0
	
	# direction is relative to camera, not absolute axis
	d = d.rotated(-get_node(camera).azymuth - PI/2)
	
	# apply speed and gravity
	velocity.x = d.x * speed
	velocity.z = d.y * speed
	velocity.y += -9.8
	# note: delta is applied magically inside move_and_slide, see doc.
	velocity = self.move_and_slide(velocity, Vector3(0,1,0))
	
	# jump action (next frame)
	if self.is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y += jump_power