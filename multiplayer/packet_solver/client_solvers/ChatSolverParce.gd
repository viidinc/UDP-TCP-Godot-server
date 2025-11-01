extends CommandSolver
class_name ChatSolverParce

##Nickname, message
static var callbacks:Array[Callable]

func getID()->int:
	return 1001

func solve(packet:PackedByteArray,client:RemoteClient = null):
	parseMessage(packet,client)

func parseMessage(packet:PackedByteArray,client:RemoteClient = null):
	var buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	buffer.data_array = packet
	var nickname:String = buffer.get_utf8_string()
	var message:String = buffer.get_utf8_string()
	for m in callbacks:
		m.call(nickname,message)

static func assemble(nickname:String,message:String):
	var buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	buffer.put_u16(1001)#Write command id; 1001 because need to use server as proxy to message; see ChatSolverProxy.gd
	buffer.put_utf8_string(nickname)
	buffer.put_utf8_string(message)
	return buffer.data_array
