class_name  World
extends Node2D

var server_port: int = 124
var server_address: String = "127.0.0.1"
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@onready var cam = $Camera2D
@onready var buttons = $Buttons

func _on_hotseat_pressed():
	buttons.queue_free()
	add_player(-1)
	add_player(1)
	cam.enabled = false

func _on_host_pressed():
	buttons.queue_free()
	peer.create_server(server_port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	cam.enabled = false

func _on_join_pressed():
	if not _is_valid_ip(server_address):
		print(server_address, "is not a valid IP address!")
		return
	buttons.queue_free()
	peer.create_client(server_address, server_port)
	multiplayer.multiplayer_peer = peer
	cam.enabled = false

func add_player(id: int = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player", id)

@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()

func _on_target_ip_text_changed():
	var targetip_button: TextEdit = $Buttons/TargetIP
	var text: String = targetip_button.text
	server_address = text
	
func _is_valid_ip(ip: String) -> bool:
	# Regular expression pattern for a valid IP address
	var ip_pattern = r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
	var regex = RegEx.new()
	var result = regex.compile(ip_pattern)
	if result != OK:
		print("Regex compilation failed")
		return false
	if not regex.search(ip):
		return false

	# Check if each segment is between 0 and 255
	var segments = ip.split(".")
	for segment in segments:
		var num = int(segment)
		if num < 0 or num > 255:
			return false

	return true
