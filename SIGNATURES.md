# Function Signatures Documentation

This document provides an overview of the key directories/files/classes/functions, their parameters, and return types as well as any class attributes.

# Godot Simulation Scripts (`src/godot/scripts`)

## 1. Global State (`global.gd`)
---

Extends: `Node`

### Class Attributes:
- `userinfo`: Dictionary - Stores participant information
  - `id`: String - Participant identifier
  - `age`: Integer - Age group code
  - `droneexp`: Integer - Drone experience level
  - `droneautoexp`: Integer - Autonomous drone experience level
- `results`: Dictionary - Stores error detection data for various error types
  - `FlightError`: Dictionary - Flight error instances
  - `CameraError`: Dictionary - Camera error instances
  - `HardwareError`: Dictionary - Hardware error instances
- `reactive_results`: Dictionary - Stores data for reactive mode
  - `ObjectsMissed`: Dictionary - Counts missed objects by type
- `falsepositives`: Dictionary - Counts false positive detections
- `timestamps`: Dictionary - Records timing data for various events

## 2. Main Controller (`main.gd`)
---

Extends: `Node2D`

### Class Attributes:
- `missed`: Integer - Count of missed errors
- `time`: Integer - Time counter
- `started`: Boolean - Flag for whether simulation is running
- `camera_error`: Boolean - Flag for active camera error
- `camera_error_count`: Integer - Count of camera errors
- `hardware_error`: Boolean - Flag for active hardware error
- `hardware_error_count`: Integer - Count of hardware errors
- `picture_total`: Integer - Total pictures taken
- `last_picture_time`: Integer - Time since last picture
- `hud`: Reference - HUD node reference
- `ui`: Reference - UI node reference
- `flight_path`: PackedScene - Preloaded flight path scene
- `reactive_flight_path`: PackedScene - Preloaded reactive flight path scene
- `tutorial_flight_path`: PackedScene - Preloaded tutorial flight path scene
- `path`: Reference - Current active path reference

### Functions:

#### `func _ready() -> void`
Initializes the simulation, sets up initial values and connects signals

#### `func _on_hud_tutorial_flight_path_spawn() -> void`
Spawns the tutorial flight path and connects signals

#### `func _on_hud_flight_path_spawn() -> void`
Spawns the planned flight path and connects signals

#### `func _on_hud_reactive_flight_path_spawn() -> void`
Spawns the reactive flight path and connects signals

#### `func _physics_process(delta) -> void`
Updates the HUD with current simulation values based on flight progress

## 3. Drone Controller (`drone.gd`)
---

Extends: `Area2D`

### Functions:

#### `func _on_body_entered(body) -> void`
Placeholder for collision detection

#### `func _on_area_exited(area: Area2D) -> void`
Placeholder for area exit detection

## 4. Planned Flight Path (`flight_path.gd`)
---

Extends: `Path2D`

### Signals:
- `flight_done` - Emitted when flight path is completed

### Class Attributes:
- `path`: Reference - Reference to self
- `path_follow`: Reference - PathFollow2D node
- `path_display`: Curve - Visual path curve
- `path_actual`: Curve - Actual path curve
- `drone`: Reference - Drone node
- `hud`: Reference - HUD node
- `SPEED`: Constant(0.000833333333333) - Movement speed

### Functions:

#### `func _ready() -> void`
Sets up the flight path, adds visual display, and initializes drone position

#### `func _process(delta) -> void`
Updates drone movement along path and emits signal when complete

#### `func return_progress() -> float`
Returns the current progress along the flight path (0.0 to 1.0)

## 5. Reactive Flight Path (`flight_path_reactive.gd`)
---

Extends: `Path2D`

### Signals:
- `flight_done` - Emitted when flight path is completed

### Class Attributes:
- `path`: Reference - Reference to self
- `path_follow`: Reference - PathFollow2D node
- `path_actual`: Curve - Path curve
- `drone`: Reference - Drone node
- `SPEED`: Constant(0.00166666666667) - Movement speed (2x faster than planned path)

