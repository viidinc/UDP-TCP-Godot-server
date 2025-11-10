extends Resource
class_name RemoteClient

var name:String

var peerUDP:PacketPeerUDP
var peerTCP:StreamPeerTCP

var host:bool = false

var player:Player

var metadata:Dictionary[String,Variant] = {
	
	"name_color": Color.YELLOW,
	"message_color": Color.WHITE,
	"prefix":"<Player>"
}

func _init(peerUDP:PacketPeerUDP,peerTCP:StreamPeerTCP = null) -> void:
	self.peerUDP = peerUDP
	self.peerTCP = peerTCP

##Return UDP packets count
func getPacketCount() -> int:
	return peerUDP.get_available_packet_count()

##Return TCP Bytes count
func getBytesCount() -> int:
	return peerTCP.get_available_bytes()

##Return IP
func getIP() -> String:
	return peerUDP.get_packet_ip()

##Return packet from TCP AND UDP
##UDP priority
func getPacket()->PackedByteArray:
	if getPacketCount()>0:
		return getPacketUDP()
	return getPacketTCP()
	
##Return packet from UDP peer or null
func getPacketUDP()->PackedByteArray:
	return peerUDP.get_packet()

##Return packet from TCP peer or null
func getPacketTCP()->PackedByteArray:
	return peerTCP.get_var()

##Send UDP packet
func sendPacketUDP(packet:PackedByteArray)->void:
	peerUDP.put_packet(packet)

##Send TCP packet
func sendPacketTCP(packet:PackedByteArray)->void:
	peerTCP.put_var(packet)
	peerTCP.poll()
