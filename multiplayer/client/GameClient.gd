extends NetTool
class_name GameClient

## |  +            +  | ##
## |    < CLIENT >    | ##
## |  +            +  | ##

## In this case its local client

signal connected

var isRunning:bool = false
var isConnected:bool = false

var client:RemoteClient
var objectManager:ObjectManager

func run():
	if isRunning:
		push_warning("This client already running")
		return
	isRunning = true
	
	objectManager = ObjectManager.new(false)
	add_child(objectManager)
	
	client = RemoteClient.new(PacketPeerUDP.new(), StreamPeerTCP.new())
	
	solver = ClientPacketSolver.new()

func connectTo(ip:String,port:int = DEFAULTPORT,nickname:String = str(ip))->Error:
	if isConnected:
		push_warning("This client already connected!")
		return Error.ERR_ALREADY_IN_USE
	var errorUDP:Error = client.peerUDP.connect_to_host(ip,port)
	var errorTCP:Error = client.peerTCP.connect_to_host(ip,port+1)
	client.name = nickname
	if errorUDP == OK && errorTCP == OK:
		print("Connection successful")
		client.sendPacketUDP(RegisterSolver.assembly(nickname))
		client.sendPacketTCP(RegisterSolver.assembly(nickname))
		isConnected = true
		connected.emit()
	else:
		var err:Error
		if errorTCP != OK:
			err = errorTCP
		else:
			err = errorUDP
		print("Connection error: ",err)
	return errorUDP

func tick():
	client.peerTCP.poll()
	while client.getPacketCount()+client.getBytesCount()>0:
		solvePacket(client.getPacket(),client)

##Send data to server with udp
func sendPacket(packet:PackedByteArray):
	client.sendPacketUDP(packet)

##Send data to server with tcp
func sendPacketSafe(packet:PackedByteArray):
	client.sendPacketTCP(packet)
