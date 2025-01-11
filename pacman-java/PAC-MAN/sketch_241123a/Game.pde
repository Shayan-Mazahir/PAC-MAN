import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.HashSet;
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
  // Helper: Get all valid moves from the current position
  PVector[] getValidMoves(PVector position) {
    PVector[] moves = {
      new PVector(0, -1), // Up
      new PVector(0, 1), // Down
      new PVector(-1, 0), // Left
      new PVector(1, 0)   // Right
    };

    ArrayList<PVector> validMoves = new ArrayList<>();

    for (PVector move : moves) {
      int moveX = (int) (position.x + move.x);
      int moveY = (int) (position.y + move.y);

      // Check maze boundaries and wall collisions
      if (moveX >= 0 && moveX < cols &&
        moveY >= 0 && moveY < rows &&
        maze[moveY][moveX] != '│' &&
        maze[moveY][moveX] != '─' &&
        maze[moveY][moveX] != '┘' &&
        maze[moveY][moveX] != '└' &&
        maze[moveY][moveX] != '┌' &&
        maze[moveY][moveX] != '┐') {
        validMoves.add(move);
      }
    }

    return validMoves.toArray(new PVector[0]);
  }
  class Node {
    PVector position;
    float gCost; // Cost from start
    float hCost; // Heuristic cost to goal (Pac-Man)
    float fCost; // Total cost (g + h)
    Node parent; // For path reconstruction

    Node(PVector position, float gCost, float hCost, Node parent) {
      this.position = position;
      this.gCost = gCost;
      this.hCost = hCost;
      this.fCost = gCost + hCost;
      this.parent = parent;
    }
  }

  int ghostMoveCounter = 0;
  int ghostSpeed = 2;
  PVector redGhostDirection = new PVector(0, 0); // Declare this at the start of the moveRedGhost() method

  void moveRedGhost() {
    ghostMoveCounter++;
    if (ghostMoveCounter % ghostSpeed != 0) {
      return;
    }

    if (redGhostPosition != null && pacman != null) {
      int targetX = pacman.x;
      int targetY = pacman.y;

      // A* pathfinding setup
      //PriorityQueue<Node> openList = new PriorityQueue<>(Comparator.comparingFloat(n -> n.fCost));
      PriorityQueue<Node> openList = new PriorityQueue<Node>(new Comparator<Node>() {
        @Override
          public int compare(Node n1, Node n2) {
          return Float.compare(n1.fCost, n2.fCost);
        }
      }
      );

      HashSet<PVector> closedList = new HashSet<>();

      openList.add(new Node(redGhostPosition, 0, dist(redGhostPosition.x, redGhostPosition.y, targetX, targetY), null));

      while (!openList.isEmpty()) {
        Node currentNode = openList.poll();
        PVector currentPos = currentNode.position;

        if (currentPos.x == targetX && currentPos.y == targetY) {
          // Path found, reconstruct the path and move the ghost
          Node pathNode = currentNode;
          while (pathNode != null) {
            //PVector redGhostDirection = new PVector(0, 0); // Declare this at the start of the moveRedGhost() method

            redGhostDirection = pathNode.position.copy().sub(redGhostPosition); // Move in the direction of the last node
            redGhostPosition.set(pathNode.position); // Update position
            pathNode = pathNode.parent;
          }
          return;
        }

        closedList.add(currentPos);

        for (PVector move : getValidMoves(currentPos)) {
          if (closedList.contains(move)) continue;

          float gCost = currentNode.gCost + 1; // Assume uniform cost for each move
          float hCost = dist(move.x, move.y, targetX, targetY);
          Node neighborNode = new Node(move, gCost, hCost, currentNode);

          if (!openList.contains(neighborNode) || gCost < neighborNode.gCost) {
            openList.add(neighborNode);
          }
        }
      }
    }
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
