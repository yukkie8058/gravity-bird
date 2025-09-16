extends MarginContainer

@export_group("Component")
@export var _score: Label
@export var _tweet: TweetButton

func _enter_tree() -> void:
	Main.node().score_changed.connect(_main_score_changed)
	_main_score_changed()

func _main_score_changed() -> void:
	_score.text = str(Main.node().score)
	_tweet.tweet_text = ("Gravity Birdで" + str(Main.node().score) + "点を獲得！" \
	if Main.node().score > 0 else "Gravity Birdで1点も取れませんでした...😭"
	) + "\nhttps://godotplayer.com/games/gravity_bird"

func _restart_pressed() -> void:
	MainState.chart().send_event("game_restart")
