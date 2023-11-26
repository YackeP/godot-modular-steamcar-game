extends StaticBody3D

class_name SteamBoiler

@export var steamCapacity: float
@export var heatCapacity: float
@export var heatToSteamTransferSpeed: float

@export var outputSocket: OutputSocket

var steam: float = 0.0
## updated from the inputSlot
var heat: float = 0.0

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "Heat:%.2f" % heat + "/%.2f" % heatCapacity)
		debugNode.addTextValueGetter(func():return "Steam:%.2f" % steam + "/%.2f" % steamCapacity)

# need to figur out how to make this universal 
# or this might not be a good fit to be universal as well
# ResourceProducer might be a good fit for this sort of method
#func inputSocketConnected_impl(startHeatInputRate: float) -> void:
#	heatInputRate = startHeatInputRate
#
#func inputSocketUpdated(newHeatInputRate: float) -> void:
#	heatInputRate = newHeatInputRate

func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 heat-steam transfer ratio
	var heatTransferedToSteam = min(heat, heatToSteamTransferSpeed * delta)
	var steamProduced = heatTransferedToSteam
	heat = heat - heatTransferedToSteam
	steam = min(steam + steamProduced, steamCapacity)
	steam = max(0, steam - outputSocket.sendResourcesToConnectedInputSocket(steam))

## This returns the number of accepted resources
func receiveResources(heatInflow: float) -> float:
	var overflow = max(0,(heat + heatInflow) - heatCapacity)
	heat = min(heat + heatInflow, heatCapacity)
	return heatInflow - overflow

func getHeat() -> float:
	return heat
	
func getSteam() -> float:
	return steam
