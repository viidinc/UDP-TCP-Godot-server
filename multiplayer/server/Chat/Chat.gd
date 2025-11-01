extends Object
class_name Chat

##Only for server
##Contain chat history

signal newMessage(sender:RemoteClient,message:String)

var messages:Array[String]

func append(sender:RemoteClient,message:String):
	messages.append(sender.name+"> "+message)
	newMessage.emit(sender,message)

func sys(message:String):
	messages.append("SYSTEM > "+message)
	newMessage.emit(null,message)
