'''
Description: Culminating Task
Author: Syed Shayan Mazahir
Last Date of Edit: Thursday, June 14 2024
'''
'''
Sir, you told me that you wont defuct any marks for the issue of double clicking on the START and HIGH SCORE screen
'''
#importing required modules
from browser import document, window, alert
import random
import math, time

# Dictionaries to store high score and time information
game_info = {
    'high_score': 0,
    'time_played': 0
}

# List to store game details
game_details = []

# Dictionary to store high scores
high_scores_saves = {}

def sketch(p):
    # Pac-Man properties
    p.pac_size = 30
    p.pac_speed = 2
    p.score = 0
    p.level = 1
    p.lives = 3
    p.game_started = False  # Track if the game has started
    p.showing_high_scores = False  # Track if high scores are being displayed

    # Ghost properties
    p.ghost_size = 30
    p.ghost_speed = 2
    p.ghosts = []


    p.maze_lines = [
        [(0, 0), (800, 0)], [(800, 0), (800, 400)], [(800, 400), (0, 400)], [(0, 400), (0, 0)],  # Outer boundary

        # First rectangle with opening
        [(40, 0), (40, 160)], [(40, 160), (80, 160)], [(160, 160), (160, 0)], [(40, 0), (160, 0)],

        # Second rectangle with opening
        [(240, 0), (240, 160)], [(240, 160), (280, 160)], [(360, 160), (360, 0)], [(240, 0), (360, 0)],

        # Third rectangle with opening
        [(440, 0), (440, 160)], [(440, 160), (480, 160)], [(560, 160), (560, 0)], [(440, 0), (560, 0)],

        # Fourth rectangle with opening
        [(640, 0), (640, 160)], [(640, 160), (680, 160)], [(760, 160), (760, 0)], [(640, 0), (760, 0)],

        # Fifth rectangle with opening
        [(40, 240), (40, 400)], [(40, 240), (80, 240)], [(160, 240), (160, 400)], [(40, 400), (160, 400)],

        # Sixth rectangle with opening
        [(240, 240), (240, 400)], [(240, 240), (280, 240)], [(360, 240), (360, 400)], [(240, 400), (360, 400)],

        # Seventh rectangle with opening
        [(440, 240), (440, 400)], [(440, 240), (480, 240)], [(560, 240), (560, 400)], [(440, 400), (560, 400)],

        # Eighth rectangle with opening
        [(640, 240), (640, 400)], [(640, 240), (680, 240)], [(760, 240), (760, 400)], [(640, 400), (760, 400)],

        # Ninth rectangle with opening
        [(40, 320), (40, 400)], [(40, 320), (80, 320)], [(160, 320), (160, 400)], [(40, 400), (160, 400)],

        # Tenth rectangle with opening
        [(240, 320), (240, 400)], [(240, 320), (280, 320)], [(360, 320), (360, 400)], [(240, 400), (360, 400)],

        # Eleventh rectangle with opening
        [(440, 320), (440, 400)], [(440, 320), (480, 320)], [(560, 320), (560, 400)], [(440, 400), (560, 400)],

        # Twelfth rectangle with opening
        [(640, 320), (640, 400)], [(640, 320), (680, 320)], [(760, 320), (760, 400)], [(640, 400), (760, 400)],
    ]

    p.dots = []
    p.pac_x, p.pac_y = 60, 60  # Initialize Pac-Man's position
    p.cell_size = 40  # Size of each cell in the grid

    '''
    preload(image) -> pre-loads an image
    '''
    def preload():
        p.img = p.loadImage("image.png")


    def setup():
        
        p.createCanvas(p.windowWidth - 25, p.windowHeight - 25)
        p.background(0)
        draw_start_screen()  # Draw the start screen initially

        # Clear the dots list for each new level
        p.dots = []

        # Generate dots (food)
        dot_count = 0
        max_dots = 100  # The number of dots (food)

        while dot_count < max_dots:
            x = random.randint(1, 19) * p.cell_size
            y = random.randint(1, 9) * p.cell_size

            # Check if the dot's (food) position intersects with any maze lines
            intersects = False
            for line in p.maze_lines:
                if line_intersect(x, y, 10, line):
                    intersects = True
                    break

            if intersects:
                continue  # Skip this iteration if the dot intersects with a maze line

            # If the dot (food) position is valid, add it to the list
            p.dots.append((x, y))
            dot_count += 1


        # Create ghosts
        ghost_positions = [(3, 3), (9, 5), (3, 9), (10, 9), (12, 9)]  # Ghosts starting positions
        p.ghosts = []  # Clear ghosts list for each new level
        for pos in ghost_positions:
            p.ghosts.append({
                'x': pos[0] * p.cell_size,
                'y': pos[1] * p.cell_size,
                'dir': random.choice(['UP', 'DOWN', 'LEFT', 'RIGHT']) # Choosing a random direction from an array of directions
            })


    '''
    shape_intersect(int, int, int, array) -> int
    '''
    def shape_intersect(circle_x, circle_y, circle_radius, line):
        x1, y1 = line[0]
        x2, y2 = line[1]
        # Find the closest point on the line segment to the center of the circle
        closest_x = max(min(circle_x, x2), x1)
        closest_y = max(min(circle_y, y2), y1)
        # Calculate the distance between the closest point and the center of the circle
        dist_x = circle_x - closest_x
        dist_y = circle_y - closest_y
        distance = math.sqrt((dist_x ** 2) + (dist_y ** 2))
        # Check if the distance is less than or equal to the radius of the circle
        return distance <= circle_radius



    '''
    end_game() -> None
    '''
    def end_game():
        global high_scores_saves
        score = p.score  # Store the current score before resetting it
        current_time = time.time()
        high_scores_saves[current_time] = score  # Update high_scores_saves with the stored score
        # Reset other game variables
        p.level = 1
        p.lives = 3
        p.game_started = False
        p.showing_high_scores = False
        p.score = 0  # Reset the score after saving it
        show_high_scores(high_scores_saves)  # Call show_high_scores after resetting the score
        draw_start_screen()

    def draw():
        if p.game_started:
            p.background(0)
            # Draw Pac-Man
            p.stroke(225, 225, 0)
            p.fill(255, 255, 0)
            p.arc(p.pac_x, p.pac_y, p.pac_size, p.pac_size, 0, p.PI + p.PI/1.2)
            # Checking for collisions with walls
            # Draw maze lines
            p.stroke(100)
            for line in p.maze_lines:
                p.line(line[0][0], line[0][1], line[1][0], line[1][1])
            # Draw and check for dots (food)
            p.stroke(225, 225, 0)
            p.fill(255, 255, 0)
            for dot in p.dots:
                p.ellipse(dot[0], dot[1], 10, 10)
                # Check if Pac-Man eats a dot
                if p.dist(p.pac_x, p.pac_y, dot[0], dot[1]) < p.pac_size / 2:
                    p.dots.remove(dot)
                    p.score += 1
                    

            # Draw ghosts
            p.stroke(225, 0, 0)
            p.fill(255, 0, 0)
            for ghost in p.ghosts:
                p.ellipse(ghost['x'], ghost['y'], p.ghost_size, p.ghost_size)
                move_ghost(ghost)
            # Check for collisions with ghosts
            for ghost in p.ghosts:
                if p.dist(p.pac_x, p.pac_y, ghost['x'], ghost['y']) < p.pac_size / 2:
                    p.lives -= 1
                    
                    reset_pacman()
                    break
            # Display score, level, and lives near the maze
            p.stroke(255)
            p.fill(255)
            p.textSize(32)
            p.text(f"Score: {p.score}", 900, 30)
            p.text(f"Level: {p.level}", 900, 60)
            p.text(f"Lives: {p.lives}", 900, 90)

            # Check if all dots are eaten
            if len(p.dots) == 0:
                p.level += 1
                dot_count = 0
                max_dots = 100  # The maximum number of dots (food)

                while dot_count < max_dots:
                    x = random.randint(1, 19) * p.cell_size
                    y = random.randint(1, 9) * p.cell_size

                    # Check if the dot's position intersects with any maze lines
                    intersects = False
                    for line in p.maze_lines:
                        if line_intersect(x, y, 10, line):  # Assuming dot size is 10
                            intersects = True
                            break

                    if intersects:
                        continue  # Skip this iteration if the dot intersects with a maze line
                   
                    # If the dot position is valid, add it to the list
                    p.dots.append((x, y))
                    dot_count += 1

                # Increase Pac-Man's speed for higher levels
                p.pac_speed += 1
                # Increase ghosts' speed for higher levels
                p.ghost_speed *= 1.01


            # Check if game over
            if p.lives == 0:
                p.level = 1
                p.pac_speed = 2
                p.ghost_speed = 2
                p.lives = 3
                # Save high score before resetting
                end_game()  # Call end_game here to save high score
                dot_count = 0
                max_dots = 100  # Change this to the desired number of dots

                while dot_count < max_dots:
                    x = random.randint(1, 19) * p.cell_size
                    y = random.randint(1, 9) * p.cell_size

                    # Check if the dot's position intersects with any maze lines
                    intersects = False
                    for line in p.maze_lines:
                        if line_intersect(x, y, 10, line):  # Assuming dot size is 10
                            intersects = True
                            break

                    if intersects:
                        continue  # Skip this iteration if the dot intersects with a maze line

                    # If the dot position is valid, add it to the list
                    p.dots.append((x, y))
                    dot_count += 1
            elif not p.game_started:
                draw_start_screen()

            # Move Pac-Man
            new_x, new_y = p.pac_x, p.pac_y
            if p.keyIsDown(p.UP_ARROW):
                new_y -= p.pac_speed
            if p.keyIsDown(p.LEFT_ARROW):
                new_x -= p.pac_speed
            if p.keyIsDown(p.DOWN_ARROW):
                new_y += p.pac_speed
            if p.keyIsDown(p.RIGHT_ARROW):
                new_x += p.pac_speed
              # Checking to ensure pacman doesnt corss the maze bonds or maze lines
            if check_within_maze_bounds(new_x, new_y) and not check_collision(new_x, new_y, p.ghost_size):
                p.pac_x, p.pac_y = new_x, new_y


    '''
    check_collision(float, float, float) -> boolean
    '''
    def check_collision(new_x, new_y, size):
        return_value = False  #  Assume False
        for line in p.maze_lines:
            if line_intersect(new_x, new_y, size, line):
                return_value = True
        return return_value
    '''
    line_intersect(float, float, float, array) -> boolean
    '''
    def line_intersect(x, y, size, line):
        x1, y1 = line[0]
        x2, y2 = line[1]

        # Manually check boundaries for each line segment
        if (x >= min(x1, x2) - size/2 and x <= max(x1, x2) + size/2 and
            y >= min(y1, y2) - size/2 and y <= max(y1, y2) + size/2):
            return True
        else:
            return False



    '''
    create_ghosts(int) -> None
    '''
    def create_ghosts(num_ghosts):
        for _ in range(num_ghosts):
            x = random.randint(0, p.windowWidth)
            y = random.randint(0, p.windowHeight)
            p.ghosts.append({'x': x, 'y': y, 'dir': 'UP'})
            

    '''
    move_ghost(array) -> None
    '''
    def move_ghost(ghost):
        directions = ['UP', 'DOWN', 'LEFT', 'RIGHT']
        new_x, new_y = ghost['x'], ghost['y']

        # Attempt to move the ghost in its current direction
        if ghost['dir'] == 'UP':
            new_y -= p.ghost_speed
        elif ghost['dir'] == 'DOWN':
            new_y += p.ghost_speed
        elif ghost['dir'] == 'LEFT':
            new_x -= p.ghost_speed
        elif ghost['dir'] == 'RIGHT':
            new_x += p.ghost_speed

        # Check if the new position intersects with maze boundaries
        if not check_collision(new_x, new_y, p.ghost_size) and check_within_maze_bounds(new_x, new_y):
            ghost['x'], ghost['y'] = new_x, new_y
        else:
            # If collision or out of bounds, pick a new random direction
            ghost['dir'] = random.choice(directions)

    '''
    check_within_maze_bounds(float, float) -> boolean
    '''
    def check_within_maze_bounds(x, y):
        # Check if the coordinates (x, y) are within the maze boundaries
        if x < 0 or x >= 800 or y < 0 or y >= 400:
            return False
        else:
            return True



    '''
    reset_pacman() -> None
    '''
    def reset_pacman():
        p.pac_x = 60
        p.pac_y = 60  # Reset Pac-Man's position to the initial point
    '''
    draw_start_screen() -> None
    '''
    def draw_start_screen():
        p.background(0)
        p.fill(255)
        p.textAlign(p.CENTER)
        p.textSize(32)
        p.text("START", p.width / 2, p.height / 2)
        p.game_started = False

        # Get the bounding box of the "START" text
        p.start_text_width = p.textWidth("START")
        p.start_text_height = 32  # Assuming the text size is 32

        # Generate random colors for circles
        random_colors = [(random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)) for _ in range(100)]

        # Draw circles in the background
        for color in random_colors:
            p.fill(color[0], color[1], color[2])
            x = random.randint(10, p.width - 10)
            y = random.randint(10, p.height - 10)
            p.circle(x, y, 10)
            

        # Draw the circle button
        circle_x = p.width - 50  # Adjust the x-coordinate as needed
        circle_y = p.height - 50  # Adjust the y-coordinate as needed
        circle_radius = 40  # Adjust the radius as needed
        p.fill(0)  # Fill color of the circle
        p.stroke(0)  # Border color of the circle
        p.ellipse(circle_x, circle_y, circle_radius * 2, circle_radius * 2)

        # Load the image
        img_path = "image.png"  
   
        # Check if the image is loaded successfully
        if p.img:
            # Draw the image inside the circle
            img_width = 70  # Adjust the width of the image as needed
            img_height = 70  # Adjust the height of the image as needed
            p.image(p.img, circle_x - img_width / 2, circle_y - img_height / 2, img_width, img_height)
        else:
            print("Failed to load the image. Please check the image path:", img_path)


    '''
    start_game() -> None
    '''
    def start_game():
        
        p.game_started = True
        p.showing_high_scores = False  # Ensure high scores screen is not being displayed
        p.draw()  # Redraw the canvas to start the game

    '''
    sort_by_timestamp(array) -> array
    '''
    def sort_by_timestamp(item):
        return item[0]
        #sorts time and score
    '''
    show_high_scores(dict) -> None
    '''
    def show_high_scores(high_scores_saves):
        p.background(0)
        p.fill(255)
        p.textAlign(p.CENTER)
        p.textSize(32)
        p.text("High Scores", p.width / 2, p.height / 2 - 40)

        # Generate random colors for circles
        random_colors = [(random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)) for _ in range(100)]

        # Draw circles in the background
        for color in random_colors:
            p.fill(color[0], color[1], color[2])
            x = random.randint(10, p.width - 10)
            y = random.randint(10, p.height - 10)
            p.circle(x, y, 10)

        if high_scores_saves:
            p.textSize(24)
            y_offset = p.height / 2

            # Sort the dictionary by timestamp in ascending order
            sorted_scores = sorted(high_scores_saves.items(), key=sort_by_timestamp)

            # Get the top 5 scores
            top_scores = sorted_scores[:5]

            for timestamp, score in top_scores:
                timestamp_str = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(timestamp))
                p.text(f"Score: {score}, Time: {timestamp_str}", p.width / 2, y_offset)
                y_offset += 30
        else:
            p.textSize(24)
            y_offset = p.height / 2
            p.text("No high scores, play first!", p.width / 2, y_offset)

        p.textSize(18)
        p.text("Click anywhere to return to start screen", p.width / 2, y_offset + 20)
        p.showing_high_scores = True  # Set flag to indicate high scores are being displayed




    def mousePressed(self):
        
        if not p.game_started and not p.showing_high_scores:
            # Define the rectangular region around the "START" text
            start_region_x = p.width / 2 - p.start_text_width / 2
            start_region_y = p.height / 2 - p.start_text_height / 2
            start_region_width = p.start_text_width
            start_region_height = p.start_text_height

            # Check if the mouse click is within the rectangular region
            if (start_region_x <= p.mouseX <= start_region_x + start_region_width and
                    start_region_y <= p.mouseY <= start_region_y + start_region_height):
               
                start_game()

            # Define the region for the circle
            circle_x = p.width - 50
            circle_y = p.height - 50
            circle_radius = 40

            # Check if the mouse click is within the circle
            if (p.dist(p.mouseX, p.mouseY, circle_x, circle_y) <= circle_radius):
                show_high_scores(high_scores_saves)

        elif p.showing_high_scores:
            # Return to the start screen when high scores screen is clicked
            p.showing_high_scores = False
            draw_start_screen()

    p.setup = setup
    p.draw = draw
    p.draw_start_screen = draw_start_screen
    p.start_game = start_game
    p.show_high_scores = show_high_scores
    p.mousePressed = mousePressed
    p.preload = preload

myp5 = window.p5.new(sketch)


