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
    return maze[nextY][nextX] != '─' && maze[nextY][nextX] != '│' && maze[nextY][nextX] != '┌' && maze[nextY][nextX] != '└' && maze[nextY][nextX] != '┘'; // Not a wall
  }

  // Perform movement (adjusted to pixel movement)
  void move(char[][] maze) {
    // Default implementation here if needed
  }
}

// PacmanMovement class extending Movement class
class PacmanMovement extends Movement {
  float cellSize = 20.0f; // Size of the grid cell in pixels
  float pixelX, pixelY; // Pacman's current pixel position
  float targetX, targetY; // Target pixel positions
  float moveSpeed; // Speed of movement
  boolean moving; // Whether Pac-Man is moving towards a target

  PacmanMovement(int startX, int startY, float speed) {
    super(startX, startY);
    this.pixelX = startX * cellSize; // Convert grid to pixels (Pac-Man's center)
    this.pixelY = startY * cellSize; // Convert grid to pixels
    this.targetX = pixelX;
    this.targetY = pixelY;
    this.moveSpeed = speed;
    this.moving = false;
  }

  // Handle input for direction
  void handleInput() {
    if (key == CODED) {
      if (keyCode == UP) setDirection('U');
      else if (keyCode == DOWN) setDirection('D');
      else if (keyCode == LEFT) setDirection('L');
      else if (keyCode == RIGHT) setDirection('R');
    }
  }

  // Update position based on movement direction
  void move(char[][] maze) {
    if (!moving) {
      // If Pac-Man isn't moving, start moving in the selected direction
      if (direction == 'U') {
        targetX = pixelX; // Target X stays the same
        targetY = pixelY - cellSize; // Move up to the previous row
      } else if (direction == 'D') {
        targetX = pixelX; // Target X stays the same
        targetY = pixelY + cellSize; // Move down to the next row
      } else if (direction == 'L') {
        targetX = pixelX - cellSize; // Move left to the previous column
        targetY = pixelY; // Target Y stays the same
      } else if (direction == 'R') {
        targetX = pixelX + cellSize; // Move right to the next column
        targetY = pixelY; // Target Y stays the same
      }
      
      // Check if the move is valid and update movement status
      int gridX = (int)(targetX / cellSize);
      int gridY = (int)(targetY / cellSize);
      if (canMove(gridX, gridY, maze)) {
        moving = true;
      }
    }

    // Smoothly move Pac-Man towards the target position
    if (moving) {
      // Move Pac-Man towards the target pixel position
      if (abs(pixelX - targetX) > moveSpeed) {
        pixelX += (targetX - pixelX) / abs(targetX - pixelX) * moveSpeed;
      } else {
        pixelX = targetX;
      }

      if (abs(pixelY - targetY) > moveSpeed) {
        pixelY += (targetY - pixelY) / abs(targetY - pixelY) * moveSpeed;
      } else {
        pixelY = targetY;
      }

      // Once Pac-Man reaches the target, stop moving and snap to the grid
      if (pixelX == targetX && pixelY == targetY) {
        moving = false;
        int gridX = (int)(pixelX / cellSize);
        int gridY = (int)(pixelY / cellSize);
        setPosition(gridX, gridY); // Snap Pac-Man to the grid center
      }
    }
  }

  // Check if Pac-Man can move to the next grid cell
  boolean canMove(int nextX, int nextY, char[][] maze) {
    if (nextX < 0 || nextY < 0 || nextY >= maze.length || nextX >= maze[0].length) {
      return false; // Out of bounds
    }
    return maze[nextY][nextX] != '─' && maze[nextY][nextX] != '│' && maze[nextY][nextX] != '┌' && maze[nextY][nextX] != '└' && maze[nextY][nextX] != '┘'; // Not a wall
  }

  // Snap Pac-Man's position to the center of the grid
  void setPosition(int gridX, int gridY) {
    pixelX = gridX * cellSize;
    pixelY = gridY * cellSize;
  }

  // Draw Pac-Man at the current pixel position
  void draw(int cellSize, int xOffset, int yOffset) {
    float drawX = pixelX + xOffset;
    float drawY = pixelY + yOffset;
    fill(255, 255, 0); // Yellow
    noStroke();
    float arcStart = 0.2 * TWO_PI;
    float arcEnd = 1.8 * TWO_PI;
    arc(drawX + cellSize / 2, drawY + cellSize / 2, cellSize, cellSize, arcStart, arcEnd);
  }
}
