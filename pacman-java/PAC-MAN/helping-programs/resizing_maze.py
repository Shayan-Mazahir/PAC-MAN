def scale_down_maze(maze):
    """
    Scales down the maze by combining every 3x3 block into a single character.
    
    Parameters:
        maze (list of str): The ASCII maze as a list of strings.
    
    Returns:
        list of str: The scaled-down maze.
    """
    scaled_maze = []
    rows = len(maze)
    cols = len(maze[0])
    
    # Loop through the maze in 3x3 blocks
    for i in range(0, rows, 2):
        scaled_row = ""
        for j in range(0, cols, 2):
            # Take the top-left character of the 3x3 block
            scaled_row += maze[i][j]
        scaled_maze.append(scaled_row)
    
    return scaled_maze

# Read the maze from the maze.txt file
with open("maze.txt", "r") as file:
    original_maze = file.readlines()

# Strip the newline characters
original_maze = [line.strip() for line in original_maze]

# Scale down the maze
scaled_maze = scale_down_maze(original_maze)

# Print the scaled-down maze
print("\n".join(scaled_maze))

# Optionally, save the scaled maze to a new file
with open("scaled_maze.txt", "w") as file:
    file.write("\n".join(scaled_maze))
