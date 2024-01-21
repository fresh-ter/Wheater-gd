extends HttpRouter
class_name FileRouter

# Handle a GET request
func handle_get(request: HttpRequest, response: HttpResponse):
	#print(request.path)
	
	var path = request.path.substr(1)
	
	
	if path == '':
		path = 'index.html'
		
	print(FileAccess.file_exists("res://www/" + path))
	print(path)
		
	response.send(200, "Hello! from GET")


