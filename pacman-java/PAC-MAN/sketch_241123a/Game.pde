//need to work on this more
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
  
    // Pad rows to the maximum length
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].length() < maxLength) {
        // Pad the row with spaces or walls (you can choose the padding character)
        lines[i] = String.format("%-" + maxLength + "s", lines[i]).replace(' ', '·'); // Replace spaces with dots
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

  
  // Display the maze
  void display() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        char cell = maze[i][j];
        
        if ("─│┌┐└┘├┴┬┤".indexOf(cell) != -1) {
          fill(0); // Wall characters - black
        } else if ("·".indexOf(cell) != -1) {
          fill(255); // Empty path - white
        } else if ("*".indexOf(cell) != -1) {
          fill(255, 0, 0); // Power pellet - red
        } else if ("═║╔╗╚╝ ╠╩╦╣".indexOf(cell) != -1) {
          fill(0, 0, 255); // Ghost gates - blue
        } else {
          fill(0, 255, 0); // Other elements (optional) - green
        }
        
        noStroke();
        rect(j * cellSize, i * cellSize, cellSize, cellSize);
      }
    }
  }
  
  // Helper function to load the maze from a file
  //String[] loadStrings(String filePath) {
  //  // Simulating file loading in this context (for example purposes)
  //  return new String[] {
  //    "┌────────────┐┌────────────┐",
  //    "│············││············│",
  //    "│·┌──┐·┌───┐·││·┌───┐·┌──┐·│",
  //    "│*│  │·│   │·││·│   │·│  │*│",
  //    "│·└──┘·└───┘·└┘·└───┘·└──┘·│",
  //    "│··························│",
  //    "│·┌──┐·┌┐·┌──────┐·┌┐·┌──┐·│",
  //    "│·└──┘·││·└──┐┌──┘·││·└──┘·│",
  //    "│······││····││····││······│",
  //    "└────┐·│└──┐ ││ ┌──┘│·┌────┘",
  //    "     │·│┌──┘ └┘ └──┐│·│",
  //    "     │·││    BB    ││·│",
  //    "     │·││ ┌──══──┐ ││·│",
  //    "─────┘·└┘ │      │ └┘·└─────",
  //    "X     ·   │IIPPCC│   ·     X",
  //    "─────┐·┌┐ │      │ ┌┐·┌─────",
  //    "     │·││ └──────┘ ││·│",
  //    "     │·││    FF    ││·│",
  //    "     │·││ ┌──────┐ ││·│",
  //    "┌────┘·└┘ └──┐┌──┘ └┘·└────┐",
  //    "│············││············│",
  //    "│·┌──┐·┌───┐·││·┌───┐·┌──┐·│",
  //    "│·└─┐│·└───┘·└┘·└───┘·│┌─┘·│",
  //    "│*··││·······OO·······││··*│",
  //    "└─┐·││·┌┐·┌──────┐·┌┐·││·┌─┘",
  //    "┌─┘·└┘·││·└──┐┌──┘·││·└┘·└─┐",
  //    "│······││····││····││······│",
  //    "│·┌────┘└──┐·││·┌──┘└────┐·│",
  //    "│·└────────┘·└┘·└────────┘·│",
  //    "│··························│",
  //    "└──────────────────────────┘"
  //  };
  //}
}
