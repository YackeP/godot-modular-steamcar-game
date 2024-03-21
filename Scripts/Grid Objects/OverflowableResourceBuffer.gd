extends ResourceBuffer

class_name OverflowableResourceBuffer
## This doesn't actually give a separate overflow counter, but rather sets a secondary max, which is lower than the whole capacity.

signal overflow_limit_reached


@export
var overflowLimit: float

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "%s:%.2f" % [SteamEngineTypes.SteamEngineResourceType.keys()[resourceType], resourceCount] + "/%.2f" % resourceCapacity + "\novfl:/%.2f" % overflowLimit)

## this will return the value accepted by the buffer
func increaseResources(resourceInflow: float) -> float:
	var accepted = super.increaseResources(resourceInflow)
	if resourceCount >= overflowLimit:
		overflow_limit_reached.emit()
	return accepted
