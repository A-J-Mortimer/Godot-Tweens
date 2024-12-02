####
# THIS SCRIPT IS PLACED IN THE PARENT NODE
# https://github.com/A-J-Mortimer/Godot-Tweens/
####

extends Node2D

var debug = true
var tween_respawn_delay = 2

# Shared debugging function
func print_tree_nodes(node: Node = self) -> void:
	print(node.name)
	for child in node.get_children():
		print_tree_nodes(child)

# Clone function shared by all children
func object_clone(original, clone_unique):
	if not clone_unique:
		original.set_deferred("monitoring", false)  # Prevent triggering during tween
		var new_clone = original.duplicate()
		original.get_parent().add_child.call_deferred(new_clone)
		new_clone.position = original.position
		object_toggle("hide", new_clone)
		return new_clone
	return null

# Shared toggle function
func object_toggle(toggle_state, object):
	if toggle_state == "show":
		object.visible = true
		object.monitoring = true
	else:
		object.visible = false
		object.monitoring = false

# Shared tween handling
func tween_respawner(tween, tween_duration, object, clone, clone_unique):
	await get_tree().create_timer(tween_duration).timeout # Wait for the tween to finish
	object_toggle("hide", object) # Tween finished, hide object
	await get_tree().create_timer(tween_respawn_delay).timeout # Wait for respawn delay
	object_toggle("show", clone) # Show clone object
	clone_unique = true
	object.queue_free() # Destroy original
	return clone_unique
