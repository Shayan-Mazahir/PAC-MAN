class Movement {
  int x, y; // Current grid position
  char direction; // Current direction ('U', 'D', 'L', 'R')

  Movement(int startX, int startY) {
    this.x = startX;
    this.y = startY;
    this.direction = ' '; // Default: No movement
  }

  // Set a new direction
  void setDirection(char newDirection) {
    direction = newDirection;
  }

  // Check if the next move is valid
  boolean canMove(int nextX, int nextY, char[][] maze) {
    // Ensure the next position is within bounds and not a wall
    if (nextX < 0 || nextY < 0 || nextY >= maze.length || nextX >= maze[0].length) {
      return false; // Out of bounds
    }
    return maze[nextY][nextX] != '─' && maze[nextY][nextX] != '│'; // Not a wall
  }

  // Perform movement
  void move(char[][] maze) {
    int nextX = x, nextY = y;

    if (direction == 'U') nextY -= 1;
    else if (direction == 'D') nextY += 1;
    else if (direction == 'L') nextX -= 1;
    else if (direction == 'R') nextX += 1;

    if (canMove(nextX, nextY, maze)) {
      x = nextX;
      y = nextY;
    }
  }
}

//pacman
class PacmanMovement extends Movement {
  PacmanMovement(int startX, int startY) {
    super(startX, startY); // Initialize Pac-Man at start position
  }

  // Handle key presses to update direction
  void handleInput() {
    if (key == CODED) {
      if (keyCode == UP) setDirection('U');
      else if (keyCode == DOWN) setDirection('D');
      else if (keyCode == LEFT) setDirection('L');
      else if (keyCode == RIGHT) setDirection('R');
      //println("Key pressed: " + key + " KeyCode: " + keyCode);
    }
  }

  // Draw Pac-Man at the current position
  void draw(int cellSize, int xOffset, int yOffset) {
    float x = this.x * cellSize + xOffset;
    float y = this.y * cellSize + yOffset;

    fill(255, 255, 0); // Yellow
    noStroke();
    float arcStart = 0.2 * TWO_PI; // Pac-Man starts open
    float arcEnd = 1.8 * TWO_PI; // Pac-Man ends close
    arc(x + cellSize / 2, y + cellSize / 2, cellSize, cellSize, arcStart, arcEnd);
  }
}
