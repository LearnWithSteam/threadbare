extends Node
class_name FillGameLogic

signal goal_reached

@export var intro_dialogue: DialogueResource

# Track target order and progress
var target_order: Array[int] = [1, 2, 3]  # IDs of targets in correct order
var current_index: int = 0

func _ready() -> void:
	# Show intro dialogue if any
	if intro_dialogue:
		var player: Player = get_tree().get_first_node_in_group("player")
		DialogueManager.show_dialogue_balloon(intro_dialogue, "", [self, player])
		await DialogueManager.dialogue_ended

	# Connect all target signals
	#for target: Target in get_tree().get_nodes_in_group("targets"):
		#target.completed.connect(_on_target_completed)

	# Start enemy throwing if you have throwing_enemy group
	get_tree().call_group("throwing_enemy", "start")

func _on_target_completed(target_id: int) -> void:
	# Only accept correct order
	if target_id != target_order[current_index]:
		return  # ignore wrong hits; Target.gd handles flashing red

	current_index += 1

	if current_index >= target_order.size():
		# All targets hit in correct order
		get_tree().call_group("throwing_enemy", "remove")
		get_tree().call_group("projectiles", "remove")
		var player: Player = get_tree().get_first_node_in_group("player")
		if player:
			player.mode = Player.Mode.COZY
		goal_reached.emit()
