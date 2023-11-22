extends Area3D

class_name InputSocket

# shared between the 2 sockets
@export var connectableResourceTypes: Array[SteamEngineTypes.SteamEngineResourceType]

var connectedOutputSocket: OutputSocket
# shared between the 2 sockets
var parentGridComponent: StaticBody3D # scuffed

func _ready() -> void:
	# shared between the 2 sockets
	area_entered.connect(tryConnectSocket) # area_entered - Area3D signal when another area intersects it's collision area
	
	# get the root of the local scene, not the root tree
	var parent = get_parent_node_3d() # this is unsafe, we don't know if the input socket will be directly beneath the parent
	print(parent)
	assert(parent.has_method("receiveResources"), "Parent of InputSocket does not have method 'receiveResources'") # scuffed, will need to fix this
	parentGridComponent = parent

# shared between the 2 sockets
func tryConnectSocket(area: Area3D) -> void:
	print("InputSocket ", self.name, "tryToConnectSocket")
	if not area is OutputSocket:
		return
	var socket = area as OutputSocket
	if connectedSocketContainsCompatibleResourceType(socket):
		connectedOutputSocket = socket
	
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
