extends Area2D

var ya_entro = false


func _on_body_entered(body: Node2D) -> void:
	if ya_entro:
		return
	if not body.is_in_group("jugador"):
		return

	ya_entro = true
	$Fiesta.restart()
	$"/root/Nivel".ganaste()
