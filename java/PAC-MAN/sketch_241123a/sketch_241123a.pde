import gifAnimation.Gif;

PImage startScreen;
GameStart startButton;
boolean gameStarted = false;

void setup() {
  size(680, 720);
  background(0);
  
  // Load the start screen image
  startScreen = loadImage("../assets/start-screen.png");
  
  // Create a GameStart object (button will be centered automatically)
  startButton = new GameStart(this, "../assets/start-button.gif", "../assets/start-button-2.png");
}

void draw() {
  // If game hasn't started, display the start screen
  if (!gameStarted) {
    image(startScreen, 0, 0, width, height);
    startButton.display();
    startButton.checkClick();
    
    // Check if the button was clicked
    if (startButton.clicked) {
      gameStarted = true; // Switch to game mode
    }
  } else {
    // Game mode - set the screen to black
    background(0);
  }
}
