/* 
Author: Shayan Mazahir
Date of Last Edit: January 17, 2025
*/
class Movement {
  int x, y; // Current grid position
  char direction; // Current direction ('U', 'D', 'L', 'R')

  //Movement function
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
