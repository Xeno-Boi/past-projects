extends Mobs

func attack_state(delta):
	chase_state(delta)

func _on_Hitbox_area_entered(area):
	state = IDLE
	velocity = Vector2.ZERO
	can_see_player = false
	yield(get_tree().create_timer(attack_cooldown), "timeout")
	if !detect_area.get_overlapping_bodies().empty():
		can_see_player = true
	
