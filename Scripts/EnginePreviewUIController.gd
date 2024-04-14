extends Control

class_name EnginePreviewUIController

@export
var engineTilePanel:PackedScene

var panelMaring: int = 10

# for knowing where we should display the components icons
# we need to translate the world space into the UI space
var height: int
var width: int
var bottomLeftWorld: Vector2
var topRightWorld: Vector2

# the lowest and leftmost bounds of the UI
var bottomLeftPanelLimit: Vector2

# we don't want to rely on the grid only having tiles in positions with non-negative coordinates
var leftOffset = 0.0
var bottomOffset = 0.0

@onready
var spacePanels: Array = get_children().map(func(child: Node): return child is Panel)



func _ready() -> void:
	var gridPlacementController: GridPlacementController = get_node("../../")
	gridPlacementController.component_added.connect(_handleComponentAdded)
	gridPlacementController.component_removed.connect(_handleComponentRemoved)
	
	# can simplify this using reduce() and min() and max()
	# additionally, this can calso get used for calculating the panel min and max
	var topMax = 0.0
	var bottomMax = 0.0
	var leftMax = 0.0
	var rightMax = 0.0

	
	var gridSpaces: GridMap = get_node("../../GridMap")
	
	for space: Node3D in gridSpaces.get_children():
		topMax = max(topMax, space.position.z)
		bottomMax = min(bottomMax, space.position.z)
		leftMax = min(leftMax, space.position.x)
		rightMax = max(rightMax, space.position.x)
	
	bottomLeftWorld = Vector2(leftMax, bottomMax)
	topRightWorld = Vector2(rightMax, topMax)
	
	leftOffset = abs(0 - leftMax)
	bottomOffset = abs(0 - bottomMax)
	
	print("bottomLeftWorld: ", bottomLeftWorld)
	print("topRightWorld: ", topRightWorld)
	
	for space: Node3D in gridSpaces.get_children():
		var engineTile: Panel = engineTilePanel.instantiate()
		add_child(engineTile)
		engineTile.position = _calulatePanelSpace(space.position)

func _handleComponentAdded(component: GridComponent):
	pass

func _handleComponentRemoved(component: GridComponent):
	pass
	
func _calulatePanelSpace(worldSpace: Vector3) -> Vector2:
	# can probably add the size of the panel itself to the Y coordinate to make it lower
	return Vector2(worldSpace.x + leftOffset, worldSpace.z - bottomOffset) * 50

func _getPanel(panelSpace: Vector2):
	# TODO
	pass
