class Walker{
 
  PImage sprite;
  PImage frame;
  ArrayList <PImage> run= new ArrayList<PImage>();
  boolean forward = true;
  int framecount;
  int direction;
  PVector position;
  PVector speed;
  boolean left;
  
  Walker(int startX, int startY){
    sprite = loadImage("spritesheet.png");
    direction = floor(random (-1, 1));
    left = boolean(direction);
    position = new PVector(startX, startY);
    speed = new PVector(2, random(-2, 2));
    
    if (left){speed.x = -speed.x;}
    
    for(int y = 0; y < 32; y+=16){
      for(int x = 0; x< sprite.width; x+=16){
          run.add(sprite.get(x, y, 16, 16));

      }
    }

    framecount = floor(random(run.size()));

  }
  
  void update(){

    position.add(speed);
    framecount++;
    
    if(position.x > width/2-10 || position.x<0){
       left = !left; 
       speed.x = -speed.x;
    }
     
    if(position.y > height/2-16 || position.y<0){
       speed.y = -speed.y;
    }
     
    if(framecount > run.size()-1){
      framecount=0;
    }
  }
  
  void show(){
     
     if (left){
       pushMatrix();
       scale(-2.0, 2.0);
       image(run.get(framecount), -position.x-10, position.y);
       popMatrix();      
   }
     else{
       pushMatrix();
       scale(2, 2);
       image(run.get(framecount), position.x, position.y);
       popMatrix();
     }
     
   }

}
