extends Area2D

signal updateScore

export var speed = 250
var p1Score = 0
var p2Score = 0
var p1Serving = false
var direction = 1
onready var timer1 = get_parent().get_node("Player1/CollisionTimer")
onready var timer2 = get_parent().get_node("Player2/CollisionTimer")
var served = true
var hasBeenHit = false
onready var trajectory = Vector2(0,-1)

func _on_Ball_area_entered(area):
	if(area.name == "Player1"):
		timer1.start()
	elif(area.name == "Player2"):
		timer2.start()
	elif(area.name == "RightWall"):
		if is_network_master():
			rpc("update_score", "right")
			trajectory.y *= -1
#			rpc("set_pos_and_trajectory", Vector2(500,500), trajectory)
	elif(area.name == "LeftWall"):
		if is_network_master():
			rpc("update_score", "left")
			trajectory.y *= -1
#			rpc("set_pos_and_trajectory", Vector2(500,500), trajectory)
	elif(area.name == "TopWall" || area.name == "BottomWall"):
		trajectory.x *= -1

func _on_Ball_area_exited(area):
	if(area.name == "Player1"):
		timer1.stop()
	elif(area.name == "Player2"):
		timer2.stop()

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2 )

func _process(delta):
	if is_network_master():
		if(served):
			position += cartesian_to_isometric(trajectory.normalized()) * delta * speed * direction
		else:
			if(p1Serving):
				position = get_parent().get_node("Player1").position
			else:
				position = get_parent().get_node("Player2").position
		rpc("set_pos_and_trajectory", position, trajectory)
		
sync func set_pos_and_trajectory(p_pos, p_traj):
	position = p_pos
	trajectory = p_traj
	
sync func update_direction(dir):
	direction = dir

sync func update_trajectory(value):
	trajectory = value

sync func update_score(side):
	if (side == "left"):
		p1Score += 1
		emit_signal("updateScore", "Player1", p1Score)
	else:
		p2Score += 1
		emit_signal("updateScore", "Player2", p2Score)

func _on_Player1_hit(angle):
	print(angle)
	rpc("update_direction", direction * -1)
	rpc("update_trajectory", trajectory - angle)
	print(trajectory)

func _on_Player2_hit(angle):
	print(angle)
	rpc("update_direction", direction * -1)
	rpc("update_trajectory", trajectory - angle)
	print(trajectory)
