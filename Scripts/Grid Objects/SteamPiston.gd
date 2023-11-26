extends StaticBody3D

class_name SteamPiston

@export var steamCapacity: float
@export var steamToPowerTransferSpeed: float
# power capacity is just 0, it makes no sense to store the produced energy, it is immidiately transferred
# this will only accept as much as it can, and if it's too high, it may break down
@export var steamReceiveLimit: float # per second

@export var outputSocket: OutputSocket

# TODO: investigate about how pistons work, what happens if not enough steam or too much steam gets input.
# for now: less steam == less power, just a normal linear function
# https://www.youtube.com/watch?v=9mhYnQGZJuM
# https://www.youtube.com/watch?v=JRdTPNApfuk

var steam: float = 0.0
var power: float = 0.0

func _ready() -> void:
	# these 2 lines repeat in every debugNode clause -> maybe we can extract it somewhere?
	assert(outputSocket != null, "Steam piston requires an OutputSocket!")
	if $DebugNode != null:
		var debugNode: DebugNode = $DebugNode
		debugNode.addTextValueGetter(func():return "Steam:%.2f" % steam + "/%.2f" % steamCapacity)
		debugNode.addTextValueGetter(func():return "Power:%.2f" % power)

func _physics_process(delta: float) -> void:
	# for now, let's assume 1-1 steam-power transfer ratio and that we use up all the steam
	power = steamToPowerTransferSpeed * delta * steam
	steam = 0.0
	outputSocket.sendResourcesToConnectedInputSocket(power)

## This returns the number of accepted resources
func receiveResources(steamInflow: float) -> float:
	var acceptMax = get_physics_process_delta_time() * steamReceiveLimit
	var overflow = max(0, steamInflow - get_physics_process_delta_time() * steamReceiveLimit)
	steam += min(steamInflow, acceptMax)
	return steamInflow - overflow
#	var overflow = max(0,(heat + heatInflow) - heatCapacity)
#	heat = min(heat + heatInflow, heatCapacity)
#	return heatInflow - overflow
