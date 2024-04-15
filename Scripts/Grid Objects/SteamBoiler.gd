extends GridComponent

class_name SteamBoiler

@export var heatToSteamTransferRatio: float = 0.9
@export var heatConsumptionSpeed: float = 0.9 # speed per second

@export var _outputSocket: OutputSocket

@export var _heatBuffer: ResourceBuffer
@export var _steamBuffer: OverflowableResourceBuffer

@export var explodinessRaiseRate: float = 30.0
@export var explodinessDecayRate: float = 10.0

# TODO: make the overflow control this value 
#    - this starts ticking up one the overflow is reached
#    - then, if this value reaches 100, make the boiler explode
var overflowExplodiness: float = 0.0

func _ready() -> void:
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "Explodiness: %.2f" % overflowExplodiness)

func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 heat-steam transfer ratio	var heatTransferedToSteam = min(heat, heatToSteamTransferSpeed * delta)
	var maxHeatConsumed = heatConsumptionSpeed * delta
	var possibleHeatConsumed = min(maxHeatConsumed, _heatBuffer.resourceCount)
	
	var steamProduced = possibleHeatConsumed * heatToSteamTransferRatio
	var refusedSteam = steamProduced - _steamBuffer.increaseResources(steamProduced)
	var refusedHeat = refusedSteam / heatToSteamTransferRatio
	
	_heatBuffer.reduceResources(possibleHeatConsumed + refusedHeat)
	_steamBuffer.reduceResources(_outputSocket.sendResourcesToConnectedInputSocket(_steamBuffer.resourceCount))
	
	if (_steamBuffer.isOverflown()):
		overflowExplodiness += pow(_steamBuffer.getOverflowRate(), 2) * explodinessRaiseRate * delta
	else:
		# can fit the >0 restriction into a custom setter
		overflowExplodiness = max(0, overflowExplodiness - explodinessRaiseRate * delta)
	
	if (overflowExplodiness >= 100):
		# FIXME the boiler should not know about the global events, this should be called by the engine's controller (GridPlacementControler)
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
	
func getSteamLevel() -> float:
	return _steamBuffer.resourceCount / _steamBuffer.overflowLimit
	
func getSteamOverflowRate() -> float:
	return _steamBuffer.getOverflowRate();

