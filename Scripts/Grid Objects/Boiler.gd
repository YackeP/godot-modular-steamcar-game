extends StaticBody3D

class_name SteamBoiler

@export var heatToSteamTransferRatio: float = 1.0
@export var heatConsumptionSpeed: float = 1.0 # speed per second

@export var outputSocket: OutputSocket

@export var heatBuffer: ResourceBuffer
@export var steamBuffer: ResourceBuffer


func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 heat-steam transfer ratio	var heatTransferedToSteam = min(heat, heatToSteamTransferSpeed * delta)
	var maxHeatConsumed = heatConsumptionSpeed * delta
	var possibleHeatConsumed = min(maxHeatConsumed, heatBuffer.resourceCount)
	
	var steamProduced = possibleHeatConsumed * heatToSteamTransferRatio
	var refusedSteam = steamProduced - steamBuffer.receiveResources(steamProduced)
	var refusedHeat = refusedSteam / heatToSteamTransferRatio
	
	heatBuffer.updateResources(heatBuffer.resourceCount - possibleHeatConsumed + refusedHeat) # FIXME: this can be just 1 method	
	steamBuffer.updateResources(steamBuffer.resourceCount - outputSocket.sendResourcesToConnectedInputSocket(steamBuffer.resourceCount))

## This returns the number of accepted resources
func receiveResources(heatInflow: float) -> float:
	return heatBuffer.receiveResources(heatInflow)
