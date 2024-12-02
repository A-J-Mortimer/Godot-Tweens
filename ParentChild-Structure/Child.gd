####
# THIS SCRIPT IS PLACED IN THE CHILD OBJECTS
# https://github.com/A-J-Mortimer/Godot-Tweens/
####

extends Area2D

var clone
var clone_unique = false

func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		if body == self or body == clone:
			return
		var parent = get_parent()  # Access the parent node
		if parent.debug:
			parent.print_tree_nodes(get_parent())
			print("###############################"+"\n")
		clone = parent.object_clone(self, clone_unique)  # Call parent's clone function
		clone_unique = true
		tween_x_or_y("y", -20, 1)

func tween_x_or_y(axis, pixels, tween_duration):
	var tween = get_tree().create_tween()  # Create a tween
	tween.tween_property(self, "position:" + axis, pixels, tween_duration)
	# Await the async function to ensure it runs properly
	await get_parent().tween_respawner(tween, tween_duration, self, clone, clone_unique)
