class_name TweetButton
extends Button

@export_multiline var tweet_text: String

func _pressed() -> void:
	OS.shell_open("https://twitter.com/intent/tweet?text=" + tweet_text.uri_encode())
