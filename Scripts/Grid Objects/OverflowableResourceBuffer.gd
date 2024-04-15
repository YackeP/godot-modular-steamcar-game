extends ResourceBuffer

class_name OverflowableResourceBuffer
## This doesn't actually give a separate overflow counter, but rather sets a soft 
## secondary max called 'overflowLimit', which is lower than the max capacity.

@export
var overflowLimit: float

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "%s:%.2f" % [SteamEngineTypes.SteamEngineResourceType.keys()[resourceType], resourceCount] + "/%.2f" % resourceCapacity + "\novfl: %.2f+" % overflowLimit)

func isOverflown() -> bool:
	return resourceCount > overflowLimit

func getOverflowRate() -> float:
	return max(0, (resourceCount - overflowLimit)) / (resourceCapacity - overflowLimit)
