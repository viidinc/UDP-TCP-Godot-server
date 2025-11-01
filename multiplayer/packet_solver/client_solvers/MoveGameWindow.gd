extends CommandSolver
class_name MoveGameWindow

func getID()->int:
	return 2001

func solve(packet:PackedByteArray,client:RemoteClient = null):
	var buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	buffer.data_array = packet
	var x:int = buffer.get_var()
	var y:int = buffer.get_var()
	
	DisplayServer.window_set_position(DisplayServer.window_get_position()+Vector2i(x,y))

static func assemble(x:int,y:int)->PackedByteArray:
	var buffer:StreamPeerBuffer = StreamPeerBuffer.new()
	buffer.put_u16(2001) ##Command id
	buffer.put_var(x)
	buffer.put_var(y)
	return buffer.data_array
