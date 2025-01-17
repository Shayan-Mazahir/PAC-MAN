/* 
Author: Shayan Mazahir
Date of Last Edit: January 17, 2025
*/
// PacmanMovement class extending Movement class
class PacmanMovement extends Movement {
  float cellSize = 20.0f; // Size of the grid cell in pixels
  float pixelX, pixelY; // Pacman's current pixel position
  float targetX, targetY; // Target pixel positions
  float moveSpeed; // Speed of movement
  boolean moving; // Whether Pac-Man is moving towards a target
  PImage[][] directionImages; // Images for all direction animations
  int animationFrame = 0; // Current animation frame
  int animationSpeed = 10; // Frames per animation update
  int frameCounter = 0; // Counter to manage animation timing

  int moveDelay = 5; // Number of frames to delay movement

  int score = 0; // Local score
  int gameScore; // Reference to the game's score


  //Function to control the movement of pacman + converts movement from grid based to pixel based 
  PacmanMovement(int startX, int startY, float speed, int score) {
    super(startX, startY);
    this.pixelX = startX * cellSize; // Convert grid to pixels (Pac-Man's center)
    this.pixelY = startY * cellSize; // Convert grid to pixels
    this.targetX = pixelX;
    this.targetY = pixelY;
    this.moveSpeed = speed;
    this.moving = false;
    this.gameScore = gameScore;

    // Load images for all directions
    directionImages = new PImage[4][2]; // [direction][frame]
    directionImages[0][0] = loadImage("../assets/pacman-final/up-1.png");
    directionImages[0][1] = loadImage("../assets/pacman-final/up-2.png");
    directionImages[1][0] = loadImage("../assets/pacman-final/down-1.png");
    directionImages[1][1] = loadImage("../assets/pacman-final/down-2.png");
    directionImages[2][0] = loadImage("../assets/pacman-final/left-1.png");
    directionImages[2][1] = loadImage("../assets/pacman-final/left-2.png");
    directionImages[3][0] = loadImage("../assets/pacman-final/right-1.png");
    directionImages[3][1] = loadImage("../assets/pacman-final/right-2.png");
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

  // Update position based on movement direction and check for food
  void move(char[][] maze) {
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

        // Check for food at the new position
        if (maze[gridY][gridX] == '·') {
          maze[gridY][gridX] = ' '; // Remove the food from the maze
          score += 10; // Increment the score
          gameScore = score;
          // Sounds here
        }
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

  // Draw Pac-Man at the current pixel position with animation
  // Time-based frame switch logic
  int lastFrameTime = 0; // Time of the last frame change (in milliseconds)
  int frameDuration = 100; // Time (in milliseconds) between each frame change (controls speed)

  void draw(int cellSize, int xOffset, int yOffset) {
    float drawX = pixelX + xOffset;
    float drawY = pixelY + yOffset;

    // Determine direction index for animation
    int directionIndex = -1;
    if (direction == 'U') directionIndex = 0;
    else if (direction == 'D') directionIndex = 1;
    else if (direction == 'L') directionIndex = 2;
    else if (direction == 'R') directionIndex = 3;

    if (directionIndex >= 0) {
      int currentTime = millis(); // Get the current time in milliseconds

      // Check if enough time has passed to switch the frame
      if (currentTime - lastFrameTime >= frameDuration) {
        animationFrame = (animationFrame + 1) % directionImages[directionIndex].length;
        lastFrameTime = currentTime; // Update the time of the last frame change
      }

      float delayPicture = 10.0;
      // Now check if the image exists and only draw if it is valid
      if (currentTime >= delayPicture) {
        image(directionImages[directionIndex][animationFrame], drawX, drawY, cellSize, cellSize);
      }
    } else {
      // Draw static Pac-Man if direction is undefined
      fill(255, 255, 0); // Yellow
      noStroke();
      ellipse(drawX + cellSize / 2, drawY + cellSize / 2, cellSize, cellSize);
    }
  }
}
