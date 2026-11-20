extends Area2D

@export var velocidad = 110.0
@export var limite_izquierda = 0.0
@export var limite_derecha = 0.0
@export var golpe = 1.5

var cara_a = preload("res://imagenes/fantasma_a.png")
var cara_b = preload("res://imagenes/fantasma_b.png")

var direccion = 1.0
var reloj_cara = 0.0


func _physics_process(delta: float) -> void:
	if $"/root/Nivel".termino:
		return

	position.x += direccion * velocidad * delta

	if position.x >= limite_derecha:
		position.x = limite_derecha
		direccion = -1.0
	elif position.x <= limite_izquierda:
		position.x = limite_izquierda
		direccion = 1.0

	reloj_cara += delta
	if reloj_cara >= 0.4:
		reloj_cara = 0.0
		$Sprite2D.texture = cara_b if $Sprite2D.texture == cara_a else cara_a


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body.recibir_golpe(golpe)
