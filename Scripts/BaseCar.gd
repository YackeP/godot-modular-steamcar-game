extends VehicleBody3D

class_name BaseCar

# taken from https://github.com/HotHead007/Car-Demo

@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var BASE_ENGINE_FORCE_VALUE: float = 40

@export var rigidBody: RigidBody3D

# right now this is set up to just play the explosion sound
@export var explosionPlayer: AudioStreamPlayer3D

var explosionEffect = preload("res://Scenes/Explosion.tscn")

var _engineForceValue: float = 40

func setEngineBonusPower(bonusPower: float):
	_engineForceValue = BASE_ENGINE_FORCE_VALUE + (bonusPower * 1000)

func _physics_process(delta):
	var speed = linear_velocity.length()*Engine.get_frames_per_second()*delta
	traction(speed)
	$Hud/speed.text=str(round(speed*3.8))+"  KMPH"
	$Hud/spedometer.updateGauge(round(speed*3.8))
	$Hud/power.text="PWR:" + str(_engineForceValue)

	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	steer_target *= STEER_LIMIT	
	
	# ADDED by me
	if Input.is_key_pressed(KEY_X):
		var angle = deg_to_rad(randf_range(0, 30))
		var impulseForce = Vector3(sin(angle), cos(angle), tan(angle)) * 2000
		rigidBody.apply_impulse(impulseForce)
		
		var effect = explosionEffect.instantiate()
		add_child(effect)
		effect.position = position
	
		explosionPlayer.play()

	
	if Input.is_action_pressed("ui_down"):
	# Increase engine force at low speeds to make the initial acceleration faster.

		if speed < 20 and speed != 0:
			engine_force = clamp(_engineForceValue * 3 / speed, 0, 300)
		else:
			engine_force = _engineForceValue
	else:
		engine_force = 0
	if Input.is_action_pressed("ui_up"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(_engineForceValue * 10 / speed, 0, 300)
			else:
				engine_force = -_engineForceValue
		else:
			brake = 1
	else:
		brake = 0.0
		
	if Input.is_action_pressed("ui_select"):
		brake=3
		$Wheel2.wheel_friction_slip=0.8
		$Wheel3.wheel_friction_slip=0.8
	else:
		$Wheel2.wheel_friction_slip=3
		$Wheel3.wheel_friction_slip=3
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)



func traction(speed):
	apply_central_force(Vector3.DOWN*speed)




