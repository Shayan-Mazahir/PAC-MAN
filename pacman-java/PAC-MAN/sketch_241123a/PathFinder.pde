import java.util.List;
import java.util.ArrayList;
import java.util.PriorityQueue;
import java.util.HashSet;
import java.util.Comparator;

class Pathfinder {
  char[][] maze;
  int cols, rows;

  Pathfinder(char[][] maze, int cols, int rows) {
    this.maze = maze;
    this.cols = cols;
    this.rows = rows;
  }

  List<PVector> findPath(PVector start, PVector target) {
    PriorityQueue<Node> openList = new PriorityQueue<>(new Comparator<Node>() {
      @Override
        public int compare(Node n1, Node n2) {
        return Float.compare(n1.fCost, n2.fCost);
      }
    }
    );

    HashSet<PVector> closedList = new HashSet<>();
    List<PVector> path = new ArrayList<>();

    openList.add(new Node(start, 0, dist(start.x, start.y, target.x, target.y), null));

    while (!openList.isEmpty()) {
      Node currentNode = openList.poll();

      if (currentNode.position.equals(target)) {
        // Reconstruct path
        Node pathNode = currentNode;
        while (pathNode != null) {
          path.add(0, pathNode.position); // Add to the start of the path
          pathNode = pathNode.parent;
        }
        return path;
      }

      closedList.add(currentNode.position);

      for (PVector move : getValidMoves(currentNode.position)) {
        if (closedList.contains(move)) continue;

        float gCost = currentNode.gCost + 1;
        float hCost = dist(move.x, move.y, target.x, target.y);
        Node neighborNode = new Node(move, gCost, hCost, currentNode);

        if (!openList.contains(neighborNode) || gCost < neighborNode.gCost) {
          openList.add(neighborNode);
        }
      }
    }
    return path; // Return empty if no path found
  }

  List<PVector> getValidMoves(PVector position) {
    PVector[] moves = {
      new PVector(0, -1), // Up
      new PVector(0, 1), // Down
      new PVector(-1, 0), // Left
      new PVector(1, 0)   // Right
    };

    List<PVector> validMoves = new ArrayList<>();
    for (PVector move : moves) {
      int moveX = (int) (position.x + move.x);
      int moveY = (int) (position.y + move.y);

      if (moveX >= 0 && moveX < cols && moveY >= 0 && moveY < rows && isValidTile(moveX, moveY)) {
        validMoves.add(new PVector(moveX, moveY));
      }
    }
    return validMoves;
  }

  private boolean isValidTile(int x, int y) {
    return maze[y][x] != '│' && maze[y][x] != '─' &&
      maze[y][x] != '┘' && maze[y][x] != '└' &&
      maze[y][x] != '┌' && maze[y][x] != '┐';
  }
}

class Node {
  PVector position;
  float gCost;
  float hCost;
  float fCost;
  Node parent;

  Node(PVector position, float gCost, float hCost, Node parent) {
    this.position = position;
    this.gCost = gCost;
    this.hCost = hCost;
    this.fCost = gCost + hCost;
    this.parent = parent;
  }
}
