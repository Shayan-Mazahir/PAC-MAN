//class Movement {
//  Game game;
//  float x, y;
//  int speed;

//  // Constructor to initialize Pac-Man's position and speed
//  Movement(Game game, float x, float y, int speed) {
//    this.game = game;
//    this.x = x;
//    this.y = y;
//    this.speed = speed;
//  }

//  // Move Pac-Man up
//  void moveUp() {
//    if (canMoveTo(x, y - speed)) {
//      y -= speed;
//    }
//  }

//  // Move Pac-Man down
//  void moveDown() {
//    if (canMoveTo(x, y + speed)) {
//      y += speed;
//    }
//  }

//  // Move Pac-Man left
//  void moveLeft() {
//    if (canMoveTo(x - speed, y)) {
//      x -= speed;
//    }
//  }

//  // Move Pac-Man right
//  void moveRight() {
//    if (canMoveTo(x + speed, y)) {
//      x += speed;
//    }
//  }

//  // Check if Pac-Man can move to the new position (without colliding with walls)
//  boolean canMoveTo(float newX, float newY) {
//    int col = (int)(newX / game.cellSize);
//    int row = (int)(newY / game.cellSize);

//    // Make sure the new position is within bounds and not a wall ('─', '│')
//    if (row >= 0 && row < game.rows && col >= 0 && col < game.cols) {
//      char cell = game.maze[row][col];
//      return (cell != '─' && cell != '│');
//    }
//    return false;
//  }

//  // Update the position of Pac-Man (called every frame)
//  void update() {
//    // Optional: You could add additional behavior here like animation or collision detection
//  }
//}
