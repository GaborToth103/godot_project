class_name PlayerMovementData
extends Resource
 
@export_group("Base Properties")
@export var speed: float = 200.0
@export var acceleration: float = 600.0
@export var friction: float = 1000.0
@export var jump_velocity: float = -450.0
@export var gravity_scale: float = 0.8
@export var air_resistance: float = 200.0
@export var air_acceleration: float = 400.0

@export_group("Dash")
@export var dash_time: float = 0.1  # Duration of the dash in seconds
@export var dash_speed: float = 3000  # Speed during the dash
@export var dash_cooldown: float = 0.5  # Cooldown between dashes
@export var dash_timer: float = 0.0  # Timer to track the dash duration
@export var dash_cooldown_timer: float = 0.0  # Timer to track the cooldown
