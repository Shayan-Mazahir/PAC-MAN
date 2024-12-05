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
    return maze[nextY][nextX] != '─' && maze[nextY][nextX] != '│' && maze[nextY][nextX] != '┌' && maze[nextY][nextX] != '└' && maze[nextY][nextX] != '┘' && maze[nextY][nextX] != '┐' && maze[nextY][nextX] != '=' ; // Not a wall
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
    // Default direction logic remains unchanged
    if (!moving) {
        if (direction == 'U') {
            targetX = pixelX; // Target X stays the same
            targetY = pixelY - cellSize; // Move up
        } else if (direction == 'D') {
            targetX = pixelX; // Target X stays the same
            targetY = pixelY + cellSize; // Move down
        } else if (direction == 'L') {
            targetX = pixelX - cellSize; // Move left
            targetY = pixelY; // Target Y stays the same
        } else if (direction == 'R') {
            targetX = pixelX + cellSize; // Move right
            targetY = pixelY; // Target Y stays the same
        }

        int gridX = (int)(targetX / cellSize);
        int gridY = (int)(targetY / cellSize);

        // Handle teleportation BEFORE moving (invisible to the player)
        if (gridX < 0) {
            gridX = maze[0].length - 1;
            pixelX = gridX * cellSize;
            targetX = pixelX;
        } else if (gridX >= maze[0].length) {
            gridX = 0;
            pixelX = gridX * cellSize;
            targetX = pixelX;
        }
        if (gridY < 0) {
            gridY = maze.length - 1;
            pixelY = gridY * cellSize;
            targetY = pixelY;
        } else if (gridY >= maze.length) {
            gridY = 0;
            pixelY = gridY * cellSize;
            targetY = pixelY;
        }

        if (canMove(gridX, gridY, maze)) {
            moving = true;
        }
    }

    // Smoothly move Pac-Man towards the target position
    if (moving) {
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

        // Snap to the grid center when reaching the target
        if (pixelX == targetX && pixelY == targetY) {
            moving = false;
            int gridX = (int)(pixelX / cellSize);
            int gridY = (int)(pixelY / cellSize);
            setPosition(gridX, gridY);
        }
    }
}


  // Check if Pac-Man can move to the next grid cell
  boolean canMove(int nextX, int nextY, char[][] maze) {
    if (nextX < 0 || nextY < 0 || nextY >= maze.length || nextX >= maze[0].length) {
      return false; // Out of bounds
    }
    return maze[nextY][nextX] != '─' && maze[nextY][nextX] != '│' && maze[nextY][nextX] != '┌' && maze[nextY][nextX] != '└' && maze[nextY][nextX] != '┘' && maze[nextY][nextX] != '┐' && maze[nextY][nextX] != '='; // Not a wall
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
