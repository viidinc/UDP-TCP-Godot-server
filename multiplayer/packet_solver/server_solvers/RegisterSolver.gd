extends CommandSolver
class_name RegisterSolver

func getID():
	return 0

func solve(packet:PackedByteArray,client:RemoteClient = null):
	print("New client connected: ",packet.get_string_from_utf8())
	print(packet)
	MainHandler.server.sendEveryone(ChatSolverParce.assemble("Server","[color=green]"+client.name+"[/color] has been connected"))

static func assembly(name:String):
	var buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	
	buffer.put_u16(0)
	buffer.put_data(name.to_utf8_buffer())
	print("Assembled reg",buffer.data_array)
	return buffer.data_array
