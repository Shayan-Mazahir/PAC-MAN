class GhostSprites {
  PImage[][] sprites; // [direction][frame] for animations
  String ghostColor; // The ghost's color (e.g., "blue", "red")

  // Constructor to load sprites for a specific ghost color
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
  }

  // Getter for specific animation frames
  PImage getSprite(char direction, int frame) {
    int directionIndex = directionToIndex(direction);
    return sprites[directionIndex][frame];
  }

  // Helper method to map direction character to index
  private int directionToIndex(char direction) {
    if (direction == 'U') return 0;
    if (direction == 'D') return 1;
    if (direction == 'L') return 2;
    if (direction == 'R') return 3;
    return -1; // Invalid direction
  }
}
