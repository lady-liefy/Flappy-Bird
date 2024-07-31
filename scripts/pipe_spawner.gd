extends Node
class_name PipeManager

var pipe_pair_scn = preload("res://scenes/pipe_pair.tscn")

@export var pipe_speed = -150

@onready var spawn_timer = $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.autostart = true
	self._initialize_signals()
	start_spawning_pipes()

func _initialize_signals() -> void:
	spawn_timer.timeout.connect(spawn_pipe)
	
	Events.game_paused.connect(on_game_paused)
	Events.game_over.connect(on_game_over)
	Events.game_restarted.connect(on_game_restarted)
	Events.game_resumed.connect(on_game_resumed)
	Events.pipe_offscreen.connect(delete_pipe)

func set_enabled(value: bool) -> void:
	if value:
		if not spawn_timer.autostart or spawn_timer.is_stopped():
			spawn_timer.start()
		if spawn_timer.paused:
			spawn_timer.paused = false
	else:
		spawn_timer.paused = true

func on_game_paused() -> void:
	self.set_enabled(false)

func on_game_over() -> void:
	self.set_enabled(false)

func on_game_restarted() -> void:
	self.set_enabled(true)

func on_game_resumed() -> void:
	self.set_enabled(true)

func start_spawning_pipes() -> void:
	self.set_enabled(true)

func spawn_pipe() -> void:
	var pipe = pipe_pair_scn.instantiate() as PipePair
	add_child(pipe)
	
	var viewport_rect = get_viewport().get_camera_2d().get_viewport_rect()
	pipe.position.x = viewport_rect.end.x
	
	randomize()
	var half_height = viewport_rect.size.y / 2
#	get_window().size.y * 0.2
	pipe.position.y = randf_range(viewport_rect.size.y / 2, viewport_rect.size.y * 0.65 - half_height)
	
func delete_pipe(area : PipePair) -> void:
	print(str(area))
	pass
#	for pipe in self.get_children():
#		if pipe is PipePair:
#			pipe.queue_free()
#			return
