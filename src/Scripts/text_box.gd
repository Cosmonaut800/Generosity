extends Control

@onready var speech_label := $SpeechBox/SpeechLabel
@onready var speaker_label := $SpeechBox/SpeakerBox/SpeakerLabel
@onready var arrow_image := $SpeechBox/Arrow
@onready var stop_image := $SpeechBox/Stop
@onready var filter_timer := $Filter

var can_advance := false
var text_queue = []

signal finished

const TEXTS = {"LUMBERJACK_1": {speaker = "Lumberjack", speech = "I wish I didn't lose my axe. I was out chopping wood when I heard a noise that scared me off. I left my axe behind in the hurry, I don't know how I'm going to find it...", is_end = false},
	"LUMBERJACK_2": {speaker = "Traveler", speech = "(I saw an axe on the way into town, that can't be a coincidence. I should go fetch it.)", is_end = true},
	"LUMBERJACK_3": {speaker = "Lumberjack", speech = "What? Where did you find that? Oh, thank you! This sure saves me a heap of trouble!", is_end = true},
	"OLD_WOMAN_1": {speaker = "Old Woman", speech = "I wish I could find some medicine that would keep my husband from aching so much.", is_end = false},
	"OLD_WOMAN_2": {speaker = "Traveler", speech = "(Sounds like an herbal remedy would work, I bet I could find something in the nearby woods. I should bring it to her.)", is_end = true},
	"OLD_WOMAN_3": {speaker = "Old Woman", speech = "Oh? This is for me? Ohh, you didn't have to do that, but thank you! I'm sure this will help.", is_end = true},
	"FAMILY_1" : {speaker = "Young Child", speech = "I miss when Dad used to let us play with the machines he found in the Ruins...", is_end = false},
	"FAMILY_2" : {speaker = "The Other Child", speech = "I wish we had something like that now.", is_end = false},
	"FAMILY_3" : {speaker = "Traveler", speech = "(A toy from the Ruins? Hmm... Well, it's worth a shot. I'll see if I can find anything for these two.)", is_end = true},
	"FAMILY_4" : {speaker = "Young Child", speech = "Wow! It's just like the one Dad used to have!", is_end = false},
	"FAMILY_5" : {speaker = "Traveler", speech = "(They're pointing at my gauntlet! Well... Fine, they can have it, they look too excited to say no... I can find another one... Eventually... Probably...)", is_end = false},
	"FAMILY_6" : {speaker = "Mother", speech = "Thank you, this means a lot to them. Their father used to study the technology at the ruins, this really brings back memories...", is_end = true},
	"GOAL_1_1" : {speaker = "Traveler", speech = "That must be his axe. Time to bring it back to the village.", is_end = true},
	"GOAL_1_2" : {speaker = "Traveler", speech = "!!", is_end = false},
	"GOAL_1_3" : {speaker = "Tree Spirit", speech = "I am a spirit of these woods. That gauntlet you are wearing is from the old era. I ask that you share its energy with us whenever you find us. The good it does will find its way back to you.", is_end = true},
	"GOAL_2" : {speaker = "Traveler", speech = "Ahh, she should be able to brew some medicinal tea from this. I'll take some to her.", is_end = true},
	"GOAL_3" : {speaker = "Traveler", speech = "Hmm... Seems to still work, doesn't seem too dangerous... Those kids should be able to have some fun with this.", is_end = true}}

func show_text(text_index: String):
	speaker_label.text = TEXTS[text_index].speaker
	speech_label.visible_ratio = 0.0
	speech_label.text = TEXTS[text_index].speech
	if TEXTS[text_index].is_end:
		arrow_image.hide()
		stop_image.show()
	else:
		arrow_image.show()
		stop_image.hide()
	self.show()
	var tween = create_tween()
	speech_label.set_visible_ratio(0.0)
	tween.tween_property(speech_label, "visible_ratio", 1.0, 1.0)

func hide_text():
	self.hide()
	speech_label.visible_ratio = 0.0

func display_text_box(text_index: String):
	can_advance = false
	filter_timer.start()
	text_queue.push_back(text_index)
	if !visible:
		show_text(text_queue.pop_front())

func display_next_text():
	can_advance = false
	filter_timer.start()
	if text_queue.size() <= 0:
		hide_text()
		finished.emit()
	else:
		show_text(text_queue.pop_front())

func _input(event):
	if can_advance and event.is_action_pressed("fire"):
		display_next_text()

func _on_filter_timeout() -> void:
	can_advance = true
