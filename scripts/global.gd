extends Node

var nombre_archivo = "user://guardado.dat"
var muertes = 0


func grabar():
	var archivo = FileAccess.open(nombre_archivo, FileAccess.WRITE)
	archivo.store_var(muertes)
	archivo.close()


func cargar():
	if FileAccess.file_exists(nombre_archivo):
		var archivo = FileAccess.open(nombre_archivo, FileAccess.READ)
		muertes = archivo.get_var()
		archivo.close()
