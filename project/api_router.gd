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
	print(req["command"])
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
	elif command  == "changeNameSender":
		var id = req["id"]
		var newName = req["newName"]
		var table_name = "Senders"
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		var row_dict : Dictionary = Dictionary()
		row_dict["name"] = newName;
		db.update_rows(table_name, "id = " + id, row_dict)
		
		db.close_db()
		
		response.send(200, JSON.stringify({
			message = "OK"
		}), "application/json")
	elif command  == "addData":
		var datetime
		if req.has("datetime"):
			datetime = req["datetime"]
		else:
			datetime = false
		var data = req["data"]
		var sender_id = req["sender_id"]
		var type_id = req["type_id"]
		
		print("datetime", datetime)
		
		
		
		
		var table_name = "D"
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		var row_dict : Dictionary = Dictionary()
		
		if datetime:
			row_dict["t"] = datetime
		row_dict["sender_id"] = sender_id
		row_dict["type_id"] = type_id
		row_dict["value"] = data
		
		print(row_dict)
		
		db.insert_row(table_name, row_dict)

		#db.query("SELECT * FROM NewTable;")
		#response.send(200, "Hello! from GET " + str(db.query_result))

		db.close_db()
		
		response.send(200, JSON.stringify({
			message = "OK"
		}), "application/json")
	elif command  == "getData":
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		db.query("SELECT * FROM D;")
		
		db.close_db()
		
		response.send(200, JSON.stringify(db.query_result), "application/json")
	elif command  == "getTypes":
		var db = SQLite.new()
		db.path = "res://db.sqlite"
		db.verbosity_level = SQLite.VERBOSE
		db.open_db()
		
		db.query("SELECT * FROM Types;")
		
		db.close_db()
		
		response.send(200, JSON.stringify(db.query_result), "application/json")
	else:
		response.send(200, JSON.stringify({
			message = "404"
		}), "application/json")
