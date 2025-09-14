# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
@tool
class_name SoundOnPlayerHit
extends Area2D

@export_category("Sounds")
@export var player_touch_sound_stream: AudioStream:
	set = _set_player_touch_sound_stream

@onready var interact_area: InteractArea = %InteractArea
@onready var _player_touch_sound: AudioStreamPlayer2D = $CorrectBling


func _set_sprite_frames(new_sprite_frames: SpriteFrames) -> void:
	if not is_node_ready():
		return
	update_configuration_warnings()



func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array = []
	return warnings


func _ready() -> void:
	body_entered.connect(_on_entered)
	body_exited.connect(_on_exited)

func _on_entered(_body: Node2D) -> void:
	if not _player_touch_sound.playing:
		_player_touch_sound.play()

func _on_exited(_body: Node2D) -> void:
	if _player_touch_sound.playing:
		_player_touch_sound.stop()

	
func _set_player_touch_sound_stream(new_value: AudioStream) -> void:
	player_touch_sound_stream = new_value
	if not is_node_ready():
		await ready
	_player_touch_sound.stream = new_value
