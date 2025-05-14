# Autonomous Cognitive Load

Evaluation of the Cognitive Load of Planned Autonomy vs Reactive Autonomy for Impacts to Safety Performance.

## Project Overview

This project investigates the differences in cognitive load and safety performance between two types of autonomous control:

1. **Planned Autonomy** - A pre-determined flight path that the drone follows
2. **Reactive Autonomy** - A flight path that changes reactively during operation

The experiment uses a simulated drone environment where participants monitor for errors in both control modes. Data is collected on error detection rates, response times, and false positives to evaluate differences in cognitive load and safety performance.

## Project Component

- **Simulation**: Godot-based interactive drone simulation with error events
- **Data Analysis**: Python/Quarto-based analysis of participant performance data
- **Published Website**: GitHub Pages site presenting research results and interactive simulation

## Running the Project

### Simulation

To run the simulation locally:
```bash
# Open the Godot project
cd src/godot
godot project.godot
```

To try the simulation without installing Godot, visit the web version at:
[https://ucdrones-research.github.io/autonomous_cognitive_load/simulation/simulation.html](https://ucdrones-research.github.io/autonomous_cognitive_load/simulation/simulation.html)

### Data Analysis

To review or update the analysis:
```bash
# Navigate to the data analysis directory
cd src/data-analysis

# Build the Quarto site
quarto render

# Preview the site locally
quarto preview
```

The analysis is also published on the GitHub Pages website.

## Updating the Project

### Adding Participant Data

1. Place new JSON data files in `src/data-analysis/data/`
2. Files should follow the naming pattern: `[ID]-[DATE]-[TYPE].json` where TYPE is either "planned" or "reactive"
3. Rebuild the analysis to include the new data

### Modifying the Simulation

1. Edit the relevant Godot scripts and scenes in `src/godot/`
2. Test locally to ensure changes work as expected
3. Export the simulation using Godot's export feature:
   - Project > Export > Select "simulation" preset > Export Project

### Updating GitHub Pages

After making changes to either the simulation or analysis:

1. Build the updated Quarto site:
```bash
cd src/data-analysis
quarto render
```

2. Copy the updated files to the docs directory:
```bash
# For analysis updates
cp -r _site/* ../../docs/

# For simulation updates (if exported to src/godot/export/)
cp -r ../godot/export/* ../../docs/simulation/
```

3. Commit and push the changes to GitHub:
```bash
git add docs/
git commit -m "Update published site with latest changes"
git push
```

The updates will be available on the GitHub Pages site shortly after pushing.

## Project Structure

- `src/`: Source files
  - `src/godot/`: Godot simulation source
  - `src/data-analysis/`: Quarto site and Python analysis code
- `docs/`: GitHub Pages published files
  - Research analysis
  - Interactive simulation