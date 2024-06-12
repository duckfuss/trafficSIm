extends CharacterBody2D


# Declare member variables here. Examples:

var road # line2D object that vehicle is currently on
var ogRoad
var speedLimit = 2
var accelRate = (randf()*2)+1
var stoppingDist = randf_range(5,20)# how far the area2D detecting other vehicles sees ahead
var speed = 2
var stop = false
var carNum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	stoppingDist = rng.randi_range(5,20)
	$Eyesight/CollisionShape2D.shape.size[1] = stoppingDist
	$Eyesight/CollisionShape2D.position[0] = stoppingDist - 10

func _process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# check if road still exists
	if not is_instance_valid(road):
		self.road = ogRoad
		self.global_position = road.get_point_position(0)
		self.speedLimit = road.maxSpeed
		look_at(road.get_point_position(1))
		print("road was deleted")
	if $Eyesight.get_overlapping_bodies():
			stop = true
	else:
			stop = false
	# check if reached end of the road
	var diffVec = self.global_position - road.get_point_position(0)
	var dist = sqrt(pow(diffVec[0],2) + pow(diffVec[1],2))
	if dist  < road.length: # check if the vehicle has travelled the same dist as the road
		# velocity calculations
		var dirVec = Vector2(road.get_point_position(1) - road.get_point_position(0)).normalized()
		if speed < speedLimit:
			speed *= accelRate
		else:
			speed = speedLimit
		var velocity = dirVec * speed
		if not stop:
			move_and_collide(velocity)
	else:
		var array = get_tree().get_nodes_in_group(str(road.get_point_position(1))+"out")
		if array.is_empty():
			array = [ogRoad]
		array.shuffle()
		road = array[0]
		self.global_position = road.get_point_position(0)
		self.speedLimit = road.maxSpeed
		look_at(road.get_point_position(1))
		# this is a bug mitigation thing (not called earlier for efficiency):
		#if $Eyesight.get_overlapping_bodies():
		#	stop = true
		#else:
		#	stop = false

#func _on_Eyesight_body_entered(body: Node) -> void:
#	if body != self:
#		stop = true

#func _on_Eyesight_body_exited(body: Node) -> void:
#	if body != self:
#		stop = false
