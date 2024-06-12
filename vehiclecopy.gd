extends CharacterBody2D


# Declare member variables here. Examples:
var road = [Vector2(), Vector2()]# line2D object's coords that vehicle is currently on
var roadLen = 0
var speedLimit = 2
var accelRate = 1.01
var stoppingDist = 5 # how far the area2D detecting other vehicles sees ahead
var speed = 2
var stop = false
var spawnRoad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# check if reached end of the road
	var diffVec = self.global_position - road[0]
	var dist = sqrt(pow(diffVec[0],2) + pow(diffVec[1],2))
	if dist  < roadLen: # check if the vehicle has travelled the same dist as the road
		# velocity calculations
		var dirVec = Vector2(road[1] - road[0]).normalized()
		if speed < speedLimit:
			speed *= accelRate
		else:
			speed = speedLimit
		var velocity = dirVec * speed
		if not stop:
			move_and_collide(velocity)
	else:
		var array = get_tree().get_nodes_in_group(str(road[1])+"out")
		array.shuffle()
		if not array:
			array = [self.spawnRoad]
		road[0] = array[0].get_point_position(0)
		road[1] = array[0].get_point_position(1)
		roadLen = array[0].length
		self.global_position = road[0]
		self.speedLimit = array[0].maxSpeed
		look_at(road[1])


func _on_Eyesight_body_entered(body: Node) -> void:
	if body != self:
		stop = true

func _on_Eyesight_body_exited(body: Node) -> void:
	if body != self:
		stop = false
