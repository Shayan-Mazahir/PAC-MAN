class Game {
  char[][] originalMaze; // 2D array to store the original maze layout
  char[][] maze; // 2D array to store the scaled maze layout
  int cols, rows; // Number of columns and rows in the scaled maze
  int cellSize = 20; // Size of each cell in pixels
  
  // Constructor to initialize the maze from a string
  Game(String mazeFilePath) {
    // Read and scale the maze from the file
    loadAndScaleMaze(mazeFilePath);
  }
  
  // Load the maze from a file and scale it down
  void loadAndScaleMaze(String mazeFilePath) {
    // Read the original maze text file into a string array
    String[] lines = loadStrings(mazeFilePath);
    
    int originalRows = lines.length;          // Number of rows in the original maze
    int originalCols = lines[0].length();     // Number of columns in the original maze
    
    // Scaling factor: 3x3 blocks become 1x1 block
    int scaleFactor = 3;
    
    // Calculate scaled maze dimensions
    rows = originalRows / scaleFactor;  // Number of rows in the scaled maze
    cols = originalCols / scaleFactor;  // Number of columns in the scaled maze
    
    originalMaze = new char[originalRows][originalCols];
    maze = new char[rows][cols];
    
    // Populate the original maze 2D array with characters from the text file
    for (int i = 0; i < originalRows; i++) {
      for (int j = 0; j < originalCols; j++) {
        originalMaze[i][j] = lines[i].charAt(j);
      }
    }
    
    // Scale down the maze by taking every 3x3 block and converting it to a single cell
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Use the top-left corner of the 3x3 block for the scaled representation
        char mazeSection = originalMaze[row * scaleFactor][col * scaleFactor];
        if (mazeSection == '@' || mazeSection == '%') {
          maze[row][col] = mazeSection; // Preserve the character (@ or %)
        } else {
          maze[row][col] = ' ';  // If empty, add space (for visual representation)
        }
      }
    }
  }
  
  // Display the maze
  void display() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (maze[i][j] == '%') {
          fill(0); // Wall - black
        } else if (maze[i][j] == '@') {
          fill(255); // Path - white
        } else {
          fill(200); // Background color for empty cells (light gray)
        }
        noStroke();
        rect(j * cellSize, i * cellSize, cellSize, cellSize);
      }
    }
  }
}
