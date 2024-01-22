extends HttpRouter
class_name APIRouter

func genToken():
	var crypto := Crypto.new()
	var byte_array := crypto.generate_random_bytes(16)
	print(byte_array.hex_encode())
	return byte_array.hex_encode()

func handle_post(request: HttpRequest, response: HttpResponse) -> void:
	print(request.body)
	var req = JSON.parse_string(request.body)
	var command = req["command"]
	print(command)
	
	if command == "createSender":
		var name = req["name"]
		print(name)
		
		
		var token = genToken()
		
		var table_name = "Senders"
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		var row_dict : Dictionary = Dictionary()
		row_dict["name"] = name
		row_dict["token"] = token
		db.insert_row(table_name, row_dict)

		#db.query("SELECT * FROM NewTable;")
		#response.send(200, "Hello! from GET " + str(db.query_result))

		db.close_db()
		
		response.send(200, JSON.stringify({
			message = "OK"
		}), "application/json")
	elif command == "getSenders":
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		db.query("SELECT * FROM Senders;")
		
		db.close_db()
		
		response.send(200, JSON.stringify(db.query_result), "application/json")
	elif command == "deleteSender":
		var id = req["id"]
		var table_name = "Senders"
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		db.delete_rows(table_name, "id = " + id)
		
		db.close_db()
		
		response.send(200, JSON.stringify({
			message = "OK"
		}), "application/json")
	elif command  == "regenerateToken":
		var id = req["id"]
		var table_name = "Senders"
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		var row_dict : Dictionary = Dictionary()
		row_dict["token"] = genToken()
		db.update_rows(table_name, "id = " + id, row_dict)
		
		db.close_db()
		
		response.send(200, JSON.stringify({
			message = "OK"
		}), "application/json")
	else:
		response.send(200, JSON.stringify({
			message = "404"
		}), "application/json")
