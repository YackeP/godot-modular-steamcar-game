extends Node3D

class_name ResourceBuffer

# this might be irrelevant, maybe? 
@export var _resourceType: SteamEngineTypes.SteamEngineResourceType
@export var _resourceCapacity: float = 10.0

var resourceCount: float:
	get:
		return resourceCount
	set(newCount):
		resourceCount = min(newCount, _resourceCapacity)

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "%s:%.2f" % [SteamEngineTypes.SteamEngineResourceType.keys()[_resourceType], resourceCount] + "/%.2f" % _resourceCapacity)


## this will return the overflow
func receiveResources(resourceInflow: float) -> float:
	var overflow = max(0,(resourceCount + resourceInflow) - _resourceCapacity)
	# repeated line -> can put the max(...) into the setter, need to confirm that setters are called when a new value is assigned
	resourceCount = min(resourceCount + resourceInflow, _resourceCapacity)
	return resourceInflow - overflow


## called by the main component script
func updateResources(newCount: float) -> void:
	resourceCount = min(newCount, _resourceCapacity)
	pass


