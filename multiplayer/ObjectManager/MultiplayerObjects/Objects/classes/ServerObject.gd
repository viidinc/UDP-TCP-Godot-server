extends SyncedObject
class_name ServerObject

##Sending property [propertyName] to clients
func syncProperty(propertyName:String):
	var value = get(propertyName)
	MainHandler.server.sendEveryoneSafe(ObjectSyncParce.assemble(getId(),propertyName,value))
