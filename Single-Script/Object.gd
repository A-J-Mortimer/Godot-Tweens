###
# YOU CAN APPLY THIS SCRIPT DIRECTLY INTO ANY OBJECT TO MAKE IT TWEEN
###

extends Area2D

var debug = false

var clone
var clone_unique = false
var tween_respawn_delay = 2
# Called when the node enters the scene tree for the first time.
func _ready() - void
	if debug
		print(Coin has spawned)
	pass # Replace with function body.

# Debugging function that retrieves and prints child elements from specified node
func print_tree_nodes(node Node = self) - void
	print(node.name)
	for child in node.get_children()
		print_tree_nodes(child)

func _on_body_entered(body) - void
	if body.is_in_group(Player)
		if body == self or body == clone	
			return
		if debug
			print(collided)
			print_tree_nodes(get_tree().root)
			print(###############################)
		clone = object_clone()
		tween_x_or_y(y, -20, 1) # axis, units, tween time

		
func object_clone()
	if not clone_unique
		if debug
			print(cloning)
		# Without setting monitoring to false, the game will crash if coin is touched twice before tween ends
		set_deferred(monitoring, false) # Ensures original nor clone can be triggered again untinl tween finishes
		var new_clone = self.duplicate()  # Creates a copy of the current node
		# Add the cloned object to the same parent
		get_parent().add_child.call_deferred((new_clone)) # we use .call_deferred to make sure it doesn´t obstruct query flush
		new_clone.position = self.position  # Set its position or any other properties
		object_toggle(hide, new_clone)
		clone_unique = true
		return new_clone
		
func object_toggle(toggle_state, object)
	if toggle_state == show
		object.visible = true 
		object.monitoring = true
	else
		object.visible = false
		object.monitoring = false

func tween_respawner(tween, tween_duration)
	await get_tree().create_timer(tween_duration).timeout # Wait for the tween to finish
	object_toggle(hide, self) # Tween finished, hide object
	# We wait for the respawn delay 
	await get_tree().create_timer(tween_respawn_delay).timeout
	object_toggle(show, clone) # Make clone objectvisible
	# Destroy original object
	queue_free()
	
func tween_x_or_y(axis, pixels, tween_duration)
	var tween = get_tree().create_tween() # We create a tween
	# Tweens dont obstruct code, they run in parallel
	tween.tween_property(self, position+axis, pixels, tween_duration)
	# Handling respawn separately for readability
	tween_respawner(tween, tween_duration) # we pass tween_duration to allow for the tween to finish
	
