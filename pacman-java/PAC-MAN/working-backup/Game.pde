class Game {
  char[][] maze; // 2D array to store the maze layout
  int cols, rows; // Number of columns and rows in the maze
  int cellSize = 20; // Size of each cell in pixels
  PacmanMovement pacman; // Loading pacman class

  // Constructor to initialize the maze from a string
  Game(String mazeFilePath) {
    // Read the maze from the file
    loadMaze(mazeFilePath);
    // Find the 'p' character in the maze to initialize Pac-Man's starting position
    initializePacmanPosition();
  }

  // Load the maze from a file
  void loadMaze(String mazeFilePath) {
    // Read the maze text file into a string array
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

    // Now, you can safely assume all rows are of the same length
    rows = lines.length;
    cols = maxLength;

    // Initialize the maze array
    maze = new char[rows][cols];

    // Populate the maze 2D array with characters from the text file
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        maze[i][j] = lines[i].charAt(j);
      }
    }
  }

  // Find the starting position of Pac-Man (the letter 'p') and initialize pacman
  void initializePacmanPosition() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (maze[i][j] == 'p') {
          // Initialize Pac-Man at the position where 'p' is located
          pacman = new PacmanMovement(j, i); // Pass column and row as the starting position
          return; // Exit the function once we find the 'p'
        }
      }
    }
    // If no 'p' is found, initialize Pac-Man at a default position (optional)
    pacman = new PacmanMovement(1, 1); // Default position if no 'p' is found
  }

  // Display the maze
  void display() {
    int yOffset = 100; // Vertical offset for the maze
    int xOffset = (width - cols * cellSize) / 2; // Horizontal offset for centering

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        char cell = maze[i][j];
        float x = j * cellSize + xOffset;
        float y = i * cellSize + yOffset;

        if (cell == '─') {
          // Horizontal wall (simple straight line)
          fill(0, 0, 204); // Blue
          noStroke();
          rect(x, y + cellSize / 4, cellSize, cellSize / 2); // Straight line for horizontal walls
        } else if (cell == '│') {
          // Vertical wall (simple straight line)
          fill(0, 0, 204); // Blue
          noStroke();
          rect(x + cellSize / 4, y, cellSize / 2, cellSize); // Straight line for vertical walls
        } else if (cell == '┌' || cell == '┐' || cell == '└' || cell == '┘') {
          // Corner with rounded edges using arcs
          fill(0, 0, 204); // Blue
          noStroke();

          // Apply arcs for the corners
          float roundness = cellSize / 1.45; // Roundness of the corner
          if (cell == '┌') {
            arc(x + cellSize, y + cellSize, roundness * 2, roundness * 2, PI, 3 * PI / 2); // Top-left corner
          } else if (cell == '┐') {
            arc(x, y + cellSize, roundness * 2, roundness * 2, 3 * PI / 2, TWO_PI); // Top-right corner
          } else if (cell == '└') {
            arc(x + cellSize, y, roundness * 2, roundness * 2, HALF_PI, PI); // Bottom-left corner
          } else if (cell == '┘') {
            arc(x, y, roundness * 2, roundness * 2, 0, HALF_PI); // Bottom-right corner
          }
        } else if (cell == '·') {
          // Path or pellet
          fill(255); // White
          ellipse(x + cellSize / 2, y + cellSize / 2, cellSize / 4, cellSize / 4);
        } else if (cell == '*') {
          // Power pellet
          fill(255, 255, 0); // Yellow
          ellipse(x + cellSize / 2, y + cellSize / 2, cellSize / 2, cellSize / 2);
        } 
        //else if (cell == 'p') {
        //  // "pm" detected, draw Pac-Man as an arc
        //  fill(255, 255, 0); // Yellow
        //  noStroke();
        //  float arcStart = 0.2 * TWO_PI;  // Pac-Man starts open
        //  float arcEnd = 1.8 * TWO_PI;  // Pac-Man ends close (90% of the circle)
        //  arc(x + cellSize / 2, y + cellSize / 2, cellSize, cellSize, arcStart, arcEnd);
        //} 
        else {
          // Default fill for other characters
          fill(0); // Black
          noStroke();
          rect(x, y, cellSize, cellSize);
        }
      }
    }
  }

  // Update function to manage the game loop
  void update() {
    background(0); // Clear the screen
    pacman.move(maze); // Move Pac-Man
    display(); // Redraw the maze
    pacman.draw(cellSize, (width - cols * cellSize) / 2, 100); // Draw Pac-Man
  }

  void keyPressed() {
    pacman.handleInput();
    //println("Key pressed in Game class: " + key + ", " + keyCode);
  }
}
