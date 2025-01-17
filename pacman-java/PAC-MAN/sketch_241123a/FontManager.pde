/* 
Author: Shayan Mazahir
Date of Last Edit: January 17, 2025
*/

/**
 * FontManager class
 * This class manages loading and applying a custom font in a Processing sketch.
 * It simplifies the process of handling fonts by providing methods to load,
 * retrieve, and apply a font.
 */
class FontManager {
  /** 
   * @private PFont customFont
   * A private variable to store the custom font loaded from a .ttf file.
   */
  private PFont customFont;

  /**
   * Constructor: FontManager
   * @param p The parent PApplet instance to access Processing methods.
   * @param fontPath The file path to the .ttf font file.
   * @param fontSize The size of the font to be used for text rendering.
   * 
   * This constructor loads a font using the specified font path and size
   * and initializes the customFont variable.
   */
  FontManager(PApplet p, String fontPath, float fontSize) {
    customFont = p.createFont(fontPath, fontSize); // Load the font
  }

  /**
   * @method getFont
   * @return PFont The loaded custom font.
   * 
   * This method returns the PFont object representing the loaded font,
   * allowing external classes to access the font.
   */
  PFont getFont() {
    return customFont;
  }

  /**
   * @method applyFont
   * @param p The parent PApplet instance to apply the font in the sketch.
   * 
   * This method sets the loaded font as the active font for text rendering
   * in the given Processing sketch.
   */
  void applyFont(PApplet p) {
    p.textFont(customFont); // Apply the font for rendering text
  }
}
