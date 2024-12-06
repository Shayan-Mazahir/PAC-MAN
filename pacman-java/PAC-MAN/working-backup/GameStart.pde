import gifAnimation.Gif;

class GameStart {
  float x, y;
  Gif gifImage;
  PImage hoverImage;
  boolean isHovered = false;
  boolean clicked = false;

  // Constructor to initialize the button
  //why do we need the PApplet? whats the use?
  //https://processing.github.io/processing-javadocs/core/processing/core/PApplet.html
  GameStart(PApplet parent, String gifPath, String hoverImagePath) {
    // Load the GIF and hover image
    gifImage = new Gif(parent, gifPath);  // Pass parent to the Gif constructor
    gifImage.loop();
    hoverImage = loadImage(hoverImagePath);

    // Dynamically center the button based on the GIF's dimensions
    x = (parent.width - gifImage.width) / 2;  // Center on the x-axis
    y = (parent.height - gifImage.height) / 2 + 60; // Adjust y as needed
  }

  // Display the button
  void display() {
    // Check if mouse is hovering over the button
    isHovered = mouseX >= x && mouseX <= x + gifImage.width &&
      mouseY >= y && mouseY <= y + gifImage.height;

    // Display hover image or GIF
    if (isHovered) {
      image(hoverImage, x, y);
    } else {
      image(gifImage, x, y);
    }
  }

  // Check if button is clicked
  void checkClick() {
    if (isHovered && mousePressed) {
      clicked = true;
    }
  }
}
