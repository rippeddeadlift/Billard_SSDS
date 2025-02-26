
/**
 * Container class for a number (totalball) of Ball objects
 */
import java.util.*;
public class CBalls {
   
  BillardCue billardCue;
  PImage texture;
  boolean mousedown   = false;
  ArrayList<Integer> billardNumbers = new ArrayList();
  ThreeDimensionalBillardCue threeDimensionalBillardCue;
  
  ArrayList<Ball> ballContainer = new ArrayList();
  Table table;
  float velocityThreshold = 0.2; 
  boolean isStrengthIncreasing;
  float decayRate = 0.5; 

  CBalls(int totalball, Table table) {
    this.table = table;
    billardNumbers.addAll(List.of(1,2,3,4,5,6,7,9,10,11,12,13,14,15));
    for (int bn=0; bn < totalball; bn++){
        if(bn == 10){
          texture = loadImage("billard_textures/8.jpg");
          ballContainer.add(new Ball(bn, texture));
        }else{
          int random = (int)random(billardNumbers.size()); //<>// //<>//
          int randomFromArray = billardNumbers.get(random); //<>//
          billardNumbers.remove(Integer.valueOf(randomFromArray)); //<>//
          texture = loadImage("billard_textures/" + randomFromArray +".jpg"); //<>//
          ballContainer.add(new Ball(bn, texture));
        }
    }
    ballContainer.add(new Ball());
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
            if (abs( (float) ball.vx) > velocityThreshold || abs((float) ball.vy) > velocityThreshold) {
                return false;
            }
            
    }
  return true;
  }

  void game_physics() {
    for (int bn = 0; bn < ballContainer.size(); bn++) {
      ballContainer.get(bn).game_physics();
    }
    detectPocketTouch();
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
    if (key == ' ') {
        isStrengthIncreasing = true; 
        billardCue.animateHit();
    }
}
void detect3DCueCollision(){
    for (int i = 0; i < ballContainer.size(); i++) {
      Ball b = ballContainer.get(i);
      if(b.isWhiteBall){
        // Calculate distance between cue tip and the ball
        float distance = dist(threeDimensionalBillardCue.cueTipPosition.x, threeDimensionalBillardCue.cueTipPosition.y, b.Sx(), b.Sy());
        if (distance < b.Radius()) {
        // Calculate the direction of the force
         print("detected");
         float dx = (float)(threeDimensionalBillardCue.cueTipPosition.x - b.sx);  
        float dy = (float)(threeDimensionalBillardCue.cueTipPosition.y - b.sy); 
        float normalizedDist = sqrt(dx * dx + dy * dy); // Calculate the magnitude
        float nx = dx / normalizedDist;
        float ny = dy / normalizedDist;
  
        // Calculate the cue's momentum (mass * velocity)
        float cueSpeed = sqrt(threeDimensionalBillardCue.cueVelocity.x * threeDimensionalBillardCue.cueVelocity.x + threeDimensionalBillardCue.cueVelocity.y * threeDimensionalBillardCue.cueVelocity.y);
        float cueMomentum = 5 * cueSpeed;
  
        // Apply momentum transfer from cue to ball
        float impulse = (float)(cueMomentum / b.MASS); 
  
        // Apply a velocity to the ball based on the cue's momentum and mass
        b.vx += nx * impulse;
        b.vy += ny * impulse;
      }
      }
  }
  }
  void detectPocketTouch(){
    
    // this is disgusting, ArrayOutOfIndex exception could be thrown when multiple balls get removed on 1 frame
    for (int i = 0; i < ballContainer.size(); i++) {
      for (int j = 0; j < table.pockets.coordinates.size(); j++) {
        Ball b1 = ballContainer.get(i);
        PVector b2 = table.pockets.coordinates.get(j);
        float dx = (float)(b1.sx - b2.x);
        float dy = (float)(b1.sy - b2.y);
        float distance = (float)Math.sqrt(dx * dx + dy * dy);  

        if (distance < b1.Radius() + table.pockets.pocketRadius/2) {
          println("remove");
          this.ballContainer.remove(b1);
        }
      }
    }
  }
  
  PVector getWhiteBallCoordinates(){
    for(int i = 0; i < ballContainer.size(); i++){
      Ball b = ballContainer.get(i);
      if(b.isWhiteBall){
        return new PVector(b.Sx(), b.Sy());
      }
    }
    return null;
  }

void keyReleased() {
  billardCue.isCueVisible = false;
  billardCue.cueAnimating = false;
  isStrengthIncreasing = false; 
  Ball b = getWhiteBall();
  println(b);
  hitBall(getWhiteBall());  
  billardCue.resetCue();
}
void hitBall(Ball whiteBall) {
    float cueTipX = billardCue.x + billardCue.thickness / 2; 
    float cueTipY = billardCue.y - billardCue.length;
    float distance = dist(cueTipX, cueTipY, (float) whiteBall.sx, (float) whiteBall.sy);
    
    if (distance > 0) { 
        float velocity = billardCue.shootStrength * (float) (billardCue.mass / whiteBall.MASS);
        float angleDirX = cos(billardCue.angle);
        float angleDirY = sin(billardCue.angle);
        whiteBall.vx += angleDirX * -velocity;
        whiteBall.vy += angleDirY * -velocity;
        billardCue.shootStrength = 0;
    }
  }
   
  Ball getWhiteBall(){
    for(Ball b : this.ballContainer){
      if(b.isWhiteBall) return b;
    }
    return null;
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
