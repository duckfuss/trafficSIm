extends Line2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var vehiclesList = [] # list of vehicles on the line
var length
var type
var maxSpeed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.width = 10
	if type == "fast":
		maxSpeed = 4
		self.default_color = Color(1,0,0,1)
	elif type == "slow":
		maxSpeed = 1
		self.default_color = Color(1,1,0,1)
	elif type == "normal":
		maxSpeed = 2
		self.default_color = Color(0.4,0.5,1,1)

func calcLength():
	var diffVec = self.get_point_position(1) - self.get_point_position(0)
	length = sqrt(pow(diffVec[0],2) + pow(diffVec[1],2))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
