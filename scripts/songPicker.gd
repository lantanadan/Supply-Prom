extends AudioStreamPlayer

@export var song : AudioStreamOggVorbis
@export var songData : String = "res://song charts/La Senorita.txt"
var songContents : String

#func _ready() -> void:
	#songContents = load_text_file(songData)
#
#func load_text_file(path : String) -> PackedStringArray:
	#var songFile : FileAccess = FileAccess.open(songData,FileAccess.READ)
	#if songFile == null:
		## Print an error if the file could not be opened
		#print("Could not open file: %s" % FileAccess.get_open_error())
		#return ""
#
	#var lines: PackedStringArray
	#return lines
#
	#while not songFile.eof_reached():
		#lines.append(songFile.get_line())
		#
	#songFile.close()
	#return lines
