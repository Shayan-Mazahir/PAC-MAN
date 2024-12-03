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

  // Perform movement (adjusted to pixel movement)
  void move(char[][] maze) {
    // Default implementation here if needed
  }
}

// PacmanMovement class extending Movement class
class PacmanMovement extends Movement {
  float pixelX, pixelY; // Precise position
  float moveSpeed; // Speed of movement
  float targetX, targetY; // Target pixel position
  
  PacmanMovement(int startX, int startY, float speed) {
    super(startX, startY);
    this.pixelX = startX * 20; // Convert grid to pixels
    this.pixelY = startY * 20; // Convert grid to pixels
    this.targetX = this.pixelX;
    this.targetY = this.pixelY;
    this.moveSpeed = speed;
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

  // Update position, not bound to grid anymore
  void move(char[][] maze) {
    // Move Pac-Man in the direction at the desired speed
    if (direction == 'U') pixelY -= moveSpeed;
    else if (direction == 'D') pixelY += moveSpeed;
    else if (direction == 'L') pixelX -= moveSpeed;
    else if (direction == 'R') pixelX += moveSpeed;
    
    // Ensure that we don't go out of bounds
    if (pixelX < 0) pixelX = 0;
    if (pixelY < 0) pixelY = 0;
    if (pixelX >= maze[0].length * 20) pixelX = maze[0].length * 20 - 1; // Avoid going out of right bound
    if (pixelY >= maze.length * 20) pixelY = maze.length * 20 - 1; // Avoid going out of bottom bound

    // Use maze collision detection to stop if Pac-Man moves into a wall
    int nextX = (int)(pixelX / 20); // Convert back to grid for collision check
    int nextY = (int)(pixelY / 20); // Convert back to grid for collision check

    if (!canMove(nextX, nextY, maze)) {
      // If move is invalid (collides with a wall), stop movement by reversing
      if (direction == 'U') pixelY += moveSpeed;
      else if (direction == 'D') pixelY -= moveSpeed;
      else if (direction == 'L') pixelX += moveSpeed;
      else if (direction == 'R') pixelX -= moveSpeed;
    }
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
