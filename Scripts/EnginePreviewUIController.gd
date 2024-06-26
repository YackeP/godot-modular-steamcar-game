extends Control

class_name EnginePreviewUIController

@export var engineTilePanel: PackedScene
@export var engineOutputSocketPanel: PackedScene

# for knowing where we should display the components icons
# we need to translate the world space into the UI space
var height: int
var width: int
var bottomLeftWorld: Vector2
var topRightWorld: Vector2

# the lowest and leftmost bounds of the UI
var bottomLeftPanelLimit: Vector2

var _margin = 0.5

# we don't want to rely on the grid only having tiles in positions with non-negative coordinates
var leftOffset = 0.0
var bottomOffset = 0.0

@onready
var spacePanels: Array = get_children().map(func(child: Node): return child is Panel)

# THINK: should enginePreview know about the GridMap, or should the controller expose it?
# 		We are coupling the UI to the structure of the physical grid elements
@onready
var gridSpacesParent: GridMap = $"../../GridMap"


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
	
	for space: Node3D in gridSpacesParent.get_children():
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
	
	for space: Node3D in gridSpacesParent.get_children():
		var panelScene = _getPanelScene(space)
		if(panelScene):
			var engineTile: Panel = panelScene.instantiate()
			add_child(engineTile)
# FIXME: ugly, clunky, and not type-safe
			if(engineTile.has_method("registerObject")):
				engineTile.registerObject(space)
			engineTile.position = _calulatePanelSpace(space.position)

func _handleComponentAdded(component: GridComponent, componentDefinition: EngineComponentDefinition):
	if componentDefinition.enginePreviewUIElement != null:
		var preview: EngineElementUIPreviewBase = componentDefinition.enginePreviewUIElement.instantiate()
		add_child(preview)
		preview.registerObject(component)
		preview.position = _calculateComponentPanelSpace(component.position)
		preview.rotation_degrees = _calculateComponentRotation(component.rotation_degrees)
		

func _handleComponentRemoved(component: GridComponent):
	# FIXME: not type-safe
	propagate_call("destroyRepresentingUI", [component])
	
func _getPanelScene(gridSpace: Node3D) -> PackedScene:
	# FIXME: hardcoded class name to scene binding
	if (gridSpace is WallInputSocket):
		return engineOutputSocketPanel
	if (gridSpace is GridSpace):
		return engineTilePanel
	return null


func _calulatePanelSpace(worldSpace: Vector3) -> Vector2:
	# can probably add the size of the panel itself to the Y coordinate to make it lower
	return Vector2(worldSpace.x + leftOffset, worldSpace.z - bottomOffset) * 50

func _calculateComponentPanelSpace(worldSpace: Vector3) -> Vector2:
	return Vector2(worldSpace.x + leftOffset + _margin, worldSpace.z - bottomOffset + _margin) * 50

func _calculateComponentRotation(rotation: Vector3) -> float:
	return rotation.y + 90
