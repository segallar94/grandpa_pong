extends Node2D

onready var player2 = $Player2

func _ready():
	if get_tree().is_network_server():
		player2.set_network_master(get_tree().get_network_connected_peers()[0])
	else:
		player2.set_network_master(get_tree().get_network_unique_id())
	print("unique id: ", get_tree().get_network_unique_id())
