class GhostSprites {
  PImage[][] sprites; // [direction][frame] for animations
  String ghostColor; // The ghost's color (e.g., "blue", "red")
  PVector position; // Position of the ghost on the maze grid
  char direction; // Current direction ('U', 'D', 'L', 'R')
  int currentFrame; // Current animation frame (0 or 1)
  int animationSpeed; // Frames to wait before switching animation frames
  int frameCounter; // Counter for animation timing

  //Function to load the sprite images (or just images in general)
  GhostSprites(String ghostColor) {
    this.ghostColor = ghostColor;
    sprites = new PImage[4][2]; // 4 directions, 2 frames each

    // Load images for all directions and frames
    sprites[0][0] = loadImage("../assets/ghost-final/" + ghostColor + "-up-1.png");
    sprites[0][1] = loadImage("../assets/ghost-final/" + ghostColor + "-up-2.png");
    sprites[1][0] = loadImage("../assets/ghost-final/" + ghostColor + "-down-1.png");
    sprites[1][1] = loadImage("../assets/ghost-final/" + ghostColor + "-down-2.png");
    sprites[2][0] = loadImage("../assets/ghost-final/" + ghostColor + "-left-1.png");
    sprites[2][1] = loadImage("../assets/ghost-final/" + ghostColor + "-left-2.png");
    sprites[3][0] = loadImage("../assets/ghost-final/" + ghostColor + "-right-1.png");
    sprites[3][1] = loadImage("../assets/ghost-final/" + ghostColor + "-right-2.png");

    // Initialize position, direction, and animation settings
    position = new PVector(0, 0); // Start at (0, 0); update later
    direction = 'U'; // Default direction
    currentFrame = 0;
    animationSpeed = 10; // Adjust speed as needed
    frameCounter = 0;
  }

  // Update the ghost's animation and position
  void update(char[][] maze) {
    // Update animation frame
    frameCounter++;
    if (frameCounter >= animationSpeed) {
      currentFrame = (currentFrame + 1) % 2; // Toggle between 0 and 1
      frameCounter = 0;
    }
  }

  // Draw the ghost at its current position
  void draw(int cellSize, int xOffset, int yOffset) {
    PImage sprite = getSprite(direction, currentFrame);
    image(sprite, xOffset + position.x * cellSize, yOffset + position.y * cellSize, cellSize, cellSize);
  }

  // Getter for specific animation frames
  PImage getSprite(char direction, int frame) {
    int directionIndex = directionToIndex(direction);
    return sprites[directionIndex][frame];
  }

  // Helper method to map direction character to index
  public int directionToIndex(char direction) {
    if (direction == 'U') return 0;
    if (direction == 'D') return 1;
    if (direction == 'L') return 2;
    if (direction == 'R') return 3;
    return -1; // Invalid direction
  }
}
