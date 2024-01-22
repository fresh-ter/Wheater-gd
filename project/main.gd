extends Node


func _ready():
	var server = HttpServer.new()
	server.bind_address = "127.0.0.1"
	server.port = 8080
	
	var fileRouter = HttpFileRouter.new("res://www")
	fileRouter.extensions.append("js")
	fileRouter.extensions.append("css")
	
	server.register_router("/", fileRouter)
	server.register_router("/senders", fileRouter)
	server.register_router("/add_sender", fileRouter)
	server.register_router("/script", fileRouter)
	server.register_router("/style", fileRouter)
	
	server.register_router("/api", APIRouter.new())
	
	add_child(server)
	server.start()


func _process(delta):
	pass
