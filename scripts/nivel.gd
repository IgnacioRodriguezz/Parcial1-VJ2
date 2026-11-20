extends Node2D

var termino = false

var corazon_lleno = preload("res://imagenes/corazon_lleno.png")
var corazon_medio = preload("res://imagenes/corazon_medio.png")
var corazon_vacio = preload("res://imagenes/corazon_vacio.png")


func _ready() -> void:
	$CanvasLayer/LabelCartel.text = ""
	Global.cargar()
	actualizar_muertes()
	actualizar_corazones($Jugador.vidas)


func perder_corazon(vidas: float) -> void:
	$AudioManager/SonidoGolpe.play()
	actualizar_corazones(vidas)


func perdiste() -> void:
	$AudioManager/SonidoMuerte.play()
	mostrar_cartel("PERDISTE", Color(1, 0.3, 0.3))
	actualizar_corazones(0.0)

	Global.muertes += 1
	Global.grabar()
	actualizar_muertes()

	$TimerRespawn.start()


func ganaste() -> void:
	if termino:
		return
	termino = true
	$AudioManager/SonidoVictoria.play()
	mostrar_cartel("LLEGASTE", Color(0.4, 1, 0.5))
	$TimerFinal.start()


func mostrar_cartel(texto, color) -> void:
	$CanvasLayer/LabelCartel.text = texto
	$CanvasLayer/LabelCartel.self_modulate = color


func actualizar_muertes() -> void:
	$CanvasLayer/LabelMuertes.text = "muertes: " + str(Global.muertes)


func actualizar_corazones(vidas: float) -> void:
	pintar_corazon($CanvasLayer/Corazon1, vidas)
	pintar_corazon($CanvasLayer/Corazon2, vidas - 1.0)
	pintar_corazon($CanvasLayer/Corazon3, vidas - 2.0)


func pintar_corazon(corazon: Sprite2D, cuanto: float) -> void:
	if cuanto >= 1.0:
		corazon.texture = corazon_lleno
	elif cuanto >= 0.5:
		corazon.texture = corazon_medio
	else:
		corazon.texture = corazon_vacio


func _on_timer_respawn_timeout() -> void:
	$CanvasLayer/LabelCartel.text = ""
	$Jugador.revivir($PuntoDeInicio.global_position)
	actualizar_corazones($Jugador.vidas)


func _on_timer_final_timeout() -> void:
	get_tree().quit()


func _on_musica_finished() -> void:
	$AudioManager/Musica.play()
