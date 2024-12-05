

// Class for animating sprites.
class Animation {
  //Initial for sprite animation
  PImage[] images;
  int imageCount;
  int frame;

  //creating loading counter.
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];


    for (int i = 0; i < imageCount; i++) {
      //'i' goes through the files to load.
      String filename = imagePrefix + i + ".png";
      images[i] = loadImage(filename);
    }
  }


  //Displaying sprite animated.
  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }

  int getWidth() {
    return images[0].width;
  }
}
