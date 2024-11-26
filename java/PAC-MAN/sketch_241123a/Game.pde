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
    // Read the maze text file into a string
    String[] lines = loadStrings(mazeFilePath);
    
    rows = lines.length; // Number of rows is the number of lines
    cols = lines[0].length(); // Number of columns is the length of the first line
    
    maze = new char[rows][cols];
    
    // Populate the maze 2D array with characters from the text file
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        maze[i][j] = lines[i].charAt(j);
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
        }
        noStroke();
        rect(j * cellSize, i * cellSize, cellSize, cellSize);
      }
    }
  }
}
