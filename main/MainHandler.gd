extends Node
class_name MainHandler

var isServer:bool = !false

signal serverRunning
signal clientRunning

static var server:GameServer
static var client:GameClient

@export var name_line:LineEdit



func runClient():
	if client != null:
		return
	get_window().title = "Client"
	print("run client")
	client = GameClient.new()
	client.run()
	get_tree().process_frame.connect(client.tick)
	add_child(client)
	client.connected.connect(startGame)
	clientRunning.emit()

func runServer():
	if server != null:
		return
	get_window().title = "Server"
	print("run server")
	server = GameServer.new()
	server.run()
	get_tree().process_frame.connect(server.tick)
	add_child(server)
	serverRunning.emit()

func startGame():
	if !client.isConnected:
		push_error("Cannot start game without connection")
	client.add_child(preload("res://main/modules/world/World2d.scn").instantiate())
	pass
