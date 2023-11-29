extends Area3D

class_name InputSocket

# shared between the 2 sockets
@export var connectableResourceTypes: Array[SteamEngineTypes.SteamEngineResourceType]

var connectedOutputSocket: OutputSocket
var resourceBuffer: ResourceBuffer
# shared between the 2 sockets
var parentGridComponent: StaticBody3D # scuffed

func _ready() -> void:
	# shared between the 2 sockets
	area_entered.connect(tryConnectSocket) # area_entered - Area3D signal when another area intersects it's collision area
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "x" if connectedOutputSocket != null else "" )

	
	# get the root of the local scene, not the root tree
	assert(!connectableResourceTypes.is_empty(), "Input socket must have input types defined")	
	var parent = get_parent_node_3d() # this is unsafe, we don't know if the input socket will be directly beneath the parent
	assert(parent.has_method("receiveResources"), "Parent of InputSocket does not have method 'receiveResources'") # scuffed, will need to fix this
	parentGridComponent = parent

# shared between the 2 sockets
func tryConnectSocket(area: Area3D) -> void:
	if not area is OutputSocket:
		# these should be debug instead of info, but idk how to set it
		Logger.info("InputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")
		return
	var socket = area as OutputSocket
	if connectedSocketContainsCompatibleResourceType(socket):
		connectedOutputSocket = socket
		Logger.info("InputSocket of " +  get_parent_node_3d().name + " tryToConnectSocket: success")
	else: # this else is here just for debuggin purposes
		Logger.info("InputSocket of " + get_parent_node_3d().name + " tryToConnectSocket: failed")
	
func connectedSocketContainsCompatibleResourceType(socket: OutputSocket) -> bool:
	for resourceType in connectableResourceTypes:
		if resourceType == socket.outputType:
			return true
	return false
	
func sendMessageToConnectedOutputSocket() -> void:
	connectedOutputSocket.sendMessageToParent()
	
# shared between the 2 sockets
func getConnectedComponentType() -> String:
	return parentGridComponent.get_class()

## this will return the value accepted (taken) by the input
func sendResourcesToConnectedGridComponent(resourceCount: float) -> float:
	return parentGridComponent.receiveResources(resourceCount)
