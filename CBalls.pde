
/**
 * Container class for a number (totalball) of Ball objects
 */
public class CBalls {

  boolean mousedown   = false;

  Ball[] ball;

  CBalls(PApplet pApp, int totalball) {
    minim = new Minim(pApp);

    ball = new Ball[totalball];
    for (int bn=0; bn < ball.length; bn++)
      ball[bn] = new Ball(minim, bn);
  }

  void draw()
  {
    // draw the balls
    for (int bn=0; bn < ball.length; bn++)
      ball[bn].draw();
  }

  void game_physics() {
    for (int bn = 0; bn < ball.length; bn++) {
      ball[bn].game_physics();
    }
    detectCollisions();  // Check for collisions after updating physics
  }

  void detectCollisions() {
    for (int i = 0; i < ball.length; i++) {
      for (int j = i + 1; j < ball.length; j++) {
        Ball b1 = ball[i];
        Ball b2 = ball[j];

        // Calculate distance between balls
        float dx = (float)(b1.sx - b2.sx);
        float dy = (float)(b1.sy - b2.sy);
        float distance = (float)Math.sqrt(dx * dx + dy * dy);

        // Check if the distance is less than the sum of their radii
        if (distance < b1.Radius() + b2.Radius()) {
          // Simple elastic collision response
          float overlap = 0.5f * (distance - b1.Radius() - b2.Radius());

          // Adjust positions to separate balls
          b1.sx -= overlap * (b1.sx - b2.sx) / distance;
          b1.sy -= overlap * (b1.sy - b2.sy) / distance;
          b2.sx += overlap * (b1.sx - b2.sx) / distance;
          b2.sy += overlap * (b1.sy - b2.sy) / distance;

          // Calculate the normal vector
          float nx = dx / distance;
          float ny = dy / distance;

          // Calculate relative velocity
          float dvx = (float)(b1.vx - b2.vx);
          float dvy = (float)(b1.vy - b2.vy);

          // Calculate the relative velocity in the normal direction
          float dotProduct = dvx * nx + dvy * ny;

          // Only resolve collision if balls are moving toward each other
          if (dotProduct > 0) continue;

          // Calculate the impulse scalar
          float impulse = 2 * dotProduct / (float)(b1.MASS + b2.MASS);

          // Apply the impulse to each ball's velocity
          b1.vx -= impulse * b2.MASS * nx;
          b1.vy -= impulse * b2.MASS * ny;
          b2.vx += impulse * b1.MASS * nx;
          b2.vy += impulse * b1.MASS * ny;
        }
      }
    }
  }



  void stop()
  {
    // make sure to close all AudioPlayer objects
    for (int bn=0; bn < ball.length; bn++) {
      ball[bn].kick.close();
      ball[bn].snare.close();
    }

    minim.stop();
  }

  /* Clicked mouse */
  void Mouse ()
  {
    if (mouseButton == LEFT) System.out.printf("State: MOUSE_DOWN\n");
    for (int bn=0; bn < ball.length; bn++) {
      ball[bn].Mouse();
    }
  }

  /* Released mouse */
  void MouseUp ()
  {
    System.out.printf("State: MOUSE_RELEASED\n");
    for (int bn=0; bn < ball.length; bn++) {
      ball[bn].MouseUp();
    }
  }
}
