extends NetTool
class_name GameServer

signal clientConnected(client:RemoteClient)

var isRunning:bool = false

var udp_server:UDPServer
var tcp_server:TCPServer
var clients:Array[RemoteClient]

var chat:Chat

var objectManager:ObjectManager

##When we get tcp connection without udp client connection before
var handledFreeTCPConnections:Array[StreamPeerTCP]

func run(port:int = DEFAULTPORT):
	if isRunning:
		push_warning("This server already running!")
		return
	isRunning = true
	
	udp_server = UDPServer.new()
	tcp_server = TCPServer.new()
	
	chat = Chat.new()
	chat.sys("Server inited")
	
	objectManager = ObjectManager.new(true)
	add_child(objectManager)
	
	solver = ServerPacketSolver.new()
	
	listen(port)
	print("Server inited with port: ",udp_server.get_local_port())

func listen(port:int = DEFAULTPORT):
	var errorUDP:Error = udp_server.listen(port)
	var errorTCP:Error = tcp_server.listen(port+1)
	
	if errorUDP != OK or errorTCP != OK:
		print("SERVER LISTEN ERROR UDP: ",errorUDP)
		print("SERVER LISTEN ERROR TCP: ",errorTCP)
	else:
		print("Server listening")

func tick():
	##POLL NEEDED ONLY FOR UDP
	udp_server.poll()
	
	##ONLY WHEN NEW CLIENT CONNECTED
	##Registring udp
	while udp_server.is_connection_available():
		registerNewConnection(udp_server.take_connection())
		
	##Registring tcp
	while tcp_server.is_connection_available():
		applyTCPConnection(tcp_server.take_connection())
		
	##FOR EVERY CLIENTS
	for client:RemoteClient in clients:
		while client.getPacketCount()+client.getBytesCount()>0:
			var packet:PackedByteArray = client.getPacket()
			solvePacket(packet,client)

func registerNewConnection(peer:PacketPeerUDP):
	var packet:PackedByteArray = peer.get_packet()
	print("New connection; packet: ", solver.parsePacket(packet))
	
	var cmd:int = solver.parseCmd(packet)
	if cmd == 0:
		var rc:RemoteClient = RemoteClient.new(peer)
		rc.name = solver.parsePacket(packet).get_string_from_utf8()
		clients.append(rc)
		
		if clients.size()<=1:
			rc.host = true
			rc.metadata.set("prefix","<Host>")

func applyTCPConnection(peer:StreamPeerTCP):
	var ip:String = peer.get_connected_host()
	print("New TCP connection; ip: ",ip)
	##WARNING 
	##In this ip compare we have problem with connection from 1 machine with 2 game clients.
	##To avoid this we need to check peerTCP == null
	var rc:RemoteClient = clients.get(clients.find_custom(func(c:RemoteClient): return c.getIP() == ip && c.peerTCP == null))
	
	if rc:
		rc.peerTCP = peer
		print("Remote client ",rc.name," connect his TCP")
	clientConnected.emit()
	
	makePlayers()
	restorePlayers(rc)

func sendPacket(packet:PackedByteArray,client:RemoteClient):
	client.sendPacketUDP(packet)

func sendEveryone(packet:PackedByteArray):
	for client in clients:
		client.sendPacketUDP(packet)

func sendPacketSafe(packet:PackedByteArray,client:RemoteClient):
	client.sendPacketTCP(packet)

func sendEveryoneSafe(packet:PackedByteArray):
	for client in clients:
		client.sendPacketTCP(packet)

func restorePlayers(client:RemoteClient):
	for c in clients:
		if client == c:
			continue
		client.sendPacketTCP(NewObjectSolver.assemble("Player",c.player.getId()))
	pass

func makePlayers():
	for c:RemoteClient in MainHandler.server.clients:
		if c.player == null:
			c.player = makePlayer(c)

func makePlayer(client:RemoteClient):
	return MainHandler.server.objectManager.newObject("Player",client)
