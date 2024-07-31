extends Node2D
class_name PipePair

@export var scroll_speed : float = 300.0

@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe

var direction := Vector2(-1.0, 0.0)


func _ready() -> void:
	self._initialize_signals()
	self.set_enabled(true)

func _initialize_signals() -> void:
	Events.game_paused.connect(on_game_paused)
	Events.game_over.connect(on_game_over)
	Events.game_restarted.connect(on_game_restarted)
	Events.game_resumed.connect(on_game_resumed)

func on_game_paused() -> void:
	self.set_enabled(false)
	
func on_game_over() -> void:
	self.set_enabled(false)

func on_game_restarted() -> void:
	self.set_enabled(true)
	
func on_game_resumed() -> void:
	self.set_enabled(true)

func _physics_process(delta : float) -> void:
	self.global_position += direction * scroll_speed * delta

func _on_scored_body_exited(body : Node2D) -> void:
	if body.get_parent() is Player:
		Events.emit_signal("obstacle_zone_passed")

func set_enabled(value: bool) -> void:
	if value:
		self.set_physics_process(true)
	else:
		self.set_physics_process(false)
