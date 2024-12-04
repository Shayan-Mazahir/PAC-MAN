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
  float cellSize = 20.0f;
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
    float prevPixelX = pixelX;
    float prevPixelY = pixelY;

    // Move Pac-Man in the direction at the desired speed
    if (direction == 'U') pixelY -= moveSpeed;
    else if (direction == 'D') pixelY += moveSpeed;
    else if (direction == 'L') pixelX -= moveSpeed;
    else if (direction == 'R') pixelX += moveSpeed;

    // Bound checks remain the same
    if (pixelX < 0) pixelX = 0;
    if (pixelY < 0) pixelY = 0;
    if (pixelX >= maze[0].length * 20) pixelX = maze[0].length * 20 - 1;
    if (pixelY >= maze.length * 20) pixelY = maze.length * 20 - 1;

    int gridX = (int)(pixelX / 20);
    int gridY = (int)(pixelY / 20);

    boolean wallCollision = false;
    float diameter = cellSize;

    // Check surrounding grid cells for wall characters
    for (int offsetX = -1; offsetX <= 1; offsetX++) {
      for (int offsetY = -1; offsetY <= 1; offsetY++) {
        int checkX = gridX + offsetX;
        int checkY = gridY + offsetY;

        // Bound check
        if (checkX >= 0 && checkY >= 0 &&
          checkX < maze[0].length && checkY < maze.length) {

          if (maze[checkY][checkX] == '─') {
            // Horizontal wall
            float wallY = checkY * 20 + cellSize / 4;
            if (abs(pixelY - wallY) < cellSize / 2) {
              wallCollision = true;
              break;
            }
          } else if (maze[checkY][checkX] == '│') {
            // Vertical wall
            float wallX = checkX * 20 + cellSize / 4;
            if (abs(pixelX - wallX) < cellSize / 2) {
              wallCollision = true;
              break;
            }
          } else if (maze[checkY][checkX] == '┌' || maze[checkY][checkX] == '┐' ||
            maze[checkY][checkX] == '└' || maze[checkY][checkX] == '┘') {
            // Corner collision with diameter check
            float cornerX = checkX * 20;
            float cornerY = checkY * 20;

            // Adjust corner center based on corner type
            if (maze[checkY][checkX] == '┌') {
              cornerX += cellSize;
              cornerY += cellSize;
            } else if (maze[checkY][checkX] == '┐') {
              cornerY += cellSize;
            } else if (maze[checkY][checkX] == '└') {
              cornerX += cellSize;
            }

            // Detect collision with arc region using full diameter
            float distanceFromCenter = dist(pixelX, pixelY, cornerX, cornerY);

            // If inside the rounded area using full diameter
            if (distanceFromCenter < diameter) {
              // Additional angle check to match arc's specific quadrant
              float angle = atan2(pixelY - cornerY, pixelX - cornerX);

              // Adjust angle check based on corner type
              boolean angleInQuadrant = false;
              if (maze[checkY][checkX] == '┌' && angle >= PI && angle <= 3*PI/2) angleInQuadrant = true;
              else if (maze[checkY][checkX] == '┐' && angle >= 3*PI/2 && angle <= TWO_PI) angleInQuadrant = true;
              else if (maze[checkY][checkX] == '└' && angle >= HALF_PI && angle <= PI) angleInQuadrant = true;
              else if (maze[checkY][checkX] == '┘' && angle >= 0 && angle <= HALF_PI) angleInQuadrant = true;

              if (angleInQuadrant) {
                wallCollision = true;
                break;
              }
            }
          }
        }
      }
      if (wallCollision) break;
    }

    // Revert if wall collision detected
    if (wallCollision) {
      pixelX = prevPixelX;
      pixelY = prevPixelY;
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
