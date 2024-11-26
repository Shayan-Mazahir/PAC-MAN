class HowToPlay {
  PApplet p;
  PImage image;
  PImage leftArrow; // Declare the left arrow image
  float x, y;
  boolean clicked = false;
  boolean isHovered = false;
  String[] instructions; // Array to hold instructions from the text file
  FontManager fontManager; // Add FontManager instance to the class

  // Constructor to initialize the how-to-play button
  HowToPlay(PApplet p, String imagePath, float x, float y, FontManager fontManager, String leftArrowPath) {
    this.p = p;
    this.image = p.loadImage(imagePath);
    this.x = x;
    this.y = y;

    // Load the instructions from the text file
    instructions = p.loadStrings("how-to-play.txt"); // Load instructions from the file

    // Use the FontManager instance passed from setup
    this.fontManager = fontManager;

    // Load the left arrow image
    leftArrow = p.loadImage(leftArrowPath);
  }

  // Display the button
  void display() {
    // Check if mouse is hovering over the full image (the entire HowToPlay image)
    isHovered = p.mouseX >= x && p.mouseX <= x + image.width &&
                p.mouseY >= y && p.mouseY <= y + image.height;

    // Display the HowToPlay image
    p.image(image, x, y);
  }

  // Check if the button is clicked (covering the entire image)
  void checkClick() {
    if (isHovered && p.mousePressed) {
      clicked = true;
    }
  }

  // Check if the left arrow was clicked (on the left arrow image specifically)
  boolean checkLeftArrowClick() {
    float arrowX = 15; // Set a little padding from the left side
    float arrowY = p.height - leftArrow.height - 75; // Set padding from the bottom
    float arrowWidth = 200;  // Width for the arrow image
    float arrowHeight = 100; // Height for the arrow image
    
    boolean isArrowHovered = p.mouseX >= arrowX && p.mouseX <= arrowX + arrowWidth &&
                              p.mouseY >= arrowY && p.mouseY <= arrowY + arrowHeight;
    
    // Check if the left arrow is clicked
    return isArrowHovered && p.mousePressed;
  }

  // Display the instructions on the screen with styling
  void displayInstructions() {
    p.background(0);
    // Apply the font using the FontManager
    fontManager.applyFont(p); // Apply the loaded font

    // Set the text color
    p.fill(255, 204, 0); // Yellow text color
  
    // Display the first line of the text file separately
    String first_line = instructions[0];
    p.textAlign(p.CENTER, p.TOP); // Set text alignment to center horizontally and top vertically
    p.textSize(25);
    p.text(first_line, p.width / 2, 55); // Centered horizontally, position vertically
    
    // Ensuring that the center and top does not continue with the rest of the text
    p.textAlign(p.LEFT, p.TOP);
    // Display each line of instructions with some margin between lines
    int index = 1;
    float yOffset = 60; // Starting Y position for the text
    
    while (index < instructions.length) {
      p.textSize(20);
      p.text(instructions[index], 50, yOffset + 40);
      yOffset += 35; // Add some space between lines for clarity
      index++;
    }

    // Display the left arrow at the bottom left corner
    float arrowX = 15; // Set a little padding from the left side
    float arrowY = p.height - leftArrow.height - 75; // Set padding from the bottom

    // Set the desired size for the arrow image
    float arrowWidth = 200;  // New width for the arrow image
    float arrowHeight = 100; // New height for the arrow image

    // Draw the left arrow with the new size
    p.image(leftArrow, arrowX, arrowY, arrowWidth, arrowHeight); // Resize the image
  }
}
