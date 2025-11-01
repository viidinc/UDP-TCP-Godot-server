extends Node
class_name MainHandler

var isServer:bool = !false

signal serverRunning
signal clientRunning

static var server:GameServer
static var client:GameClient

@export var name_line:LineEdit

#func _ready() -> void:
	#return
	#isServer = OS.has_feature("server")
	#if isServer:
		#runServer()
	#else:
		#runClient()
	#pass

func runClient():
	if client != null:
		return
	get_window().title = "Client"
	print("run client")
	client = GameClient.new()
	client.run()
	get_tree().process_frame.connect(client.tick)
	#client.connectTo("127.0.0.1",NetTool.DEFAULTPORT,name_line.text)
	clientRunning.emit()

func runServer():
	if server != null:
		return
	get_window().title = "Server"
	print("run server")
	server = GameServer.new()
	server.run()
	get_tree().process_frame.connect(server.tick)
	serverRunning.emit()
