extends GridComponent

class_name SteamBoiler

@export var heatToSteamTransferRatio: float = 0.9
@export var heatConsumptionSpeed: float = 0.9 # speed per second

@export var outputSocket: OutputSocket

@export var heatBuffer: ResourceBuffer
@export var steamBuffer: ResourceBuffer


func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 heat-steam transfer ratio	var heatTransferedToSteam = min(heat, heatToSteamTransferSpeed * delta)
	var maxHeatConsumed = heatConsumptionSpeed * delta
	var possibleHeatConsumed = min(maxHeatConsumed, heatBuffer.resourceCount)
	
	var steamProduced = possibleHeatConsumed * heatToSteamTransferRatio
	var refusedSteam = steamProduced - steamBuffer.increaseResources(steamProduced)
	var refusedHeat = refusedSteam / heatToSteamTransferRatio
	
	heatBuffer.reduceResources(possibleHeatConsumed + refusedHeat)
	steamBuffer.reduceResources(outputSocket.sendResourcesToConnectedInputSocket(steamBuffer.resourceCount))

## This returns the number of accepted resources
func increaseResources(heatInflow: float) -> float:
	return heatBuffer.increaseResources(heatInflow)
