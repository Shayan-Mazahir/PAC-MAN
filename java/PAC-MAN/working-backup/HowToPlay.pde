class HowToPlay {
  PApplet p;
  PImage image;
  float x, y;
  boolean clicked = false;
  boolean isHovered = false;
  String[] instructions; // Array to hold instructions from the text file
  PFont customFont; // Declare a PFont variable to store the custom font

  // Constructor to initialize the how-to-play button
  HowToPlay(PApplet p, String imagePath, float x, float y, String fontPath) {
    this.p = p;
    this.image = p.loadImage(imagePath);
    this.x = x;
    this.y = y;

    // Load the instructions from the text file
    instructions = p.loadStrings("how-to-play.txt"); // Load instructions from the file
    
    // Load the custom font from the TTF file
    customFont = p.createFont(fontPath, 20); // Load the font with a default size of 20
  }

  // Display the button
  void display() {
    // Check if mouse is hovering over the button
    isHovered = p.mouseX >= x && p.mouseX <= x + image.width &&
                p.mouseY >= y && p.mouseY <= y + image.height;

    // Display the button image
    p.image(image, x, y);
  }

  // Check if the button is clicked
  void checkClick() {
    if (isHovered && p.mousePressed) {
      clicked = true;
    }
  }

  // Display the instructions on the screen with the custom font
  void displayInstructions() {
    p.background(0);
    p.textFont(customFont); // Apply the custom font
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
    // Starting Y position for the text
    float yOffset = 60;
    
    while (index < instructions.length) {
      p.textSize(20);
      p.text(instructions[index], 50, yOffset + 40);
      yOffset += 35; // Add some space between lines for clarity
      index++;
    }
  }
}
