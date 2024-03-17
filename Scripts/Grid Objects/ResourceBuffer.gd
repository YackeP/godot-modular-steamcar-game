extends Node3D

class_name ResourceBuffer

# the type of resource  might be irrelevant, maybe? 
@export var resourceType: SteamEngineTypes.SteamEngineResourceType
@export var resourceCapacity: float = 10.0

var resourceCount: float:
	get:
		return resourceCount
	set(newCount):
		resourceCount = min(newCount, resourceCapacity)

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "%s:%.2f" % [SteamEngineTypes.SteamEngineResourceType.keys()[resourceType], resourceCount] + "/%.2f" % resourceCapacity)


## this will return the value accepted by the buffer
func increaseResources(resourceInflow: float) -> float:
	var overflow = max(0,(resourceCount + resourceInflow) - resourceCapacity)
	resourceCount = resourceCount + resourceInflow
	return resourceInflow - overflow

func reduceResources(requested: float) -> float:
	var returned = max(0, resourceCount - requested)
	resourceCount -= requested
	return returned

## called by the main component script
func updateResources(newCount: float) -> void:
	resourceCount = newCount