### Functions:

#### `func _ready() -> void`
Sets up the reactive flight path and initializes drone position

#### `func _process(delta) -> void`
Updates drone movement along path and emits signal when complete

#### `func return_progress() -> float`
Returns the current progress along the flight path (0.0 to 1.0)

## 6. HUD Controller (`hud.gd`)
---

Extends: `Control`

### Signals:
- `flight_path_spawn` - Emitted to spawn planned flight path
- `reactive_flight_path_spawn` - Emitted to spawn reactive flight path
- `tutorial_flight_path_spawn` - Emitted to spawn tutorial flight path
- `flight_error_input` - Emitted when flight error button is pressed
- `altitude_error_input` - Emitted when altitude error button is pressed
- `camera_error_input` - Emitted when camera error button is pressed
- `hardware_error_input` - Emitted when hardware error button is pressed
- `done_pressed` - Emitted when done button is pressed

### Class Attributes:
- Various node references for UI elements
- `alt_error`: Boolean - Flag for altitude error
- `camera_error`: Boolean - Flag for camera error
- `camera_on`: Boolean - Flag for camera active
- `radio_error`: Boolean - Flag for radio error
- `isreactive`: Boolean - Flag for reactive mode
- `curr_time`: Float - Current simulation time
- `camera_error_instance`: Integer - Current camera error instance
- `flight_error_instance`: Integer - Current flight error instance
- `hardware_error_instance`: Integer - Current hardware error instance
- `alt_error_val`: Integer - Altitude error magnitude
- `radio_error_val`: Integer - Radio error magnitude
- `structures_missed`: Integer - Count of missed structures
- `rows_missed`: Integer - Count of missed rows
- `running`: Boolean - Flag for simulation running

### Functions:

#### `func _ready() -> void`
Sets up the initial UI state

#### `func _process(delta) -> void`
Updates time counter when simulation is running

#### `func reset() -> void`
Resets all simulation variables and UI state

#### `func generate_user_id(name: String) -> int`
Generates a unique user ID from the provided name

#### `func set_battery_level(new_value) -> void`
Updates battery level display

#### `func altitude_curve(progress) -> float`
Calculates altitude value based on progress, with error if active

#### `func set_altitude_label(progress) -> void`
Updates altitude display based on current progress

#### `func radio_curve(progress) -> float`
Calculates radio signal strength based on progress, with error if active

#### `func set_radio_level(progress) -> void`
Updates radio display based on current progress

#### `func set_camera_label(new_value) -> void`
Updates camera counter display and plays sound if needed

#### `func save_timestamp(event: String, instance: int) -> void`
Records timestamp for specified event and instance

#### `func save_to_file(name: String) -> String`
Saves simulation data to a JSON file and returns the filename

#### `func _download_file(path) -> void`
Triggers browser download of the specified file

#### `func get_results() -> Array`
Calculates and returns result metrics from the simulation

#### `func reactive_miss_count() -> void`
Shows the reactive miss count screen

#### `func results_screen() -> void`
Shows the results screen for planned mode

#### `func reactive_results_screen() -> void`
Shows the results screen for reactive mode

#### `func tutorial_done() -> void`
Handles completion of tutorial mode

#### Multiple UI signal handlers for buttons and interactions

# Data Analysis Scripts (`src/data-analysis/`)
---

The data analysis component is built with Python, Pandas, and Plotly, using Quarto for publishing.

### 1. Constants and Data Mapping (`analysis.qmd`)

#### Global Constants:
- `AGE_GROUPS`: Dictionary - Maps age codes to descriptive labels
  - `0`: "Unknown"
  - `1`: "12-17"
  - `2`: "18-24"
  - ...
  - `7`: "65+"
