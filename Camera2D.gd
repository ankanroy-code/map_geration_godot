extends Camera2D

export(float) var speed
var input : Vector2
func _input(event):
	if event is InputEventKey:
		input = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("up") - Input.get_action_strength("down")
		)
func _process(delta):
	position += input.normalized() * delta * speed
