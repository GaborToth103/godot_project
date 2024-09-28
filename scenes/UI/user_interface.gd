#region Properties
class_name MyUserInterface
extends Control
@onready var time_label: Label = $PanelContainer/Panel/HBoxContainer/Label
@onready var announcement_label: Label = $AnnouncementLabel
@onready var timer_ready: Timer = $Timers/Ready
@onready var timer_fight: Timer = $Timers/Fight
@onready var timer_game: Timer = $Timers/Game
@onready var timer_end: Timer = $Timers/GameEnd
@onready var health_p1: ProgressBar = $PanelContainer/Panel/HBoxContainer/HealthBar_1
@onready var health_p2: ProgressBar = $PanelContainer/Panel/HBoxContainer/HealthBar_2
@onready var level_completed: ColorRect = $CanvasLayer/LevelCompleted

enum Outcome{P1, P2, TIE}
enum GameStance{INIT, READY, FIGHT, GAME, END}
var game_state: GameStance = GameStance.INIT
#endregion

func _ready():
	announcement_label.visible = false
	Events_name.level_completed.connect(show_level_completed)
	Events_name.next_level.connect(hide_level_completed)

func show_level_completed():
	level_completed.show()

func hide_level_completed():
	level_completed.hide()



func _process(_delta):
	time_label.text = str(int(timer_end.time_left))
	var players: Array = get_tree().get_nodes_in_group("player")
	if players:
		if len(players) == 2:
			refresh_healthbars(players[0].pd.health, players[1].pd.health)
		else:
			refresh_healthbars(players[0].pd.health, 0)

func refresh_healthbars(p1_percentage: int, p2_percentage: int):
	health_p1.value = p1_percentage
	health_p2.value = p2_percentage

#region Events
func game_start_event():
	timer_ready.start()

func game_end_event(outcome: Outcome):
	announcement_label.visible = true
	match outcome:
		Outcome.TIE: announcement_label.text = "Tied game!"
		Outcome.P1: announcement_label.text = "Player one wins!"
		Outcome.P2: announcement_label.text = "Player two wins!"
#endregion

#region Timers
func _on_ready_timeout():
	timer_fight.start()
	announcement_label.text = "Ready!"
	announcement_label.visible = true

func _on_fight_timeout():
	timer_game.start()
	announcement_label.text = "Fight!"
	announcement_label.visible = true

func _on_game_timeout():
	timer_end.start()
	announcement_label.visible = false

func _on_game_end_timeout():
	game_end_event(Outcome.TIE)
#endregion
	
