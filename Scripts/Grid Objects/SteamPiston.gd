extends GridComponent

class_name SteamPiston

@export var steamCapacity: float = 5.0
@export var steamToPowerTransferRatio: float = 0.9 # 1 steam = x power 
@export var steamConsumptionSpeed: float = 0.9 # speed per second
# power capacity is just 0, it makes no sense to store the produced energy, it is immidiately transferred
# this will only accept as much as it can, and if it's too high, it may break down

@export var _outputSocket: OutputSocket
@export var _steamBuffer: ResourceBuffer

# TODO: investigate about how pistons work, what happens if not enough steam or too much steam gets input.
# for now: less steam == less power, just a normal linear function
# https://www.youtube.com/watch?v=9mhYnQGZJuM
# https://www.youtube.com/watch?v=JRdTPNApfuk


func _ready() -> void:
	# these 2 lines repeat in every debugNode clause -> maybe we can extract it somewhere?
	assert(_outputSocket != null, "Steam piston requires an OutputSocket!")

func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 steam-power transfer ratio and that we use up all the steam
	var maxSteamConsumed = steamConsumptionSpeed * delta
	var possibleSteamConsumed = min(maxSteamConsumed, _steamBuffer.resourceCount)
	
	var powerProduced = possibleSteamConsumed * steamToPowerTransferRatio
	# we don't reject any power, we just accept it all
	
	_steamBuffer.reduceResources(possibleSteamConsumed)
	_outputSocket.sendResourcesToConnectedInputSocket(powerProduced)

## This returns the value of accepted resources
func increaseResources(steamInflow: float) -> float:
	return _steamBuffer.increaseResources(steamInflow)
