extends Node2D

# ----- Customize your sequence here -----
@export var correct_order = ["Neuron1", "Neuron3", "Neuron4"]
var player_order: Array = []

# Called when scene is ready
func _ready() -> void:
	# Connect neurons to our handler
	$Neuron1.pressed.connect(func(): _on_neuron_pressed("Neuron1"))
	$Neuron2.pressed.connect(func(): _on_neuron_pressed("Neuron2"))
	$Neuron3.pressed.connect(func(): _on_neuron_pressed("Neuron3"))
	$Neuron4.pressed.connect(func(): _on_neuron_pressed("Neuron4"))
	
	# Make collectible invisible at start
	var collectible = $OnTheGround/CollectibleItem
	if collectible:
		collectible.visible = false

# ----- Neuron click handler -----
func _on_neuron_pressed(neuron_name: String) -> void:
	player_order.append(neuron_name)
	var idx = player_order.size() - 1

	# Wrong neuron
	if player_order[idx] != correct_order[idx]:
		await _flash_wrong(neuron_name)
		player_order.clear()
		return
	# Correct neuron
	await _flash_correct(neuron_name)
	await _shoot_signal_to(neuron_name)

	# Sequence complete
	if player_order.size() == correct_order.size():
		player_order.clear()
		_spawn_collectible()

# ----- Flash red for wrong -----
func _flash_wrong(neuron_name: String) -> void:
	var neuron = get_node_or_null(neuron_name) as TextureButton
	if neuron == null:
		return
	var old_color = neuron.modulate
	neuron.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.5).timeout
	neuron.modulate = old_color

# ----- Flash green for correct -----
func _flash_correct(neuron_name: String) -> void:
	var neuron = get_node_or_null(neuron_name) as TextureButton
	if neuron == null:
		return
	var old_color = neuron.modulate
	neuron.modulate = Color(0, 1, 0)
	await get_tree().create_timer(0.3).timeout
	neuron.modulate = old_color

# ----- Fire signal projectile from player -----
func _shoot_signal_to(neuron_name: String) -> void:
	var neuron = get_node_or_null(neuron_name) as Control
	var player = $OnTheGround/Player
	if neuron == null or player == null:
		return

	var projectile = $Signal.duplicate()
	projectile.global_position = player.global_position
	add_child(projectile)

	var start_pos = projectile.global_position
	var end_pos = neuron.get_global_position()
	var t = 0.0
	var duration = 0.3
	while t < duration:
		projectile.global_position = start_pos.lerp(end_pos, t / duration)
		await get_tree().process_frame
		t += get_process_delta_time()

	projectile.global_position = end_pos
	await get_tree().create_timer(0.05).timeout
	projectile.queue_free()

# ----- Spawn collectible automatically -----
func _spawn_collectible() -> void:
	var collectible = $OnTheGround/CollectibleItem
	var player = $OnTheGround/Player
	if collectible == null or player == null:
		return

	# Make visible and place in front of player
	collectible.global_position = player.global_position + Vector2(50, 0)
	collectible.visible = true
