import java.util.*;

public class CBalls {
  BillardCue billardCue;
  PImage texture;
  float ballRadius = 0.4f * 35;
  boolean mousedown   = false;
  ArrayList<Integer> billardNumbers = new ArrayList();
  ArrayList<Ball> ballContainer = new ArrayList();
  Table table;
  float velocityThreshold = 0.5; 
  float decayRate = 0.5; 
  ArrayList<Ball> pocketedBalls = new ArrayList<>();   
  ArrayList<Ball> ballsToRemove = new ArrayList<>();
  boolean manageReady = false;
  GameController gameController;

CBalls (Table table, GameController gameController) {
    this.table = table;
    this.gameController = gameController;    
    initializeBallNumbers();    
    ballContainer.add(new Ball(ballRadius)); // whiteball
}

void initializeBallNumbers() {
    billardNumbers.addAll(List.of(1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15));
}

void initializeBalls(int totalball) {
    for (int bn = 0; bn < totalball; bn++) {
        addBall(bn);
    }
}

ArrayList<PVector> getInitialPositionsOfBalls() {
  ArrayList<PVector> positionList = new ArrayList();
  int rows = (int) sqrt(2 * 15);
  for (int i = 0; i < rows; i++) {
    int ballsInRow = rows - i;
    float y = height/6 + i * sqrt(3) * ballRadius;
    for (int j = 0; j < ballsInRow; j++) {
      float x = width/2 - (ballsInRow - 1) * ballRadius + 2 * j * ballRadius;
      positionList.add(new PVector(x,y));
    }
  }
  return positionList;
}


void addBall(int count) {
    List<PVector> position = getInitialPositionsOfBalls();
    if(count == 10){
      PImage texture = loadImage("billard_textures/8.jpg");
      ballContainer.add(new Ball(count, texture, 8, position.get(count), ballRadius));
    }else{
      int randomIndex = (int) random(billardNumbers.size());
      int randomNumber = billardNumbers.get(randomIndex);
      billardNumbers.remove(Integer.valueOf(randomNumber));
      PImage texture = loadImage("billard_textures/" + randomNumber + ".jpg");
      ballContainer.add(new Ball(count, texture, randomNumber, position.get(count), ballRadius));
    }
}
    
