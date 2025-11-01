extends CommandSolver
class_name ChatSolverProxy

const commandStartChar:String = "/"
var regex = RegEx.new()

func _init() -> void:
	regex.compile("\\[.*?\\]")

func getID()->int:
	return 1001

func solve(packet:PackedByteArray,client:RemoteClient = null):
	processPacket(packet,client)

func processPacket(packet:PackedByteArray,client:RemoteClient = null):
	
	var buffer = StreamPeerBuffer.new()
	buffer.data_array = packet
	
	var name = buffer.get_utf8_string()
	var message = buffer.get_utf8_string()
	
	if message.begins_with(commandStartChar):
		commandSolver(message,client)
		return
	
	name = regex.sub(name,"",true)
	message = regex.sub(message,"",true)
	
	var buffer2 = StreamPeerBuffer.new()
	
	var prefix:String = ""
	var nameColorString:String = ""
	var messageColorString:String = ""
	
	if client:
		prefix = client.metadata.get("prefix","")
		nameColorString = "#"+client.metadata.get("name_color",Color.YELLOW).to_html(false)
		messageColorString = "#"+client.metadata.get("message_color",Color.BLACK).to_html(false)
	
	buffer2.put_u16(1001) #Write 1001 to correct solving on clients! See CharSolverParce.gd
	buffer2.put_utf8_string(prefix+" [color="+nameColorString+"]"+name)
	buffer2.put_utf8_string("[color="+messageColorString+"]"+message)
	
	MainHandler.server.sendEveryoneSafe(buffer2.data_array)

func commandSolver(msg:String,client:RemoteClient = null):
	var args:PackedStringArray = msg.split(" ")
	var cmd = args[0].erase(0)
	print("Recieved chat command: ",cmd)
	match cmd:
		"prefix":
			if client:
				client.metadata.set("prefix","<{0}>".format([args[1]]))
		"move_window":
			var id = str_to_var(args[1])
			var x = str_to_var(args[2])
			var y = str_to_var(args[3])
			if id is int:
				var c:RemoteClient = MainHandler.server.clients.get(id)
				if c != null:
					c.sendPacketTCP(MoveGameWindow.assemble(x,y))
		_:
			if client:
				client.sendPacketTCP(ChatSolverParce.assemble("Server","[color=red]Cannot find command "+str(cmd)+"[/color]"))
