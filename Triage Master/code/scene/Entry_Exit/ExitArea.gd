extends Area2D

signal healed_patient_entered
signal patient_exited_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	


func _on_ExitArea_body_entered(body):
	if body is Patient:
		emit_signal("healed_patient_entered", body)


func _on_ExitArea_body_exited(body):
	if body is Patient:
		emit_signal("patient_exited_screen", body)
