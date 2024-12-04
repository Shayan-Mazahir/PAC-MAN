Walker wlk;
PImage bg;
  
Walker[] wlkrs;

float x = 0;
void setup(){
  size(800, 600);
  bg = loadImage("Background Pattern.png");
  wlkrs = new Walker[10];
  for(int i = 0; i < wlkrs.length; i++){
    wlkrs[i] = new Walker(floor(random(10, width/2-10)), floor(random(height/2-32)));
  }
  wlk = new Walker(0,0);
  
}

void draw(){
  //background(0, 150, 0);
  
  //pushMatrix();
  //scale(2, 2);
  for(int y = 0; y < height; y+=64){
    for(int i = 0; i< width; i+=64){
      image(bg, i, y, 64, 64);
    }
  }
  //popMatrix();
  
  for(int i = 0; i < wlkrs.length; i++){
    wlkrs[i].update();
    wlkrs[i].show();
  }
  //wlk.show();
  //wlk.update();  
  
}

void keyPressed(){
    //for(int i = 0; i < wlkrs.length; i++){
    //wlkrs[i].update();
    //wlkrs[i].show();
    //}
}
