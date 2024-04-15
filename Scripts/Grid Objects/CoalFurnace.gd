extends GridComponent

class_name CoalFurnace

#@export var heatCapacity: float = 100.0
@export var heatGeneratedPerSecond: float = 1.0
#@export var heat: float = 0.0
@export var heatOutputSpeed: float = 0.75 # this may create a nice dynamic - some items may be producing quicker or slower than they output

@export var _outputSockets: Array[OutputSocket]
@export var _resourceBuffer: ResourceBuffer

func _ready() -> void:
	assert(!_outputSockets.is_empty(), "Coal furnace requires an OutputSocket!")

func _physics_process(delta: float) -> void:
	var overflow = _resourceBuffer.increaseResources(heatGeneratedPerSecond * delta)
	# filter to connected _outputSockets only
	for socket in _outputSockets.filter(func(s): return s.isConnected()):
		# this should preferably be done in just 1 line with 1 reference to the _resourceBuffer
		var heatAcceptedByOutput = socket.sendResourcesToConnectedInputSocket(_resourceBuffer.resourceCount + overflow)
		_resourceBuffer.reduceResources(heatAcceptedByOutput)
