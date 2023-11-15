extends StaticBody3D

class_name NeighbourCounter

@onready var textLabelParent: Node3D = get_node("Text Labels")
@onready var neighbourCheckArea: Area3D = get_node("NeighbourCheckArea")

func _updateCounter()-> void:
	var newNumber:int = _getNeigbourCount()
	var textChildren = textLabelParent.find_children("", "Label3D")
	for textChild in textChildren:
		textChild.text = str(newNumber)

func _getNeigbourCount() -> int:
	Logger.info("\t\tNeigbourChecker, neigbours:",neighbourCheckArea.get_overlapping_bodies().reduce(func(acc: String, body:Node3D): return acc + ", " + body.name,"")) 
	return neighbourCheckArea.get_overlapping_bodies().size() - 1 # one of these bodies is itself

# this doesn't detect new bodies that are instantiated, just the initial creation
# this is due to a bug:
	# https://github.com/godotengine/godot/issues/74300
	# https://github.com/godotengine/godot/issues/66468
	# https://github.com/godot-jolt/godot-jolt/issues/391
# so we have to do a workaround
func _on_area_3d_body_entered(body: StaticBody3D):
	Logger.info("onArea3dBodyEntered for : " + self.name + "\tbody:" + body.name )
	_updateCounter()

# this is a workaround for the problem mentioned above - this will refresh the collisions on every frame
func _physics_process(delta):
	# Considering "area" an Area3D, and layer 32 an unused layer 
	neighbourCheckArea.set_collision_layer_value(32, not neighbourCheckArea.get_collision_layer_value(32))

