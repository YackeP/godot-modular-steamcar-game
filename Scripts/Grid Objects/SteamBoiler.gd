extends GridComponent

class_name SteamBoiler

@export var heatToSteamTransferRatio: float = 0.9
@export var heatConsumptionSpeed: float = 0.9 # speed per second

@export var outputSocket: OutputSocket

@export var heatBuffer: ResourceBuffer
@export var steamBuffer: OverflowableResourceBuffer

func _ready() -> void:
	steamBuffer.overflow_limit_reached.connect(explode)

func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 heat-steam transfer ratio	var heatTransferedToSteam = min(heat, heatToSteamTransferSpeed * delta)
	var maxHeatConsumed = heatConsumptionSpeed * delta
	var possibleHeatConsumed = min(maxHeatConsumed, heatBuffer.resourceCount)
	
	var steamProduced = possibleHeatConsumed * heatToSteamTransferRatio
	var refusedSteam = steamProduced - steamBuffer.increaseResources(steamProduced)
	var refusedHeat = refusedSteam / heatToSteamTransferRatio
	
	heatBuffer.reduceResources(possibleHeatConsumed + refusedHeat)
	steamBuffer.reduceResources(outputSocket.sendResourcesToConnectedInputSocket(steamBuffer.resourceCount))
	
	if steamBuffer.resourceCount > steamBuffer.resourceCapacity - 0.01:
		GameStateEvents.engine_exploded.emit()
		queue_free()

## This returns the number of accepted resources
func increaseResources(heatInflow: float) -> float:
	return heatBuffer.increaseResources(heatInflow)

func explode():
	#if steamBuffer.resourceCount > steamBuffer.resourceCapacity - 0.01:
	Logger.warn("Steam Boiler exploded!")
	GameStateEvents.engine_exploded.emit()
	queue_free()
	
