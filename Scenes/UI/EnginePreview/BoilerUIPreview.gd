extends Control

var boiler: SteamBoiler

@onready
var steamCounter: Label = $Steam
@onready
var overflowCounter: Label = $OverflowPercentage

func _process(_delta: float):
# FIXME: this knows too much about the boiler and it's resource buffer
	if (boiler != null):
		steamCounter.text = "S: %.2f" % boiler.getSteamLevel()
		overflowCounter.text = "boom: %.2f" %  boiler.overflowExplodiness
	
func registerObject(object: Node3D):
	if object is SteamBoiler:
		boiler = object

func destroyRepresentingUI(object: Node3D):
	if object == boiler:
		boiler = null # this is needed to remove the reference so that the object can be freed
		queue_free()
	
