class RedGhost {
  float cellSize = 20.0f;
  float pixelX, pixelY;
  float moveSpeed;
  char[][] maze;
  int direction; // 0 = right, 1 = down, 2 = left, 3 = up
  boolean isVulnerable;
  GhostSprites sprite;  // Add sprite system
  
  RedGhost(int startX, int startY, float speed, char[][] maze, GhostSprites sprite) {
    this.pixelX = startX * cellSize;
    this.pixelY = startY * cellSize;
    this.moveSpeed = speed;
    this.maze = maze;
    this.direction = 0;
    this.isVulnerable = false;
    this.sprite = sprite;  // Store the sprite
  }
  
  void move(PacmanMovement pacman) {
    // Get current grid position
    int currentGridX = floor(pixelX / cellSize);
    int currentGridY = floor(pixelY / cellSize);
    
    // Only make decisions at grid intersections
    if (isAtGridCenter()) {
      // Get Pacman's grid position
      int pacmanGridX = floor(pacman.pixelX / cellSize);
      int pacmanGridY = floor(pacman.pixelY / cellSize);
      
      // Find best direction to move towards Pacman
      direction = findBestDirection(currentGridX, currentGridY, pacmanGridX, pacmanGridY);
    }
    
    // Move in current direction
    switch(direction) {
      case 0: // Right
        if (canMove(currentGridX + 1, currentGridY)) pixelX += moveSpeed;
        break;
      case 1: // Down
        if (canMove(currentGridX, currentGridY + 1)) pixelY += moveSpeed;
        break;
      case 2: // Left
        if (canMove(currentGridX - 1, currentGridY)) pixelX -= moveSpeed;
        break;
      case 3: // Up
        if (canMove(currentGridX, currentGridY - 1)) pixelY -= moveSpeed;
        break;
    }
    
    handleTunnelWrap();
  }
  
  // Convert internal direction to sprite direction char
  char getSpriteDirection() {
    switch(direction) {
      case 0: return 'R'; // Right
      case 1: return 'D'; // Down
      case 2: return 'L'; // Left
      case 3: return 'U'; // Up
      default: return 'R';
    }
  }
  
  void draw(int xOffset, int yOffset, int animationFrame) {
    float drawX = pixelX + xOffset;
    float drawY = pixelY + yOffset;
    // Use the sprite system to draw
    image(sprite.getSprite(getSpriteDirection(), animationFrame), drawX, drawY, cellSize, cellSize);
  }
  
  // [Keep all other helper methods the same as before]
  boolean isAtGridCenter() {
    float gridCenterX = floor(pixelX / cellSize) * cellSize + cellSize / 2;
    float gridCenterY = floor(pixelY / cellSize) * cellSize + cellSize / 2;
    return abs(pixelX - gridCenterX) < moveSpeed && abs(pixelY - gridCenterY) < moveSpeed;
  }
  
  int findBestDirection(int currentX, int currentY, int targetX, int targetY) {
    float[] distances = new float[4];
    distances[0] = canMove(currentX + 1, currentY) ? 
      dist(currentX + 1, currentY, targetX, targetY) : Float.MAX_VALUE;
    distances[1] = canMove(currentX, currentY + 1) ? 
      dist(currentX, currentY + 1, targetX, targetY) : Float.MAX_VALUE;
    distances[2] = canMove(currentX - 1, currentY) ? 
      dist(currentX - 1, currentY, targetX, targetY) : Float.MAX_VALUE;
    distances[3] = canMove(currentX, currentY - 1) ? 
      dist(currentX, currentY - 1, targetX, targetY) : Float.MAX_VALUE;
    
    distances[(direction + 2) % 4] = Float.MAX_VALUE;
    
    float minDist = Float.MAX_VALUE;
    int bestDir = direction;
    
    for (int i = 0; i < 4; i++) {
      if (distances[i] < minDist) {
        minDist = distances[i];
        bestDir = i;
      }
    }
    
    return bestDir;
  }
  
  boolean canMove(int nextX, int nextY) {
    if (nextX < 0 || nextY < 0 || nextY >= maze.length || nextX >= maze[0].length) {
      return false;
    }
    return maze[nextY][nextX] != '─' && maze[nextY][nextX] != '│' && 
           maze[nextY][nextX] != '┌' && maze[nextY][nextX] != '┐' && 
           maze[nextY][nextX] != '└' && maze[nextY][nextX] != '┘';
  }
  
  void handleTunnelWrap() {
    int tunnelY = 14; // Adjust based on your maze layout
    if (floor(pixelY / cellSize) == tunnelY) {
      if (pixelX < 0) {
        pixelX = (maze[0].length - 1) * cellSize;
      } else if (pixelX > (maze[0].length - 1) * cellSize) {
        pixelX = 0;
      }
    }
  }
}
