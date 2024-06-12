extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var vehicleScene = preload("res://vehicle.tscn")
var spawnLoop = 0
var carNum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$vehicleSpawnTimer.wait_time = 0.5
	pass

func spawn():
	var road = get_tree().get_nodes_in_group(str(self.global_position)+"out")[0]
	var vehicle = vehicleScene.instantiate()
	vehicle.set_as_top_level(true)
	vehicle.road = road
	vehicle.ogRoad = road
	vehicle.global_position = self.global_position
	vehicle.carNum = carNum
	carNum += 1
	add_child(vehicle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spawn1Car_button_down() -> void:
	spawn()
 
func _on_spawn10Cars_button_down() -> void:
	spawnLoop += 10
	$vehicleSpawnTimer.start()

func _on_spawn50Cars_button_down() -> void:
	spawnLoop += 50
	$vehicleSpawnTimer.start()

func _on_vehicleSpawnTimer_timeout() -> void:
	spawn()
	spawnLoop -= 1
	if spawnLoop <= 0:
		$vehicleSpawnTimer.stop()
