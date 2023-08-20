extends Control

@onready var buttons := $Buttons.get_children()

const ENABLED_STAR_FRAME := 7
const DISABLED_STAR_FRAME := 9


func _ready():
	print(buttons)

	var idx = 0
	for is_enable in Utils.phases_world_1_enable_status:
		if is_enable:
			buttons[idx].get_node("Number").text = str(idx + 1)

		buttons[idx].disabled = not is_enable

		idx += 1

	idx = 0
	for is_concluded in Utils.phases_world_1_conclude_status:
		var sprites := buttons[idx].get_node("Stars").get_children()
		print(is_concluded)
		for sprite in sprites:
			if not Utils.phases_world_1_enable_status[idx]:
				sprite.visible = false
			elif is_concluded:
				sprite.frame = ENABLED_STAR_FRAME
			else:
				sprite.frame = DISABLED_STAR_FRAME
		
		idx += 1
