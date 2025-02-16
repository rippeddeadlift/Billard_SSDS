
/**
 * Container class for a number (totalball) of Ball objects
 */
 import java.util.*;
public class CBalls {

  PImage texture;
  boolean mousedown   = false;
  ArrayList<Integer> billardNumbers = new ArrayList();
  
  ArrayList<Ball> ballContainer = new ArrayList();

  CBalls(int totalball) {
    billardNumbers.addAll(List.of(1,2,3,4,5,6,7,9,10,11,12,13,14,15));
    for (int bn=0; bn < totalball; bn++){
        if(bn == 10){
          texture = loadImage("billard_textures/8.jpg");
          ballContainer.add(new Ball(bn, texture));
        }else{
          int random = (int)random(billardNumbers.size());
          int randomFromArray = billardNumbers.get(random); //<>//
          billardNumbers.remove(Integer.valueOf(randomFromArray));
          texture = loadImage("billard_textures/" + randomFromArray +".jpg");
          ballContainer.add(new Ball(bn, texture));
        }
    }
    ballContainer.add(new Ball());
  }

  void draw()
  {
    // draw the balls
    for (int bn=0; bn < ballContainer.size(); bn++){
      ballContainer.get(bn).draw();
    }
  }

  void game_physics() {
    for (int bn = 0; bn < ballContainer.size(); bn++) {
      ballContainer.get(bn).game_physics();
    }
    detectCollisions();  
    detectCueCollisions();
  }

  void detectCollisions() {
    for (int i = 0; i < ballContainer.size(); i++) {
      for (int j = i + 1; j < ballContainer.size(); j++) {
        Ball b1 = ballContainer.get(i);
        Ball b2 = ballContainer.get(j);

        // Distanz zwischen den Bällen
        // die Differenz der x & y -Koordinaten          
        // Formel um Distanz zu berechnen: sqrt((b2.sx-b1.sx)^2 + (b2.sy-b1.sy)^2)

        float dx = (float)(b1.sx - b2.sx);
        float dy = (float)(b1.sy - b2.sy);
        float distance = (float)Math.sqrt(dx * dx + dy * dy);  


        if (distance < b1.Radius() + b2.Radius()) {
          // Simple elastic collision response
          float overlap = 0.5f * (distance - b1.Radius() - b2.Radius());

          // Adjust positions to separate balls
          b1.sx -= overlap * (b1.sx - b2.sx) / distance;
          b1.sy -= overlap * (b1.sy - b2.sy) / distance;
          b2.sx += overlap * (b1.sx - b2.sx) / distance;
          b2.sy += overlap * (b1.sy - b2.sy) / distance;

          // Einheitsvektor, zeigt die Richtung des Vektors an
          float nx = dx / distance;
          float ny = dy / distance;

          // Relative Geschwindigkeit
          float dvx = (float)(b1.vx - b2.vx);
          float dvy = (float)(b1.vy - b2.vy);

          // Skalarprodukt zweier Vektoren 
          float skalarprodukt = dvx * nx + dvy * ny;

          if (skalarprodukt > 0) continue;

          // Calculate the impulse scalar
          float impulse = 2 * skalarprodukt / (float)(b1.MASS + b2.MASS);

          // Apply the impulse to each ball's velocity
          b1.vx -= impulse * b2.MASS * nx;
          b1.vy -= impulse * b2.MASS * ny;
          b2.vx += impulse * b1.MASS * nx;
          b2.vy += impulse * b1.MASS * ny;
        }
      }
    }
  }
void detectCueCollisions() {
  for (int i = 0; i < ballContainer.size(); i++) {
    Ball b = ballContainer.get(i);

    // Position of the cue tip
    float cueTipX = billiardCue.x + billiardCue.length;
    float cueTipY = billiardCue.y + billiardCue.thickness / 2;
    float fBallx = (float)b.sx; 
    float fBallxy = (float)b.sy; 
    // Calculate distance between cue tip and the ball
    float distance = dist(cueTipX, cueTipY, fBallx, fBallxy);

    // Debugging: Print distance and ball radius
    //println("Cue-Ball Distance: " + distance + " Ball Radius: " + b.Radius());

    // Check if distance is less than the ball's radius (i.e., if the cue tip is colliding with the ball)
    if (distance < b.Radius()) {
      // Calculate the direction of the force
      float dx = (float)(cueTipX - b.sx);  
      float dy = (float)(cueTipY - b.sy); 
      float normalizedDist = sqrt(dx * dx + dy * dy); // Calculate the magnitude
      float nx = dx / normalizedDist;
      float ny = dy / normalizedDist;

      // Calculate the cue's momentum (mass * velocity)
      float cueSpeed = sqrt(billiardCue.vx * billiardCue.vx + billiardCue.vy * billiardCue.vy);
      float cueMomentum = billiardCue.mass * cueSpeed;

      // Apply momentum transfer from cue to ball
      float impulse = (float)(cueMomentum / b.MASS); 

      // Apply a velocity to the ball based on the cue's momentum and mass
      b.vx += nx * impulse;
      b.vy += ny * impulse;

      // Debugging: Print the new ball velocity and cue momentum
      //println("Cue Momentum: " + cueMomentum);
      //println("Ball Velocity after Impulse: (" + b.vx + ", " + b.vy + ")");
    }
  }
}

  /* Clicked mouse */
  void Mouse ()
  {
    if (mouseButton == LEFT) System.out.printf("State: MOUSE_DOWN\n");
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
