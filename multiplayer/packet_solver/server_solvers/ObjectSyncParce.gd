extends CommandSolver
class_name ObjectSyncParceServer

func getID()->int:
	return 3002

func solve(packet:PackedByteArray,client:RemoteClient = null):
	var buffer = StreamPeerBuffer.new()
	buffer.data_array = packet
	
	#Recieving data
	var id:int = buffer.get_64()
	var property_name = buffer.get_utf8_string()
	var new_value = buffer.get_var()
	
	#Solving
	var object:Node = MainHandler.server.objectManager.objects[id]
	if object:
		object.set(property_name,new_value)
	MainHandler.server.sendEveryone(ObjectSyncParce.assemble(id,property_name,new_value))
	return
	var syncId:int = object.get_children().find_custom(func(node:Node): return node is NetworkSync)
	if !syncId:
		printerr("ERROR: Object ",object," does not have networkSync node!")
	else:
		var sync:NetworkSync = object.get_children().get(syncId)
		sync.sync()

static func assemble(objectId:int,property_name:String,new_value)->PackedByteArray:
	var buffer = StreamPeerBuffer.new()
	buffer.put_u16(3002)
	buffer.put_64(objectId)
	buffer.put_utf8_string(property_name)
	buffer.put_var(new_value)
	return buffer.data_array