  void setCue(BillardCue c) {
      this.billardCue = c;
  }
  void draw(GameState gameState)
    {
      // draw the balls
      for (int bn=0; bn < ballContainer.size(); bn++){
        ballContainer.get(bn).draw();
      }
      if(gameState == GameState.BREAKSHOT){
        placeWhiteBallForBreakShot();
      }
      if(gameState == GameState.FOUL && areAllBallsStationary()){
        placeWhiteBallAfterFoul();
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

  void game_physics(boolean enabled) {
    for (int bn = 0; bn < ballContainer.size(); bn++) {
        ballContainer.get(bn).game_physics();
      }
    if(enabled){
    detectPocketTouch();
    detectCollisions();  
    }
  }

  void detectCollisions() {
      //log(n^2) Algorithmus (BF)
      bruteforce();
    }
    void bruteforce() {
      for (Ball b1 : ballContainer) {
          for (Ball b2 : ballContainer) {
            if(b1.isFadingOut || b2.isFadingOut)
            {
              continue;
            }
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


     float skalarprodukt = dvx * nx + dvy * ny;
  
     if (skalarprodukt <= 0){
       float impulse = 2 * skalarprodukt / (float)(b1.MASS + b2.MASS);
  
       b1.vx -= impulse * b2.MASS * nx;
       b1.vy -= impulse * b2.MASS * ny;
       b2.vx += impulse * b1.MASS * nx;
       b2.vy += impulse * b1.MASS * ny;
     };
 
  }

boolean solidBallsRemaining() {
    for (Ball b : ballContainer) {
        if (b.ballType == BallType.SOLID && !b.isPocketed()) {
            return true;  
        }
    }
    return false; 
}
boolean stripeBallsRemaining() {
    for (Ball b : ballContainer) {
        if (b.ballType == BallType.STRIPE && !b.isPocketed()) {
            return true; 
        }
    }
    return false; 
}

void detectPocketTouch() {
    Iterator<Ball> iterator = ballsToRemove.iterator();
    while (iterator.hasNext()) {
        Ball b = iterator.next();
        if (b.scale < 0.5) {
            b.setVisibility(false);
            ballContainer.remove(b);
            iterator.remove();
        }
    }

    for (int i = 0; i < ballContainer.size(); i++) {
        for (int j = 0; j < table.pockets.coordinates.size(); j++) {
            Ball b = ballContainer.get(i);
            PVector b2 = table.pockets.coordinates.get(j);
            float dx = (float)(b.Sx() - b2.x);
            float dy = (float)(b.Sy() - b2.y);
            float distance = (float)Math.sqrt(dx * dx + dy * dy);
            if (distance < b.Radius() + table.pockets.pocketRadius / 2) {
                if (!b.isWhiteBall) {         
                    ballsToRemove.add(b);  
                    b.vx = 0;
                    b.vy = 0;       
                    b.pocketed = true;
                    pocketedBalls.add(b);               
                } else {
                    b.vx = 0;
                    b.vy = 0;       
                    b.pocketed = true;
                    pocketedBalls.add(b);               
                }
            }
        }
    }

    if (areAllBallsStationary() && manageReady) {
        gameController.manage(pocketedBalls);
        pocketedBalls.clear();
        manageReady = false;
    }
}



PVector getWhiteBallCoordinates() { return new PVector(getWhiteBall().Sx(), getWhiteBall().Sy()); };

void placeWhiteBallForBreakShot(){
    var ball = getWhiteBall();
    ball.sx =
      constrain(mouseX,0,width);
}
void placeWhiteBallAfterFoul() {
    Ball ball = getWhiteBall();  
        if (ball.scale <= 0.5){          
          ball.pocketed = false;           
          ball.isFadingOut = false;
          ball.our_sphere.scale(2); 
          ball.scale = 1;
        } 
        if ( ball.scale == 1){
          ball.setVisibility(true);
          ball.sx = mouseX; 
          ball.sy = mouseY; 
        }
}


void mousePressed() {
  if( currentGameState != GameState.BREAKSHOT){

    billardCue.startDrag();
  }
}

void mouseReleased() {
  gameController.playerSwitched = false;
  billardCue.isCueVisible = false;
  billardCue.cueAnimating = false;
  billardCue.releaseDrag();
  hitBall(getWhiteBall()); // Shoot the ball   
  manageReady = true;  
  billardCue.resetCue();
}

void updateRadius(float newValue){
  this.ballRadius = newValue;
  for(Ball b : ballContainer){
    b.setRadius(newValue);
  }
}
void updateFriction(float newValue){
  for(Ball b : ballContainer){
    b.setFriction(newValue);
  }
}
void updateMass(float newValue){
  for(Ball b : ballContainer){
    b.setMass(newValue);
  }
}

  
  void hitBall(Ball whiteBall) {
      float cueTipX = billardCue.cuePosition.x + billardCue.cueThickness / 2; 
      float cueTipY = billardCue.cuePosition.y - billardCue.cueLength;
      float distance = dist(cueTipX, cueTipY, whiteBall.Sx(),whiteBall.Sy());
      
      if (distance > 0) { 
          float velocity = billardCue.shootStrength * (float)(billardCue.cueMass / whiteBall.MASS);
          float angleDirX = cos(billardCue.angle);
          float angleDirY = sin(billardCue.angle);
          whiteBall.vx += angleDirX * -velocity;
          whiteBall.vy += angleDirY * -velocity;
      }
  }
   
  Ball getWhiteBall(){
    for(Ball b : this.ballContainer){
      if(b.isWhiteBall) return b;
    }
    return null;
  }
    Ball getBlackBall(){
    for(Ball b : this.ballContainer){
      if(b.isBlackBall) return b;
    }
    return null;
  }
}
