class HighScore {
  PImage image;
  float x, y;
  boolean clicked = false; // Track if high score is clicked

  // Constructor to load the image and set position
  HighScore(PApplet app, String imagePath, float x, float y) {
    this.image = app.loadImage(imagePath);
    this.x = x;
    this.y = y;
  }

  // Method to display the image
  void display() {
    image(image, x, y);
  }

  // Check if the high score image is clicked
  void checkClick() {
    if (mouseX >= x && mouseX <= x + image.width &&
        mouseY >= y && mouseY <= y + image.height &&
        mousePressed) {
      clicked = true;
    }
  }
}
