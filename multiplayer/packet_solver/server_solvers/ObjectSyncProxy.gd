extends CommandSolver
class_name ObjectSyncProxy

func getID()->int:
	return 3002

func solve(packet:PackedByteArray,client:RemoteClient = null):
	var buffer = StreamPeerBuffer.new()
	#Just putting id and sending
	buffer.put_u16(3002)
	buffer.put_data(packet)
	
	MainHandler.server.sendEveryoneSafe(buffer.data_array)
