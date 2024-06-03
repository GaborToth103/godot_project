class_name  MultiplayerMenu
extends VBoxContainer

var server_port: int = 124
var server_address: String = "127.0.0.1"
var peer = ENetMultiplayerPeer.new()
@export var player_id: int = 0
	
func _on_hotseat_pressed():
	get_parent().add_player(1)
	get_parent().add_player(-1)
	queue_free()

func _on_host_pressed():
	peer.create_server(server_port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(get_parent().add_player)
	get_parent().add_player()
	queue_free()

func _on_join_pressed():
	if not _is_valid_ip(server_address):
		print(server_address, "is not a valid IP address!")
		return
	# buttons.queue_free()
	peer.create_client(server_address, server_port)
	multiplayer.multiplayer_peer = peer
	queue_free()

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
