extends StaticBody3D

class_name WallInputSocket

const SOCKET_FILLED_MATERIAL = preload("res://Textures/WallInputSocketOverrideConnected.tres")

# different from all the others, they use meshes and this one uses just the CSGBox3D
@onready var mesh: CSGBox3D = get_node("CSGBox3D4")
@onready var inputSocket: Area3D = get_node("Input Socket")

@export var power: float = 0.0

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "Power:%.2f" % power)

func receiveResources(powerInflow: float) -> float:
	power += powerInflow
	return 0.0