- `EXPERIENCE_LEVEL`: Dictionary - Maps experience codes to descriptive labels
  - `0`: "Unknown"
  - `1`: "Little Experience"
  - `2`: "Some Experience"
  - `3`: "A Lot of Experience"

### 2. Utility Functions (`analysis.qmd`)

#### `def get_age_label(age_code) -> str`
Converts age code to descriptive label
- **Parameters**:
  - `age_code`: Integer - The numeric code for age group
- **Returns**: String - Human-readable age group label

#### `def get_experience_label(exp_code) -> str`
Converts experience code to descriptive label
- **Parameters**:
  - `exp_code`: Integer - The numeric code for experience level
- **Returns**: String - Human-readable experience level label

### 3. Data Processing Functions (`analysis.qmd`)

#### `def process_json_files(file_pattern='*.json') -> tuple`
Processes multiple JSON files and combines their data into DataFrames
- **Parameters**:
  - `file_pattern`: String - Glob pattern for files to process
- **Returns**: Tuple containing:
  - `error_df`: DataFrame - Error detection data
  - `reactive_df`: DataFrame - Reactive mode specific data
  - `false_positives_df`: DataFrame - False positive error detections
  - `counter`: Integer - Count of files processed

### 4. Visualization Functions (`analysis.qmd`)

#### `def create_interactive_visualization(error_df, false_positives_df, type) -> Figure`
Creates interactive Plotly visualization with stacked bar plots for each error type
- **Parameters**:
  - `error_df`: DataFrame - Error detection data
  - `false_positives_df`: DataFrame - False positive data
  - `type`: String - Flight mode type ('planned' or 'reactive')
- **Returns**: Plotly Figure - Interactive visualization with dropdowns for filtering

#### `def create_heatmap(error_df, type) -> Figure`
Creates Plotly heatmap for average error resolution times
- **Parameters**:
  - `error_df`: DataFrame - Error detection data
  - `type`: String - Flight mode type ('planned' or 'reactive')
- **Returns**: Plotly Figure - Heatmap of error resolution times

#### `def create_hitrate_heatmap(error_df, type) -> Figure`
Creates Plotly heatmap showing percentage of successful instances
- **Parameters**:
  - `error_df`: DataFrame - Error detection data
  - `type`: String - Flight mode type ('planned' or 'reactive')
- **Returns**: Plotly Figure - Heatmap of success rates

#### `def create_response_time_histogram(planned_df, reactive_df) -> Figure`
Creates a combined histogram and line chart comparing planned and reactive response times
- **Parameters**:
  - `planned_df`: DataFrame - Planned mode error detection data
  - `reactive_df`: DataFrame - Reactive mode error detection data
- **Returns**: Plotly Figure - Comparative visualization of response times

### 5. Data Structure

#### JSON Data File Structure:
```json
{
  "userinfo": {
    "id": "[participant-id]",
    "age": "[age-code]",
    "droneexp": "[experience-code]",
    "droneautoexp": "[auto-experience-code]"
  },
  "results": {
    "FlightError": {
      "1": {"time": 0.0, "missed": true},
      "2": {"time": 0.0, "missed": true},
      "...": "..."
    },
    "CameraError": {
      "...": "..."
    },
    "HardwareError": {
      "...": "..."
    }
  },
  "reactive_results": {
    "ObjectsMissed": {
      "structures": 0,
      "rows": 0
    }
  },
  "falsepositives": {
    "CameraError": 0,
    "FlightError": 0,
    "HardwareError": 0
  },
  "timestamps": {
    "camera_error_input": {},
    "flight_error_input": {},
    "...": "..."
  }
}
```

### 6. Output Visualizations

The analysis script generates several visualizations:
- Error Distribution Analysis - Bar charts showing caught/missed/false positive errors by type
- Success Rate Analysis - Heatmaps showing percentage of successful detections per instance
- Response Time Analysis - Heatmaps showing average error resolution time by instance
- Mode Comparison - Direct comparison of average response times between planned and reactive modes