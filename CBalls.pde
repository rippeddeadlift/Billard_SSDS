
/**
 * Container class for a number (totalball) of Ball objects
 */
 import java.util.*;
    
public class CBalls {
   
  BillardCue billardCue;
  PImage texture;
  boolean mousedown   = false;
  ArrayList<Integer> billardNumbers = new ArrayList();
  ArrayList<Ball> ballContainer = new ArrayList();
  float velocityThreshold = 0.15; 

  CBalls(int totalball) {
    billardNumbers.addAll(List.of(1,2,3,4,5,6,7,9,10,11,12,13,14,15));
    for (int bn=0; bn < totalball; bn++){
        if(bn == 10){
          texture = loadImage("billard_textures/8.jpg");
          ballContainer.add(new Ball(bn, texture));
        }else if(bn == 15){
          ballContainer.add(new Ball(bn));
        }
        else{
          int random = (int)random(billardNumbers.size());
          int randomFromArray = billardNumbers.get(random); //<>// //<>//
          billardNumbers.remove(Integer.valueOf(randomFromArray));
          texture = loadImage("billard_textures/" + randomFromArray +".jpg");
          ballContainer.add(new Ball(bn, texture));
        }
    }
  }
void setCue(BillardCue c) {
    this.billardCue = c;
}
  void draw()
  {
    // draw the balls
    for (int bn=0; bn < ballContainer.size(); bn++){
      ballContainer.get(bn).draw();
    }
  }
boolean areAllBallsStationary() {
for (Ball ball : ballContainer) {
        // Check if ball's velocity exceeds the threshold
        if (abs( (float) ball.vx) > velocityThreshold || abs((float) ball.vy) > velocityThreshold) {
            return false;
        }
        
}return true;}

  void game_physics() {
    for (int bn = 0; bn < ballContainer.size(); bn++) {
      ballContainer.get(bn).game_physics();
    }
    detectCollisions();  
  }

  void detectCollisions() {
      //log(n^2) Algorithmus (BF)
      bruteforce();
    }
    void bruteforce() {
      for (Ball b1 : ballContainer) {
          for (Ball b2 : ballContainer) {
              //bruteForceChecks++;
              //if(!useQuadTree && displayConnections)cd.draw(b1,b2);
              if (b1 != b2) {
                  // Formel um Distanz zu berechnen: sqrt((b2.sx-b1.sx)^2 + (b2.sy-b1.sy)^2)
                  float dx = (float)(b1.sx - b2.sx);
                  float dy = (float)(b1.sy - b2.sy);
                  float distance = (float)Math.sqrt(dx * dx + dy * dy);
                  if (distance <= b1.Radius() + b2.Radius() ) {
                      collisionanswer(distance, b1, b2, dx, dy);
                  }
              }
          }

      }
  }
   void collisionanswer(float distance, Ball b1, Ball b2, float dx, float dy){
    float overlap = 0.5f * (distance - b1.Radius() - b2.Radius());
    float nx = dx / distance;
    float ny = dy / distance;
    if (overlap < 0){
      b1.sx -= overlap * (b1.sx - b2.sx) / distance;
      b1.sy -= overlap * (b1.sy - b2.sy) / distance;
      b2.sx += overlap * (b1.sx - b2.sx) / distance;
      b2.sy += overlap * (b1.sy - b2.sy) / distance;
    }
     float dvx = (float)(b1.vx - b2.vx);
     float dvy = (float)(b1.vy - b2.vy);
  

  //dot() for dot product
     float skalarprodukt = dvx * nx + dvy * ny;
  
     if (skalarprodukt <= 0){
       float impulse = 2 * skalarprodukt / (float)(b1.MASS + b2.MASS);
  
       b1.vx -= impulse * b2.MASS * nx;
       b1.vy -= impulse * b2.MASS * ny;
       b2.vx += impulse * b1.MASS * nx;
       b2.vy += impulse * b1.MASS * ny;
     };
 
  }


void keyPressed()
{
  if (keyCode == UP) {
      System.out.printf("State: Strength \n" + billardCue.shootStrength);
      billardCue.shootStrength += 5; 
    } else if (keyCode == DOWN) {      
      System.out.printf("State: Strength \n" + billardCue.shootStrength);
      billardCue.shootStrength = max(0, billardCue.shootStrength - 5);
  } else if (keyCode == LEFT) {
      System.out.printf("State: angle \n" + billardCue.angle);
      billardCue.angle += PI / 180;; 
  } else if (keyCode == RIGHT) {
      System.out.printf("State: angle \n" + billardCue.angle);
      billardCue.angle -= PI / 180;        
    } else if (key == ' ') { 
      billardCue.isCueVisible = false;
      hitBall();
    }
}
void hitBall() {
    float cueTipX = billardCue.x + billardCue.thickness / 2; 
    float cueTipY = billardCue.y - billardCue.length;
    float dirX = (float) whiteBall.sx - cueTipX;
    float dirY = (float) whiteBall.sy - cueTipY;
    float distance = dist(cueTipX, cueTipY, (float) whiteBall.sx, (float) whiteBall.sy);
    
    if (distance > 0) { 
        float normalizedDirX = dirX / distance;
        float normalizedDirY = dirY / distance;
        float velocity = billardCue.shootStrength * (float) (billardCue.mass / ballContainer.get(15).MASS);
        float angleDirX = cos(billardCue.angle);
        float angleDirY = sin(billardCue.angle);
        whiteBall.vx += angleDirX * -velocity;
        whiteBall.vy += angleDirY * -velocity;
        billardCue.shootStrength = 0;
    }
}





  /* Clicked mouse */
  void Mouse ()
  {
    if (mouseButton == LEFT) {
      System.out.printf("State: MOUSE_DOWN\n");
      }
    for (int bn=0; bn < ballContainer.size(); bn++) {
      ballContainer.get(bn).Mouse();
    }
  }

  /* Released mouse */
  void MouseUp ()
  {
    System.out.printf("State: MOUSE_RELEASED\n");
    for (int bn=0; bn < ballContainer.size(); bn++) {
      ballContainer.get(bn).MouseUp();
    }
  }
}
