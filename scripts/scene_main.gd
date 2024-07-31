### SceneMain.gd
extends Node
class_name SceneMain

@onready var scene_to_load : PackedScene

func _ready() -> void:
	self._initialize_signals()

func _initialize_signals() -> void:
	Events.game_restarted.connect(self.on_game_restarted)

func on_game_restarted() -> void:
	get_tree().paused = false
#	Preloads.scene_to_load = load("res://scenes/world.tscn")
#	get_tree().change_scene_to_packed(self.scene_to_load)
	
	ScoreManager.set_current_score(0)
	get_tree().reload_current_scene()

func _on_floor_body_entered(body : Node2D) -> void:
	if body.get_parent() is Player:
		body.die()
		Events.emit_signal("game_over")

func _on_clear_zone_area_exited(area):
	if area.get_parent() is PipePair:
		Events.emit_signal("pipe_offscreen", area.get_parent())
