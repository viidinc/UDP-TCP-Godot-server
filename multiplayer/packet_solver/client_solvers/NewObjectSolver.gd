extends CommandSolver
class_name NewObjectSolver

func getID()->int:
	return 3001

func solve(packet:PackedByteArray,client:RemoteClient = null):
	var buffer = StreamPeerBuffer.new()
	buffer.data_array = packet
	
	var infoObjectName:String = buffer.get_utf8_string()
	var objectId:int = buffer.get_64()
	var exclusive:bool = buffer.get_8()
	MainHandler.client.objectManager.pushObject(infoObjectName,objectId,exclusive)

##Server side only function
static func assemble(infoObjectName:String,id:int,exclusive:bool = false)->PackedByteArray:
	var buffer = StreamPeerBuffer.new()
	buffer.put_u16(3001)
	buffer.put_utf8_string(infoObjectName)
	buffer.put_64(id)
	buffer.put_8(exclusive)
	return buffer.data_array
