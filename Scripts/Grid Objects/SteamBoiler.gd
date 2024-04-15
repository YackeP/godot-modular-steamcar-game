extends GridComponent

class_name SteamBoiler

@export var heatToSteamTransferRatio: float = 0.9
@export var heatConsumptionSpeed: float = 0.9 # speed per second

@export var _outputSocket: OutputSocket

@export var _heatBuffer: ResourceBuffer
@export var _steamBuffer: OverflowableResourceBuffer

func _ready() -> void:
	_steamBuffer.overflow_limit_reached.connect(explode)

func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 heat-steam transfer ratio	var heatTransferedToSteam = min(heat, heatToSteamTransferSpeed * delta)
	var maxHeatConsumed = heatConsumptionSpeed * delta
	var possibleHeatConsumed = min(maxHeatConsumed, _heatBuffer.resourceCount)
	
	var steamProduced = possibleHeatConsumed * heatToSteamTransferRatio
	var refusedSteam = steamProduced - _steamBuffer.increaseResources(steamProduced)
	var refusedHeat = refusedSteam / heatToSteamTransferRatio
	
	_heatBuffer.reduceResources(possibleHeatConsumed + refusedHeat)
	_steamBuffer.reduceResources(_outputSocket.sendResourcesToConnectedInputSocket(_steamBuffer.resourceCount))
	
	if _steamBuffer.resourceCount > _steamBuffer.resourceCapacity - 0.01:
		GameStateEvents.engine_exploded.emit()
		queue_free()

## This returns the number of accepted resources
func increaseResources(heatInflow: float) -> float:
	return _heatBuffer.increaseResources(heatInflow)

func explode():
	#if _steamBuffer.resourceCount > _steamBuffer.resourceCapacity - 0.01:
	Logger.warn("Steam Boiler exploded!")
	GameStateEvents.engine_exploded.emit()
	queue_free()
	
