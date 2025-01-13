import java.util.*;
class Game {
  //import java.util.PriorityQueue;
  char[][] maze; // 2D array to store the maze layout
  int cols, rows; // Number of columns and rows in the maze
  int cellSize = 20; // Size of each cell in pixels
  PacmanMovement pacman; // Loading pacman class
  PImage backArrow;
  String mazeFile;
  PacmanMovement score;
  int currentScore;

  // Ghosts
  GhostSprites blueGhost = new GhostSprites("blue");
  GhostSprites redGhost = new GhostSprites("red");
  GhostSprites pinkGhost = new GhostSprites("pink");
  GhostSprites orangeGhost = new GhostSprites("orange");

  // Ghost positions
  PVector blueGhostPosition;
  PVector redGhostPosition;
  PVector pinkGhostPosition;
  PVector orangeGhostPosition;

  int xOffset, yOffset; // Offsets to position the maze at the center bottom

  // Frame counters for animation
  int frameCounter = 0;
  int animationSpeed = 10;
  int currentFrame = 0;

  FontManager fontManager;
  PApplet app;

  // READY! screen variables
  boolean showReadyScreen = true;
  int readyScreenDuration = 2000; // Duration in milliseconds
  int readyStartTime;

  // Constructor to initialize the maze from a string
  Game(PApplet app, String mazeFilePath) {
    currentScore = 0;
    this.app = app;
    fontManager = new FontManager(app, "../assets/fonts/ARCADECLASSIC.TTF", 24);
    // Read the maze from the file
    loadMaze(mazeFilePath);
    // Load back arrow
    backArrow = loadImage("../assets/left-arrow.png");

    // Find Pac-Man and ghost starting positions
    int pacmanX = -1, pacmanY = -1;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        char cell = maze[i][j];
        if (cell == 'p') {
          pacmanX = j;
          pacmanY = i;
        } else if (cell == 'b') {
          blueGhostPosition = new PVector(j, i);
        } else if (cell == 'r') {
          redGhostPosition = new PVector(j, i);
        } else if (cell == 'g') {
          pinkGhostPosition = new PVector(j, i);
        } else if (cell == 'o') {
          orangeGhostPosition = new PVector(j, i);
        }
      }
    }

    // If "p" is found, initialize Pac-Man's position at that point
    if (pacmanX != -1 && pacmanY != -1) {
      pacman = new PacmanMovement(pacmanX, pacmanY, 1, currentScore);
    } else {
      println("Pac-Man ('p') not found in the maze!");
    }

    // Calculate the offset to center the maze at the bottom
    xOffset = (width - cols * cellSize) / 2; // Horizontal centering
    yOffset = height - rows * cellSize; // Vertical alignment at the bottom

    // Record the start time for the "READY!" screen
    readyStartTime = millis();
  }

  // Load the maze from a file
  void loadMaze(String mazeFilePath) {
    String[] lines = loadStrings(mazeFilePath);

    // Determine the maximum length of the rows
    int maxLength = 0;
    for (String line : lines) {
      if (line.length() > maxLength) {
        maxLength = line.length();
      }
    }

    // Pad rows to the maximum length
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].length() < maxLength) {
        lines[i] = String.format("%-" + maxLength + "s", lines[i]);
      }
    }

    rows = lines.length;
    cols = maxLength;
    maze = new char[rows][cols];

    // Populate the maze 2D array
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        maze[i][j] = lines[i].charAt(j);
      }
    }
  }

  // Display the "READY!" screen
  void displayReadyScreen() {
    background(0);
    fontManager.applyFont(app);
    fill(255, 255, 0); // Yellow color for "READY!"
    textAlign(CENTER, CENTER);
    text("READY!", width / 2, height / 2);
  }

  // Display the maze
  void display() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        char cell = maze[i][j];
        float x = xOffset + j * cellSize;
        float y = yOffset + i * cellSize;


        if (cell == '=') {
          //Horizontal wall for the "door"
          stroke(255, 106, 213);
          strokeWeight(5);
          line(x, y + cellSize / 2, x + cellSize, y + cellSize / 2);
        } else if (cell == '─') {
          // Horizontal wall using a thick line
          stroke(0, 0, 204); // Blue color for walls
          strokeWeight(cellSize / 2); // Thickness of the wall
          line(x, y + cellSize / 2, x + cellSize, y + cellSize / 2); // Horizontal line
        } else if (cell == '│') {
          // Vertical wall using a thick line
          stroke(0, 0, 204); // Blue color for walls
          strokeWeight(cellSize / 2); // Thickness of the wall
          line(x + cellSize / 2, y, x + cellSize / 2, y + cellSize); // Vertical line
        } else if (cell == '┌' || cell == '┐' || cell == '└' || cell == '┘') {
          // Corner walls using arcs
          stroke(0, 0, 204); // Blue
          strokeWeight(cellSize / 2); // Thickness of the arc
          noFill(); // Only need stroke for arcs

          // Draw arcs for rounded corners
          float roundness = 1; // Roundness of the corner
          if (cell == '┌') {
            arc(x + cellSize, y + cellSize, cellSize * roundness, cellSize * roundness, PI, 3 * PI / 2); // Top-left
          } else if (cell == '┐') {
            arc(x, y + cellSize, cellSize * roundness, cellSize * roundness, 3 * PI / 2, TWO_PI); // Top-right
          } else if (cell == '└') {
            arc(x + cellSize, y, cellSize * roundness, cellSize * roundness, HALF_PI, PI); // Bottom-left
          } else if (cell == '┘') {
            arc(x, y, cellSize * roundness, cellSize * roundness, 0, HALF_PI); // Bottom-right
          }
        } else if (cell == '·') {
          // Path or pellet
          fill(255); // White
          noStroke();
          ellipse(x + cellSize / 2, y + cellSize / 2, cellSize / 4, cellSize / 4);
        } else if (cell == '*') {
          // Power pellet
          fill(255, 255, 0); // Yellow
          noStroke();
          ellipse(x + cellSize / 2, y + cellSize / 2, cellSize / 2, cellSize / 2);
        } else {
          // Default fill for other characters
          fill(0); // Black
          noStroke();
          rect(x, y, cellSize, cellSize);
        }
      }
    }

    fontManager.applyFont(app);

    // Display high score at the top-right corner
    fill(255); // White text color
    text("Current Score " + currentScore, width / 2, 30); // Adjust the position as needed
    displayBackArrow();
    checkBackArrowClick();
  }

  void displayBackArrow() {
    float backArrowX = 10;
    float backArrowY = 10;
    image(backArrow, backArrowX, backArrowY, 100, 50);
  }

  void checkBackArrowClick() {
    float backArrowX = 10, backArrowY = 10, backArrowWidth = 100, backArrowHeight = 50;

    if (mousePressed &&
      mouseX > backArrowX && mouseX < backArrowX + backArrowWidth &&
      mouseY > backArrowY && mouseY < backArrowY + backArrowHeight) {
      gameStarted = false;
    }
  }

  //ghosts
  int ghostMoveCounter = 0;
  float ghostSpeed = 7;
  //PVector redGhostDirection = new PVector(0, 0);
  char redGhostDirection;

  //void moveRedGhost() {
  //    ghostMoveCounter++;
  //    if (ghostMoveCounter % ghostSpeed != 0) {
  //        return;
  //    }

  //    if (redGhostPosition == null || pacman == null) return;

  //    // Always get fresh positions
  //    PVector pacmanPos = new PVector(pacman.x, pacman.y);

  //    // Calculate new path every time
  //    List<PVector> path = bfs(redGhostPosition, pacmanPos);

  //    if (path != null && path.size() > 1) {
  //        // Move to next position in path
  //        PVector nextPos = path.get(1);

  //        // Update direction before moving
  //        if (nextPos.x > redGhostPosition.x) redGhostDirection = 'R';
  //        else if (nextPos.x < redGhostPosition.x) redGhostDirection = 'L';
  //        else if (nextPos.y > redGhostPosition.y) redGhostDirection = 'D';
  //        else if (nextPos.y < redGhostPosition.y) redGhostDirection = 'U';

  //        // Update position
  //        redGhostPosition.set(nextPos);

  //        // Update animation
  //        redGhost.direction = redGhostDirection;
  //        redGhost.update(maze);
  //    }
  //}
  void moveRedGhost() {
    ghostMoveCounter++;
    if (ghostMoveCounter % ghostSpeed != 0) {
      return;
    }

    if (redGhostPosition != null && pacman != null) {
      // Get current pacman position
      PVector pacmanPos = new PVector(pacman.x, pacman.y);

      // Always recalculate the path to current Pacman position
      List<PVector> path = bfs(redGhostPosition, pacmanPos);

      // Make sure there is a valid path to follow
      if (!path.isEmpty() && path.size() > 1) {
        PVector target = path.get(1); // Next point in the path

        // Calculate the direction vector
        PVector directionVec = PVector.sub(target, redGhostPosition);

        // Normalize direction and scale by speed
        directionVec.normalize().mult(ghostSpeed / 10.0);

        // Update direction character based on movement
        if (Math.abs(directionVec.x) > Math.abs(directionVec.y)) {
          redGhostDirection = (directionVec.x > 0) ? 'R' : 'L';
        } else {
          redGhostDirection = (directionVec.y > 0) ? 'D' : 'U';
        }

        // Update position
        redGhostPosition.add(directionVec);

        // Snap to grid if very close to target
        if (redGhostPosition.dist(target) < ghostSpeed / 10.0) {
          redGhostPosition.set(target);
        }

        // Update the ghost's animation
        redGhost.direction = redGhostDirection;
        redGhost.update(maze);
      }
    }
  }

  List<PVector> bfs(PVector start, PVector goal) {
    // Initialize BFS structures
    Queue<PVector> queue = new LinkedList<>();
    Map<PVector, PVector> parentMap = new HashMap<>(); // To reconstruct the path
    Set<PVector> visited = new HashSet<>();
    List<PVector> directions = Arrays.asList(
      new PVector(0, -1), // Up
      new PVector(0, 1), // Down
      new PVector(-1, 0), // Left
      new PVector(1, 0)   // Right
      );

    queue.offer(start);
    visited.add(start);
    parentMap.put(start, null); // No parent for the start position

    while (!queue.isEmpty()) {
      PVector current = queue.poll();

      // If we reached the goal, reconstruct the path
      if (current.equals(goal)) {
        List<PVector> path = new ArrayList<>();
        PVector step = goal;
        while (step != null) {
          path.add(step);
          step = parentMap.get(step);
        }
        Collections.reverse(path); // Reverse the path to get it from start to goal
        return path;
      }

      // Explore all neighboring cells
      for (PVector direction : directions) {
        PVector neighbor = new PVector(current.x + direction.x, current.y + direction.y);

        // Check if neighbor is within bounds and not a wall
        if (isValidPosition(neighbor) && !visited.contains(neighbor)) {
          queue.offer(neighbor);
          visited.add(neighbor);
          parentMap.put(neighbor, current); // Track the parent to reconstruct the path
        }
      }
    }

    return new ArrayList<>(); // Return an empty list if no path is found
  }

  boolean isValidPosition(PVector pos) {
    if (pos.x < 0 || pos.x >= cols || pos.y < 0 || pos.y >= rows) {
      return false; // Out of bounds
    }
    char cell = maze[(int) pos.y][(int) pos.x];
    return cell != '─' && cell != '│' && cell != '=' && cell != '┌' && cell != '┐' && cell != '└' && cell != '┘'; // Not a wall
  }



  // Draw a ghost at a specific position
  void drawGhost(float x, float y, char direction, int animationFrame, GhostSprites ghost) {
    image(ghost.getSprite(direction, animationFrame), x, y, cellSize, cellSize);
  }

  // Update ghost animations
  void updateGhostAnimation() {
    frameCounter++;
    if (frameCounter >= animationSpeed) {
      frameCounter = 0;
      currentFrame = (currentFrame + 1) % 2; // Toggle between frames
    }
  }

  // Draw ghosts at their respective positions
  void drawGhosts() {
    if (blueGhostPosition != null) {
      drawGhost(xOffset + blueGhostPosition.x * cellSize, yOffset + blueGhostPosition.y * cellSize, 'D', currentFrame, blueGhost);
    }
    if (redGhostPosition != null) {
      drawGhost(xOffset + redGhostPosition.x * cellSize, yOffset + redGhostPosition.y * cellSize, 'D', currentFrame, redGhost);
    }
    if (pinkGhostPosition != null) {
      drawGhost(xOffset + pinkGhostPosition.x * cellSize, yOffset + pinkGhostPosition.y * cellSize, 'D', currentFrame, pinkGhost);
    }
    if (orangeGhostPosition != null) {
      drawGhost(xOffset + orangeGhostPosition.x * cellSize, yOffset + orangeGhostPosition.y * cellSize, 'D', currentFrame, orangeGhost);
    }
  }

  void update() {

    if (showReadyScreen) {
      displayReadyScreen();
      if (millis() - readyStartTime > readyScreenDuration) {
        showReadyScreen = false; // Transition to game after delay
      }
    } else {

      background(0);
      pacman.move(maze);
      currentScore = pacman.score;
      currentScore = pacman.score;      // Synchronize the score
      display();
      pacman.draw(cellSize, xOffset, yOffset);
      moveRedGhost(); // Move the red ghost
      updateGhostAnimation();
      //drawGhosts();
      drawGhosts();
    }
  }

  void keyPressed() {
    pacman.handleInput();
  }
}
