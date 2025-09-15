extends Node2D  # or the type your projectile already uses

# List of positions to move along (set by grace_neuronnetwork.gd)
var path = []
var current_target = 0
var speed = 200  # pixels per second, adjust to make it faster/slower

func _process(delta):
	if current_target < len(path):
		var target_pos = path[current_target]
		var direction = (target_pos - position).normalized()
		position += direction * speed * delta

		# Check if we reached the target tile
		if position.distance_to(target_pos) < 2:
			position = target_pos
			current_target += 1
