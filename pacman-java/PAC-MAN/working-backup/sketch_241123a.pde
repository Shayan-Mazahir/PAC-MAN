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

int lastStateChangeTime = 0; // Track the last state change time
int timeoutDuration = 2000;  // Timeout duration in milliseconds (2 seconds)

void setup() {
  size(680, 720);
  background(0);
  
  // Load the start screen image
  startScreen = loadImage("../assets/start-screen.png");
  
  // Load the full-screen high score image
  highScoreScreen = loadImage("../assets/high-score.png");
  
  // Create a GameStart object (button)
  startButton = new GameStart(this, "../assets/start-button.gif", "../assets/start-button-2.png");
  
  // Create a HighScore object with the right-arrow image
  highScore = new HighScore(this, "../assets/highscore.jpg", 10, height - 165, "../assets/right-arrow.png");

  // Initialize FontManager with the .ttf font path and desired size
  fontManager = new FontManager(this, "../assets/fonts/ARCADECLASSIC.TTF", 20);
  
  // Create a HowToPlay object (positioned at the bottom-right corner)
  float howToPlayX = width - 170; // Adjust based on image width
  float howToPlayY = height - 165; // Adjust based on image height
  howToPlay = new HowToPlay(this, "../assets/how-to-play.png", howToPlayX, howToPlayY, fontManager, "../assets/left-arrow.png");
}

void draw() {
  int currentTime = millis(); // Get the current time

  if (showHighScore) {
    // Show the full-screen high score image if high score was clicked
    image(highScoreScreen, 0, 0, width, height);
    
    // Display the right-arrow and handle its click
    highScore.displayRightArrow();
    highScore.checkRightArrowClick();
    if (highScore.rightArrowClicked) {
      //println("Right-arrow clicked! Exiting high score screen."); // Debug message
      showHighScore = false;  // Return to the start screen
      lastStateChangeTime = currentTime; // Reset the timeout
      highScore.rightArrowClicked = false; // Reset the right-arrow state
    }
    
    // Exit the high score screen on any other click (with timeout)
    if (mousePressed && currentTime - lastStateChangeTime > timeoutDuration) {
      showHighScore = false;  // Return to the start screen
      lastStateChangeTime = currentTime; // Reset the timeout
    }
    
  } else if (showHowToPlay) {
    // Display the instructions from the HowToPlay object
    howToPlay.displayInstructions();
    
    // Check for clicks on the "back" arrow to exit the instructions
    if (currentTime - lastStateChangeTime > timeoutDuration && howToPlay.checkLeftArrowClick()) {
      showHowToPlay = false;  // Hide the how-to-play screen
      lastStateChangeTime = currentTime; // Reset the timeout
    }
    
  } else if (!gameStarted) {
    // Main screen before the game starts
    image(startScreen, 0, 0, width, height);
    
    startButton.display();
    highScore.display();
    howToPlay.display();

    // Handle button clicks only after the timeout
    if (currentTime - lastStateChangeTime > timeoutDuration) {
      startButton.checkClick();
      highScore.checkClick();
      howToPlay.checkClick();
      
      // Check if the high score image was clicked
      if (highScore.clicked) {
        showHighScore = true; // Switch to high score screen
        lastStateChangeTime = currentTime; // Reset the timeout
        highScore.clicked = false; // Reset the clicked state
      }

      // Check if the How to Play image was clicked
      if (howToPlay.clicked) {
        showHowToPlay = true; // Display the how-to-play instructions
        lastStateChangeTime = currentTime; // Reset the timeout
        howToPlay.clicked = false; // Reset the clicked state
      }

      if (startButton.clicked) {
        gameStarted = true; // Switch to game mode
        lastStateChangeTime = currentTime; // Reset the timeout
        startButton.clicked = false; // Reset the clicked state
      }
    }
    
  } else {
    // Game mode - set the screen to black
    background(0);
  }
}
