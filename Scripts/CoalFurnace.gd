extends StaticBody3D

class_name CoalFurnace

#@export var heatCapacity: float = 100.0
@export var heatGeneratedPerSecond: float = 1.0
#@export var heat: float = 0.0
@export var heatOutputSpeed: float = 0.75 # this may create a nice dynamic - some items may be producing quicker or slower than they output

@export var outputSockets: Array[OutputSocket]
@export var resourceBuffer: ResourceBuffer

func _ready() -> void:
	assert(!outputSockets.is_empty(), "Coal furnace requires an OutputSocket!")


func _physics_process(delta: float) -> void:
#	resourceBuffer.receiveResources(heatGeneratedPerSecond * delta)
	var overflow = resourceBuffer.receiveResources(heatGeneratedPerSecond * delta)
	# filter to connected outputSockets only
	for socket in outputSockets:
		# this should preferably be done in just 1 line with 1 reference to the resourceBuffer
		var heatAcceptedByOutput = socket.sendResourcesToConnectedInputSocket(resourceBuffer.resourceCount + overflow)
		resourceBuffer.updateResources(resourceBuffer.resourceCount - heatAcceptedByOutput)
