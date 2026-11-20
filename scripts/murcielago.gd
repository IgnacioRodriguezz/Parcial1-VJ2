extends Area2D

@export var velocidad_x = 190.0
@export var velocidad_y = 95.0
@export var limite_izquierda = 0.0
@export var limite_derecha = 0.0
@export var limite_arriba = 0.0
@export var limite_abajo = 0.0
@export var golpe = 1.0

var alas_arriba = preload("res://imagenes/murcielago_a.png")
var alas_abajo = preload("res://imagenes/murcielago_b.png")

var direccion_x = 1.0
var direccion_y = 1.0
var reloj_ala = 0.0


func _physics_process(delta: float) -> void:
	if $"/root/Nivel".termino:
		return

	position.x += direccion_x * velocidad_x * delta
	position.y += direccion_y * velocidad_y * delta

	if position.x >= limite_derecha:
		position.x = limite_derecha
		direccion_x = -1.0
	elif position.x <= limite_izquierda:
		position.x = limite_izquierda
		direccion_x = 1.0

	if position.y >= limite_abajo:
		position.y = limite_abajo
		direccion_y = -1.0
	elif position.y <= limite_arriba:
		position.y = limite_arriba
		direccion_y = 1.0

	$Sprite2D.flip_h = direccion_x > 0.0

	reloj_ala += delta
	if reloj_ala >= 0.12:
		reloj_ala = 0.0
		$Sprite2D.texture = alas_abajo if $Sprite2D.texture == alas_arriba else alas_arriba


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body.recibir_golpe(golpe)
