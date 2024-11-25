class FontManager {
  private PFont customFont; // Declare the font variable
  
  // Constructor to load the custom font
  FontManager(PApplet p, String fontPath, float fontSize) {
    // Use createFont() to load the .ttf font with the specified size
    customFont = p.createFont(fontPath, fontSize);
  }

  // Method to get the font
  PFont getFont() {
    return customFont;
  }

  // Method to apply the font
  void applyFont(PApplet p) {
    p.textFont(customFont); // Apply the font to the text rendering
  }
}
