extends Control

var boiler: SteamBoiler

@onready
var steamCounter: Label = $Steam
@onready
var overflowCounter: Label = $OverflowPercentage

func _process(_delta: float):
# FIXME: this knows too much about the boiler and it's resource buffer
	if (boiler != null):
		steamCounter.text = "%.2f" % boiler.steamBuffer.resourceCount
		overflowCounter.text = "Ovfl%.2f" %  (boiler.steamBuffer.resourceCount / boiler.steamBuffer.overflowLimit)
	
func registerObject(object: Node3D):
	if object is SteamBoiler:
		boiler = object

func destroyRepresentingUI(object: Node3D):
	if object == boiler:
		boiler = null
		queue_free()
	
