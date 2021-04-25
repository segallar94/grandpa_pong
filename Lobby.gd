extends Node2D

onready var server_address = $ServerAddress

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("disconnected", self, "_disconnected")

func _on_ButtonHost_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_server(6969, 1)
	get_tree().set_network_peer(net)

func _on_ButtonJoin_pressed():
	var net = NetworkedMultiplayerENet.new()
	# This is for testing purposes only so I'm still able to test it locally
	if server_address.text != "":
		print("with set ip")
		net.create_client(server_address.text, 6969)
	else:
		print(server_address.text + " ipTExt")
		print("local setup")
		net.create_client("127.0.0.1", 6969)
	get_tree().set_network_peer(net)

func _player_connected(id):
	Globals.player2id = id
	var game = preload("res://Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()

func _disconnected():
	print("Disconnected")
