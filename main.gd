extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var count = 1
var mouseMode = "ROAD"
var deleteRoad = [Vector2(), Vector2()]
var type = "normal"
var cursorLerp = 0.0
var snappedPos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			snappedPos = event.position.snapped(Vector2(50,50))
			count += 1
			if mouseMode == "ROAD":
				if count == 2: # set the position of the source of the vehicles
					$vehicleSpawner.global_position = snappedPos
				if count % 2 == 0:
					print("start")
					$roadSpawner.startRoad(snappedPos)
				else:
					print("stop")
					$roadSpawner.endRoad(snappedPos)
			elif mouseMode == "DELETE":
				if count % 2 == 0:
					deleteRoad = [Vector2(), Vector2()]
					deleteRoad[0] = snappedPos
				else:
					deleteRoad[1] = snappedPos
					var array = get_tree().get_nodes_in_group(str(deleteRoad[0])+"out")
					for road in array:
						print(road.get_point_position(1))
						if road.get_point_position(1) == deleteRoad[1]:
							road.queue_free()
							break
					
					print(deleteRoad)
				pass
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			print("Right button was clicked at ", event.position)
			count -= 1
			
func _draw(): # preview image
	if count % 2 == 0:
		print(snappedPos, $cursor.global_position)
		draw_line(snappedPos, $cursor.global_position, Color(1.0, 1.0, 1.0), 5)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = lerp($cursor.global_position, get_viewport().get_mouse_position().snapped(Vector2(50,50)), 0.15)
	$cursor.global_position = pos
	queue_redraw() # updates _draw()

func _on_selectFastRoad_button_down() -> void:
	$roadSpawner.type = "fast"
	mouseMode = "ROAD"

func _on_selectSlowRoad_button_down() -> void:
	$roadSpawner.type = "slow"
	mouseMode = "ROAD"

func _on_selectNormalRoad_button_down() -> void:
	$roadSpawner.type = "normal"
	mouseMode = "ROAD"
	
func _on_roadDelete_button_down() -> void:
	mouseMode = "DELETE"


func _on_restart_button_down() -> void:
	$gui/confirmRestart.visible = true

func _on_confirmRestart_confirmed() -> void:
	get_tree().reload_current_scene()
