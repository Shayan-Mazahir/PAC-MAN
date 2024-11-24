import gifAnimation.Gif;

PImage startScreen;
PImage highScoreScreen;
GameStart startButton;
HighScore highScore;
boolean gameStarted = false;
boolean showHighScore = false; // Track if we're showing the high score screen

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
}

void draw() {
  if (showHighScore) {
    // Show the full-screen high score image if high score was clicked
    image(highScoreScreen, 0, 0, width, height);
  } else if (!gameStarted) {
    // Main screen before the game starts
    image(startScreen, 0, 0, width, height);
    startButton.display();
    startButton.checkClick();
    highScore.display();
    highScore.checkClick();

    // Check if the high score image was clicked
    if (highScore.clicked) {
      showHighScore = true; // Switch to high score screen
    }

    if (startButton.clicked) {
      gameStarted = true; // Switch to game mode
    }
  } else {
    // Game mode - set the screen to black
    background(0);
  }
}
