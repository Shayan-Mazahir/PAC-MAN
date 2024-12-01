class Game {
  char[][] maze; // 2D array to store the maze layout
  int cols, rows; // Number of columns and rows in the maze
  int cellSize = 20; // Size of each cell in pixels

  // Constructor to initialize the maze from a string
  Game(String mazeFilePath) {
    // Read the maze from the file
    loadMaze(mazeFilePath);
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

    // Debug: Print the maximum length of the maze rows
    //println("Maximum row length: " + maxLength);

    // Pad rows to the maximum length
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].length() < maxLength) {
        // Pad/replace the row with spaces 
        lines[i] = String.format("%-" + maxLength + "s", lines[i]); 
      }
      // Debug: Print the padded row
      //println("Row " + i + ": " + lines[i]);
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
        // Debug: Print each cell being loaded
        //println("Maze[" + i + "][" + j + "]: " + maze[i][j]);
      }
    }
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

        // Debug: Print the cell being drawn and its position
        //println("Drawing cell '" + cell + "' at (" + x + ", " + y + ")");

        if (cell == '─') {
          // Horizontal wall with rounded edges
          fill(0, 0, 204); // Blue
          noStroke();
          rect(x, y + cellSize / 4, cellSize, cellSize / 2, cellSize / 4);
        } else if (cell == '│') {
          // Vertical wall with rounded edges
          fill(0, 0, 204); // Blue
          noStroke();
          rect(x + cellSize / 4, y, cellSize / 2, cellSize, cellSize / 4);
        } else if (cell == '┌') {
          // Top-left rounded corner
          fill(0, 0, 204); // Blue
          noStroke();
          arc(x + cellSize, y + cellSize, cellSize * 2, cellSize * 2, PI, 3 * PI / 2);
        } else if (cell == '┐') {
          // Top-right rounded corner
          fill(0, 0, 204); // Blue
          noStroke();
          arc(x, y + cellSize, cellSize * 2, cellSize * 2, 3 * PI / 2, TWO_PI);
        } else if (cell == '└') {
          // Bottom-left rounded corner
          fill(0, 0, 204); // Blue
          noStroke();
          arc(x + cellSize, y, cellSize * 2, cellSize * 2, HALF_PI, PI);
        } else if (cell == '┘') {
          // Bottom-right rounded corner
          fill(0, 0, 204); // Blue
          noStroke();
          arc(x, y, cellSize * 2, cellSize * 2, 0, HALF_PI);
        } else if (cell == '·') {
          // Path or pellet
          fill(255); // White
          ellipse(x + cellSize / 2, y + cellSize / 2, cellSize / 4, cellSize / 4);
        } else if (cell == '*') {
          // Power pellet
          fill(255, 255, 0); // Yellow
          ellipse(x + cellSize / 2, y + cellSize / 2, cellSize / 2, cellSize / 2);
        } else {
          // Default fill for other characters
          fill(0); // Black
          noStroke();
          rect(x, y, cellSize, cellSize);
        }
      }
    }
  }
}
