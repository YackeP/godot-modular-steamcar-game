# Project idea

This is a prototype of a driving game with grid-based engine customization

The goal of this project was to get accustomed to Godot and learn how to use it's systems.

Further development of this project would require a better, more engaging and deeper driving model which has multiple parameters modifiable at runtime. As such, **this project has been put on hold.** It is possible I will return to it when I develop a driving model.

## Game design considerations

The main point of the design is allowing the player to customize the engine to make it more fit for certain tasks. Be it more torque for clibing up a steep hill, high top speed for driving along a long stretch of road, or quick acceleration for a curvy road.

Another idea that flows from this is taking a part of the control away from the player. The engine has it's own rules. If designed incorrectly, the engine might overheat, or run out of steam at an inopportune moment. The player can't interact with the engine apart from taking parts in or out. Although a mechanic where we could modify some state of the engine, like opening an emergency valve to let out some steam from the boilers might also be added.

## Implementation considerations

The engine components should be as modular as possible to facilitate new engine components. Each components is made out of:

- Resource Buffer - used for holding resources
- Input Socket - for accepting output and passing it to the connected resource buffer
- Output Socket - for sending outputs to the connected input socket of another component

The main component of the engine component extends GridComponent and implement all the logic that is specific to that component.

## Engine mechanics

The engine consists of 4 elements.

1. Coal furnace - produces heat
2. Steam boiler - takes heat, produces steam
3. Power piston - takes steam, produces power
4. Output socket - takes power, changes engine parameter

Right now, the output sockets only changes the engine power - how quickly it accelerates.

Each of these elements may occupy multiple grid spaces, and have output and input sockets that are only present in some of these spaces, and are each directed towards other spaces. For example, the power piston inputs steam in the space that has the cylinder, and outputs it around the drivewheel. Right now the sockets are not visualized in any way apart from using the Visible Collision Shapes in the Debug menu. This could be an idea for an improvement in the future.

Additionally, if the steam boiler gets allowed to build up too much steam = pressure, it will explode, sending the car flying.

## Godot Version

Project was made with Godot 4.2 using gdscript.

## Controls

Game has 2 modes, which you can switch between using **Enter**: 
1. Vehicle controls:
- Standard **WASD** controls for steering and acceleration 
-- **Spacebar**: handbreak
2. Grid placement:
- **1,2,3**: change the engine component
- **Left-click**: place a component
- **Right-click**: remove a component
- **R**: rotate a component (only before placing)

# Used Assets

Some free assets have been used for this project:
- cartoon banana car by Felipe Lujan-Bear [CC-BY] via Poly Pizza
- Steamer by Kenney from Poly Pizza
- Modular PipeWork pack by Siris Pendrake
