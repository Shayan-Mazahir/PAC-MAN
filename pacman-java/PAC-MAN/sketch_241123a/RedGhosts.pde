//ghost movements
import java.util.LinkedList;
import java.util.Queue;

class RedGhost extends Movement {
  PVector target; // The target position the ghost is chasing

  RedGhost(int startX, int startY) {
    super(startX, startY);
    target = new PVector(-1, -1); // Default target (out of bounds)
  }

  // Set Pac-Man's position as the target
  void setTarget(int targetX, int targetY) {
    target.set(targetX, targetY);
  }

  // Breadth-First Search for shortest path
  void move(char[][] maze) {
    // Directions for movement: {dx, dy, directionChar}
    int[][] directions = {
      {0, -1, 'U'}, // Up
      {0, 1, 'D'},  // Down
      {-1, 0, 'L'}, // Left
      {1, 0, 'R'}   // Right
    };

    // BFS Queue to explore positions
    Queue<int[]> queue = new LinkedList<>();
    boolean[][] visited = new boolean[maze.length][maze[0].length];
    queue.add(new int[]{x, y, -1, x, y}); // {currentX, currentY, directionIndex, startX, startY}
    visited[y][x] = true;

    while (!queue.isEmpty()) {
      int[] current = queue.poll();
      int curX = current[0], curY = current[1];
      int firstDirection = current[2]; // Store the initial move direction

      // If we reached the target, move in the initial direction
      if (curX == target.x && curY == target.y) {
        if (firstDirection != -1) {
          direction = (char) directions[firstDirection][2];
          x += directions[firstDirection][0];
          y += directions[firstDirection][1];
        }
        return;
      }

      // Explore neighboring cells
      for (int i = 0; i < directions.length; i++) {
        int nextX = curX + directions[i][0];
        int nextY = curY + directions[i][1];

        if (canMove(nextX, nextY, maze) && !visited[nextY][nextX]) {
          visited[nextY][nextX] = true;
          queue.add(new int[]{nextX, nextY, firstDirection == -1 ? i : firstDirection, curX, curY});
        }
      }
    }

    // If no valid moves (should rarely happen), stay in place
  }
}
