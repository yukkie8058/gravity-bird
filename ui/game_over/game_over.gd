extends MarginContainer

@export_group("Component")
@export var _score: Label
@export var _tweet: TweetButton
@export_subgroup("High Score", "_high_score")
@export var _high_score_normal: Label
@export var _high_score_rainbow: Label
@export var _high_score_audio: AudioStreamPlayer

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			_shown()

func _shown() -> void:
	_score.text = String.num_uint64(Main.node().score)

	if Main.node().score > 0:
		_tweet.tweet_text = "Gravity Birdで%d点を獲得！\n" % Main.node().score
	else:
		_tweet.tweet_text = "Gravity Birdで1点も取れませんでした...😭\n"
	_tweet.tweet_text += "https://godotplayer.com/games/gravity_bird"

	var enable_high_score := OS.is_userfs_persistent()

	_high_score_normal.visible = enable_high_score and not Main.node().is_high_score()
	_high_score_normal.text = "HIGH SCORE: %d" % Save.get_singleton().high_score

	_high_score_rainbow.visible = enable_high_score and Main.node().is_high_score()
	if enable_high_score and Main.node().is_high_score():
		_high_score_audio.play()

		var tween := create_tween()
		const HIGH_SCORE_BLINK_DURATION := 0.5
		const HIGH_SCORE_BLINK_INTERVAL := 0.1
		for i in int(HIGH_SCORE_BLINK_DURATION / HIGH_SCORE_BLINK_INTERVAL):
			tween.tween_callback(_high_score_rainbow.set_indexed.bind("modulate:a", float(i % 2)))\
				.set_delay(HIGH_SCORE_BLINK_INTERVAL)
		tween.tween_callback(_high_score_rainbow.set_indexed.bind("modulate:a", 1.0))

func _restart_pressed() -> void:
	MainState.chart().send_event("game_restart")
