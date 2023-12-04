extends Area3D

class_name OutputSocket

# WARNING: all the OutputSockets need to be referenced by grid objects
# 	TODO: assert that all the grid object's child OutputSockets are referenced
# 	could this be done only once per instance, and not every time the object is instantiated?

@export var outputType: SteamEngineTypes.SteamEngineResourceType

var connectedInputSocket: InputSocket

func _ready() -> void:
# shared between the 2 sockets
	assert(outputType != SteamEngineTypes.SteamEngineResourceType.UNDEFINED, "Output socket must have an output type defined")
	
	area_entered.connect(tryConnectSocket) # area_entered - Area3D signal when another area intersects it's collision area\
	
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "x" if connectedInputSocket != null else "" )

# a lot of code is shared between the 2 sockets
func tryConnectSocket(area: Area3D) -> void:
	if not area is InputSocket:
		# these should be debug instead of info, but idk how to set it so that these logs are displayed
		Logger.info("OutputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")
		return
	var socket = area as InputSocket
	if inputSocketContainsCompatibleResourceType(socket):
		connectedInputSocket = socket
		Logger.info("OutputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: success")
	else: # this else is here just for debuggin purposes
		Logger.info("OutputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")

func isConnected():
	return connectedInputSocket != null

# shared between the 2 sockets, if the socket parameter is a superclass
func inputSocketContainsCompatibleResourceType(socket: InputSocket) -> bool:
	return outputType == socket.getInputType()

## this will return the value accepted by the input
func sendResourcesToConnectedInputSocket(fullResource: float) -> float:
	if connectedInputSocket == null:
		Logger.debug("OutputSocket not connected to InputSocket, can't send resources!")
		return 0
	return connectedInputSocket.sendResourcesToConnectedResourceBuffer(fullResource)
