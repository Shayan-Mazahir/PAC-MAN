class Sprite {
    PImage img;
    float x, y;
    float speedX, speedY;

    Sprite(String imagePath, float x, float y, float speedX, float speedY) {
        img = loadImage(imagePath);
        this.x = x;
        this.y = y;
        this.speedX = speedX;
        this.speedY = speedY;
    }

    void move() {
        x += speedX;
        y += speedY;

        // Wrap around the screen
        if (x > width) x = 0;
        if (x < 0) x = width;
        if (y > height) y = 0;
        if (y < 0) y = height;
    }

    void display() {
        image(img, x, y);
    }
}

Sprite pacman;

void setup() {
    size(600, 400);
    pacman = new Sprite("gohst.jpg", width / 2, height / 2, 2, 2);
}

void draw() {
    background(0);
    pacman.move();
    pacman.display();
}
