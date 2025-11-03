extends BasePacketSolver
class_name ClientPacketSolver

func _init() -> void:
	appendSolver(ChatSolverParce.new())
	appendSolver(MoveGameWindow.new())
	appendSolver(NewObjectSolver.new())
	appendSolver(ObjectSyncParce.new())

##Find solver and call it
func solve(packet:PackedByteArray,client:RemoteClient = null):
	
	var commandIndex:int = parseCmd(packet)
	print("decoded command index: ",commandIndex)
	
	var solver = Solvers[commandIndex]
	solver.solve(parsePacket(packet),client)
