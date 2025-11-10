extends NetworkSync
class_name NetworkSyncClient

##Sending object data from client to server
func syncProperty(propertyName:String,value:Variant):
	print("send packet ",propertyName," ",value)
	var packet = ObjectSyncParceServer.assemble(id,propertyName,value)
	MainHandler.client.sendPacketSafe(packet)
