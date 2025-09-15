extends Node2D

# Define the correct neuron sequence
@export var correct_order = ["Neuron1", "Neuron3", "Neuron4"]
var player_order: Array = []

# References to player and collectible
var player
var collectible

func _ready() -> void:
	# Get references
	player = $OnTheGround/Player
	collectible = $OnTheGround/CollectibleItem
	if collectible:
		collectible.visible = false  # hide collectible initially

	# Connect neuron buttons
	$Neuron1.pressed.connect(func(): _on_neuron_pressed("Neuron1"))
	$Neuron2.pressed.connect(func(): _on_neuron_pressed("Neuron2"))
	$Neuron3.pressed.connect(func(): _on_neuron_pressed("Neuron3"))
	$Neuron4.pressed.connect(func(): _on_neuron_pressed("Neuron4"))

func _on_neuron_pressed(neuron_name: String) -> void:
	player_order.append(neuron_name)
	var idx = player_order.size() - 1

	# Wrong neuron clicked
	if player_order[idx] != correct_order[idx]:
		await _flash_wrong(neuron_name)
		player_order.clear()
		return

	# Correct neuron clicked
	await _flash_correct(neuron_name)

	# Sequence complete
	if player_order.size() == correct_order.size():
		player_order.clear()
		_spawn_collectible()

# Flash neuron red for wrong
func _flash_wrong(neuron_name: String) -> void:
	var neuron = get_node_or_null(neuron_name) as TextureButton
	if neuron == null:
		return
	var old_color = neuron.modulate
	neuron.modulate = Color(1, 0, 0)  # red
	await get_tree().create_timer(0.5).timeout
	neuron.modulate = old_color

# Flash neuron green for correct
func _flash_correct(neuron_name: String) -> void:
	var neuron = get_node_or_null(neuron_name) as TextureButton
	if neuron == null:
		return
	var old_color = neuron.modulate
	neuron.modulate = Color(0, 1, 0)  # green
	await get_tree().create_timer(0.3).timeout
	neuron.modulate = old_color

# Spawn the collectible manually when sequence is complete
func _spawn_collectible() -> void:
	if collectible == null or player == null:
		return
	collectible.visible = true
	# Optionally place it in front of the player
	collectible.global_position = player.global_position + Vector2(50, 0)
