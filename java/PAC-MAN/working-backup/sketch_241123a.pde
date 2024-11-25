import gifAnimation.Gif;

PImage startScreen;
PImage highScoreScreen;
GameStart startButton;
HighScore highScore;
HowToPlay howToPlay;
boolean gameStarted = false;
boolean showHighScore = false;
boolean showHowToPlay = false; // Track if we're showing the how-to-play screen
FontManager fontManager; // Declare the FontManager variable

void setup() {
  size(680, 720);
  background(0);
  
  // Load the start screen image
  startScreen = loadImage("../assets/start-screen.png");
  
  // Load the full-screen high score image
  highScoreScreen = loadImage("../assets/high-score.png");
  
  // Create a GameStart object (button)
  startButton = new GameStart(this, "../assets/start-button.gif", "../assets/start-button-2.png");
  
  // Create a HighScore object
  highScore = new HighScore(this, "../assets/highscore.jpg", 10, height - 165);
  
  // Initialize FontManager with the .ttf font path and desired size
  fontManager = new FontManager(this, "../assets/fonts/ARCADECLASSIC.TTF", 20);
  
  // Create a HowToPlay object (positioned at the bottom-right corner)
  float howToPlayX = width - 170; // Adjust based on image width
  float howToPlayY = height - 165; // Adjust based on image height
  howToPlay = new HowToPlay(this, "../assets/how-to-play.png", howToPlayX, howToPlayY, fontManager, "../assets/left-arrow.png");
}

void draw() {
  if (showHighScore) {
    // Show the full-screen high score image if high score was clicked
    image(highScoreScreen, 0, 0, width, height);
  } else if (showHowToPlay) {
    // Check if the "How to Play" image itself was clicked anywhere to go back to the start screen
    if (howToPlay.checkImageClick()) {
      showHowToPlay = false;  // Hide the how-to-play screen
      gameStarted = false;    // Show the start screen again
    }
    
    // Display the instructions from the HowToPlay object
    howToPlay.displayInstructions();
  } else if (!gameStarted) {
    // Main screen before the game starts
    image(startScreen, 0, 0, width, height);
    startButton.display();
    startButton.checkClick();
    highScore.display();
    highScore.checkClick();
    howToPlay.display();
    howToPlay.checkClick();

    // Check if the high score image was clicked
    if (highScore.clicked) {
      showHighScore = true; // Switch to high score screen
    }

    // Check if the How to Play image was clicked
    if (howToPlay.clicked) {
      showHowToPlay = true; // Display the how-to-play instructions
    }

    if (startButton.clicked) {
      gameStarted = true; // Switch to game mode
    }
  } else {
    // Game mode - set the screen to black
    background(0);
  }
}
