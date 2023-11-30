extends Area3D

class_name InputSocket

@export var targetResourceBuffer: ResourceBuffer

var connectedOutputSocket: OutputSocket

func _ready() -> void:
	assert(targetResourceBuffer != null, "Input socket must have a ResourceBuffer defined")	
	
	# shared between the 2 sockets
	area_entered.connect(tryConnectSocket) # area_entered - Area3D signal when another area intersects it's collision area
	
	# shared between the 2 sockets
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "x" if connectedOutputSocket != null else "" )

# shared between the 2 sockets
func tryConnectSocket(area: Area3D) -> void:
	if not area is OutputSocket:
		# these should be debug instead of info, but idk how to set it so that these logs are displayed
		Logger.info("InputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")
		return
	var socket = area as OutputSocket
	if outputSocketContainsCompatibleResourceType(socket):
		connectedOutputSocket = socket
		Logger.info("InputSocket of " +  get_parent_node_3d().name + " tryToConnectSocket: success")
	else: # this else is here just for debuggin purposes
		Logger.info("InputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")
		
func getInputType():
	return targetResourceBuffer.resourceType

func outputSocketContainsCompatibleResourceType(socket: OutputSocket) -> bool:
	return socket.outputType == targetResourceBuffer.resourceType

## this will return the value accepted (taken) by the input
func sendResourcesToConnectedResourceBuffer(resourceCount: float) -> float:
	return targetResourceBuffer.receiveResources(resourceCount)
