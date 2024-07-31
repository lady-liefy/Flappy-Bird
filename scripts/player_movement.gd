### player_movement.gd
extends CharacterBody2D
class_name PlayerMovement

const JUMP_FORCE = -320.0
const GRAVITY = 850.0
const MAX_SPEED = 400.0
const ROT_SPEED = 2

@onready var collision_shape_2d = $CollisionShape2D

func _ready() -> void:
	self.velocity = Vector2.ZERO
	self._initialize_signals()

func _initialize_signals() -> void:
	Events.game_paused.connect(_on_game_paused)
	Events.game_resumed.connect(_on_game_resumed)
	Events.game_over.connect(die)

func _on_game_paused() -> void:
	self.set_enabled(false)
	get_tree().paused = true

func _on_game_resumed() -> void:
	self.set_enabled(true)
	get_tree().paused = false

# ---------------------- PHYSICS PROCESS -----------------------------------------------
func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump()
	
	## Fall continuously because gravity
	self.velocity.y += GRAVITY * delta
	
	## Compare current velocity vs MAX_SPEED
	self.velocity.y = min(self.velocity.y, MAX_SPEED)
	
	if move_and_collide(self.velocity * delta, true):
		Events.emit_signal("game_over")
	else:
		move_and_collide(self.velocity * delta)
		rotate_player()

func jump() -> void:
	self.velocity.y = JUMP_FORCE
	self.rotation = deg_to_rad(-30)

func rotate_player() -> void:
	# Rotate downwards when falling
	if self.velocity.y > 0 && rad_to_deg(self.rotation) < 90:
		self.rotation += ROT_SPEED * deg_to_rad(1)
	# Rotate upwards when climbing
	if self.velocity.y < 0 && rad_to_deg(self.rotation) > -30:
		self.rotation -= ROT_SPEED * deg_to_rad(1)

func set_enabled(value: bool) -> void:
	if value:
		self.collision_shape_2d.set_deferred("disabled", false) # dis/enable collision
		self.set_process_unhandled_input(true) # idk what this does <3
		self.set_physics_process(true) # turn on/off _physics_process
		
	else:
		self.collision_shape_2d.set_deferred("disabled", true)
		self.set_process_unhandled_input(false)
		self.set_physics_process(false)

func die() -> void:
	self.set_enabled(false)
	get_tree().paused = true
#	self.animation_player.play("die")
#	self.death_sound.play()
