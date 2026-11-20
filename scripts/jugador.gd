extends CharacterBody2D

@export var velocidad = 440.0
@export var fuerza_salto = -1040.0
@export var gravedad = 2800.0

const CORAZONES = 3.0

var quieto = preload("res://imagenes/jugador_quieto.png")
var camina_a = preload("res://imagenes/jugador_camina_a.png")
var camina_b = preload("res://imagenes/jugador_camina_b.png")
var salta = preload("res://imagenes/jugador_salta.png")

var ya_salto = false
var vivo = true
var reloj_paso = 0.0
var vidas = CORAZONES
var invulnerable = 0.0
var reloj_parpadeo = 0.0


func _physics_process(delta: float) -> void:
	if not vivo or $"/root/Nivel".termino:
		velocity = Vector2.ZERO
		return

	descontar_relojes(delta)

	if is_on_floor():
		ya_salto = false
	else:
		velocity.y += gravedad * delta

	var direccion = Input.get_axis("ui_left", "ui_right")
	velocity.x = direccion * velocidad

	var quiere_saltar = Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")
	if quiere_saltar and is_on_floor() and not ya_salto:
		velocity.y = fuerza_salto
		ya_salto = true
		$"/root/Nivel/AudioManager/SonidoSalto".play()

	var venia_cayendo = not is_on_floor()

	move_and_slide()

	if venia_cayendo and is_on_floor():
		$Polvo.restart()

	if direccion != 0:
		$Sprite2D.flip_h = direccion < 0

	cambiar_pose(direccion, delta)


func descontar_relojes(delta: float) -> void:
	if invulnerable > 0.0:
		invulnerable -= delta
		reloj_parpadeo += delta
		if reloj_parpadeo >= 0.1:
			reloj_parpadeo = 0.0
			$Sprite2D.visible = not $Sprite2D.visible
		if invulnerable <= 0.0:
			$Sprite2D.visible = true


func cambiar_pose(direccion: float, delta: float) -> void:
	if not is_on_floor():
		$Sprite2D.texture = salta
		return

	if direccion == 0:
		$Sprite2D.texture = quieto
		return

	reloj_paso += delta
	if reloj_paso >= 0.15:
		reloj_paso = 0.0
		$Sprite2D.texture = camina_b if $Sprite2D.texture == camina_a else camina_a


func recibir_golpe(cantidad: float) -> void:
	if not vivo or invulnerable > 0.0:
		return

	vidas -= cantidad
	if vidas <= 0.0:
		morir()
		return

	invulnerable = 1.2
	$"/root/Nivel".perder_corazon(vidas)


func morir() -> void:
	if not vivo:
		return
	vivo = false
	vidas = 0.0
	velocity = Vector2.ZERO
	$Sprite2D.visible = true
	$"/root/Nivel".perdiste()


func revivir(punto: Vector2) -> void:
	global_position = punto
	velocity = Vector2.ZERO
	vivo = true
	vidas = CORAZONES
	invulnerable = 0.0
	$Sprite2D.visible = true
	$Sprite2D.texture = quieto
