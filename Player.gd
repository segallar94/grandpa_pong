extends Area2D
signal hit

onready var ball = get_parent().get_node("Ball")
export var SPEED = 250
var screen_size
var _up
var _down
var _left
var _right
var _hit

func start(pos):
	position = pos
	show()

func _ready():
	screen_size = get_viewport_rect().size
	$CollisionTimer.connect("timeout", self, "isColliding")
	_up = "move_up"
	_down = "move_down"
	_left = "move_left"
	_right = "move_right"
	_hit = "hit_ball"

func isColliding():
	if is_network_master():
		if Input.is_action_pressed(_hit):
			emit_signal("hit")

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2 )

func _process(delta):
	var velocity = Vector2()
	if is_network_master():
		if Input.is_action_pressed(_up):
			velocity.y -= 1
		elif Input.is_action_pressed(_down):
			velocity.y += 1
		if Input.is_action_pressed(_left):
			velocity.x -= 1
		elif Input.is_action_pressed(_right):
			velocity.x += 1
		
		if velocity.length() > 0:
			velocity = velocity.normalized()

		position += cartesian_to_isometric(velocity * SPEED * delta)
		rpc_unreliable("set_pos_and_velocity", position)

puppet func set_pos_and_velocity(p_pos):
	position = p_pos
