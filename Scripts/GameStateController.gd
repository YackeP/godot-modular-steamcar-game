extends Node3D

class_name GameStateController
# can this sort of management be done instead using signals and events?

@export var drivingWorldController: DrivingWorldController
@export var gridPlacementController: GridPlacementController

var _gameState: GameState = GameState.DRIVING

# delta key, taken from the pong tutorial
const _RESET_DELTA_KEY = 0.0
const _MAX_KEY_TIME = 0.3
var _deltaKeyPress = _RESET_DELTA_KEY

func _ready() -> void:
	gridPlacementController.disable()
	drivingWorldController.enable()


func _physics_process(delta: float) -> void:
	_deltaKeyPress += delta
	
func _input(event):
	if event is InputEventKey:
		if event.keycode==KEY_ENTER && _deltaKeyPress > _MAX_KEY_TIME:
			_deltaKeyPress = _RESET_DELTA_KEY
			if _gameState == GameState.DRIVING:
				_gameState = GameState.ENGINE_BUILDING
				drivingWorldController.disable()
				gridPlacementController.enable()
			elif _gameState == GameState.ENGINE_BUILDING:
				_gameState = GameState.DRIVING
				drivingWorldController.enable()
				gridPlacementController.disable()

enum GameState {
	UNDEFINED,
	DRIVING,
	ENGINE_BUILDING
}
