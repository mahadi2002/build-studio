# Robotics
tier: 3 | sources: ROS 2 documentation (docs.ros.org); Gazebo and Webots official documentation | updated: 2026-11-26

## Triggers
- Robots: ROS 2 nodes, motor control, PID, sensor fusion, navigation, arms, drones, robot simulation in Gazebo or Webots.
- Not for pure sensor logging (embedded.md).

## Scope check
- Can do here: ROS 2 nodes in WSL2 or Docker, simulation in Gazebo or Webots, PID and kinematics unit tests, Nav2 in simulation. ROS 2 on native Windows is limited (uncertain).
- Needs hardware, certification or experts: motors, drivers, batteries, sensors and a robot frame (buying is gate G3). Tuning on a real robot differs from simulation. Industrial or human-near robots need safety experts.
- Safety and regulatory risks: moving parts, pinch points and fast motors can injure people. Lithium batteries can ignite. Drones have flight rules and may need approval (uncertain).

## Role-specific rules
- Simulate first; move to hardware only after I approve, with wheels lifted or the robot on blocks.
- Add a hardware emergency stop and software velocity and torque limits before any motor test.
- Add a command timeout so the robot stops when a node dies or messages stop.
- Keep humans outside the reach of the robot during tests.

## Definition of done
- Simulation run shown with the stop and timeout tests passing.
- Hardware tests either done with the safety steps logged, or marked "not run".
