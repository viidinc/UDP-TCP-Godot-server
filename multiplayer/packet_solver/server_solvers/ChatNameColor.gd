extends CommandSolver
class_name ChatNameColor
func getID()->int:
	return 1002

func solve(packet:PackedByteArray,client:RemoteClient = null):
	
	if client == null:
		return
	
	var color:Color = bytes_to_var(packet)
	client.metadata.set("name_color",color)

static func assemble(color:Color):
	var buffer = StreamPeerBuffer.new()
	buffer.put_u16(1002)
	buffer.put_data(var_to_bytes(color))
	return buffer.data_array
