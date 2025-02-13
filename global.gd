extends Node

var userinfo = {
	"id" = "",
	"age" = 0,
	"droneexp" = 0,
	"droneautoexp" = 0,
}

var results = {
	"FlightError": {
		1: {"time": 0.0, "missed": true},
		2: {"time": 0.0, "missed": true},
		3: {"time": 0.0, "missed": true},
		4: {"time": 0.0, "missed": true},
		5: {"time": 0.0, "missed": true},
		6: {"time": 0.0, "missed": true},
		7: {"time": 0.0, "missed": true}
	},
	"CameraError": {
		1: {"time": 0.0, "missed": true},
		2: {"time": 0.0, "missed": true},
		3: {"time": 0.0, "missed": true},
		4: {"time": 0.0, "missed": true},
		5: {"time": 0.0, "missed": true},
		6: {"time": 0.0, "missed": true},
		7: {"time": 0.0, "missed": true}
	},
	"HardwareError": {
		1: {"time": 0.0, "missed": true},
		2: {"time": 0.0, "missed": true},
		3: {"time": 0.0, "missed": true},
		4: {"time": 0.0, "missed": true},
		5: {"time": 0.0, "missed": true},
		6: {"time": 0.0, "missed": true},
		7: {"time": 0.0, "missed": true}
	}
}

var falsepositives = {
	"FalsePositives": {
			"CameraError": 1,
			"FlightError": 2,
			"HardwareError": 2
		}
}

var reactive_results = {
	"ObjectsMissed": {
		"structures": 0,
		"rows": 0
	}
}
