extends BasePacketSolver
class_name ServerPacketSolver

func _init() -> void:
	appendSolver(ChatSolverProxy.new())
	appendSolver(RegisterSolver.new())
	appendSolver(ChatNameColor.new())
	appendSolver(ObjectSyncProxy.new())

##Find solver and call it
func solve(packet:PackedByteArray,client:RemoteClient = null):
	
	var commandIndex:int = parseCmd(packet)
	print("decoded command index: ",commandIndex)
	
	var solver = Solvers[commandIndex]
	solver.solve(parsePacket(packet),client)
