extends StaticBody3D

class_name WallInputSocket

# different from all the others, they use meshes and this one uses just the CSGBox3D
@export var resourceBuffer: ResourceBuffer

var power: float = 0.0

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "Power:%.2f" % (power * 100))

func _physics_process(_delta: float) -> void:
	power = resourceBuffer.resourceCount
	resourceBuffer.updateResources(0.0)
