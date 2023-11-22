extends StaticBody3D

class_name CoalFurnace

@export var heatCapacity: float = 100.0
@export var heatGeneratedPerSecond: float = 1.0
@export var heat: float = 0.0
@export var heatOutputSpeed: float = 0.75 # this may create a nice dynamic - some items may be producing quicker or slower than they output

@export var outputSocket: OutputSocket

func _ready() -> void:
	assert(outputSocket != null, "Coal furnace requires an OutputSocket!")
	
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "Heat:%.2f" % heat + "/%.2f" % heatCapacity)

func _physics_process(delta: float) -> void:
	var unboundHeat = heat + heatGeneratedPerSecond * delta
	var heatAcceptedByOutput = outputSocket.sendResourcesToConnectedInputSocket(min(unboundHeat, heatOutputSpeed))
	heat = min(unboundHeat - heatAcceptedByOutput, heatCapacity)
