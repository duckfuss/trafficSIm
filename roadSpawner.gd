extends Node2D


# Declare member variables here.
const roadScene = preload("res://road.tscn")
var activeRoad
var type = "normal"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func startRoad(pos):
	activeRoad = roadScene.instantiate()
	activeRoad.set_as_top_level(true)
	activeRoad.add_point(pos)
	activeRoad.type = type
	activeRoad.add_to_group(str(pos)+"out")

func endRoad(pos):
	activeRoad.add_point(pos)
	activeRoad.add_to_group(str(pos)+"in")
	activeRoad.calcLength()
	add_child(activeRoad)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


