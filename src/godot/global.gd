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

var reactive_results = {
	"ObjectsMissed": {
		"structures": 0,
		"rows": 0
	}
}

var falsepositives = {
		"CameraError": 0,
		"FlightError": 0,
		"HardwareError": 0
}

var timestamps = {
	"camera_error_enter": {},
	"camera_error_exit": {},
	"camera_error_input": {},
	"flight_error_enter": {},
	"flight_error_exit": {},
	"flight_error_input": {},
	"altitude_error_input": {},
	"hardware_error_enter": {},
	"hardware_error_exit": {},
	"hardware_error_input": {},
}
