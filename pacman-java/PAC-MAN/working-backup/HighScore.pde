class HighScore {
  PImage image;
  float x, y;
  boolean clicked = false; // Track if the high score is clicked
  PImage rightArrow; // Image for the right-arrow
  float rightArrowX, rightArrowY; // Position of the right-arrow
  boolean rightArrowClicked = false; // Track if the right-arrow is clicked

  // Constructor to load the images and set positions
  HighScore(PApplet app, String imagePath, float x, float y, String rightArrowPath) {
    this.image = app.loadImage(imagePath);
    this.x = x;
    this.y = y;

    // Load the right-arrow image
    this.rightArrow = app.loadImage(rightArrowPath);

    // Resize the right-arrow image to 200x100
    this.rightArrow.resize(200, 100);

    // Update the right-arrow position based on the new size
    this.rightArrowX = app.width - rightArrow.width - 10; // Positioned 10px from the right
    this.rightArrowY = app.height - rightArrow.height - 10; // Positioned 10px from the bottom
  }

  // Method to display the high score image
  void display() {
    image(image, x, y);
  }

  // Method to display the right-arrow image
  void displayRightArrow() {
    image(rightArrow, rightArrowX, rightArrowY);
  }

  // Check if the high score image is clicked
  void checkClick() {
    if (mouseX >= x && mouseX <= x + image.width &&
      mouseY >= y && mouseY <= y + image.height &&
      mousePressed) {
      clicked = true;
    }
  }

  // Check if the right-arrow image is clicked
  void checkRightArrowClick() {
    if (mouseX >= rightArrowX && mouseX <= rightArrowX + rightArrow.width &&
      mouseY >= rightArrowY && mouseY <= rightArrowY + rightArrow.height &&
      mousePressed) {
      rightArrowClicked = true;
    }
  }
}
