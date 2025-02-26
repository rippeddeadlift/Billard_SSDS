public class VectorDrawer {
  PVector position;
  PVector velocity;
  PVector acceleration;
 
  public void draw(CBalls balls) {
    for (Ball ball : balls.ballContainer) {
      position = new PVector((float)ball.sx, (float)ball.sy);
      velocity = new PVector((float)ball.vx, (float)ball.vy);
      
      PVector direction = velocity.copy().normalize().mult((float)ball.radius);
      PVector start = PVector.add(position, direction);
      
      drawArrow(start.x, start.y, start.x + velocity.x, start.y + velocity.y);
    }
  }
  
  void drawArrow(float x1, float y1, float x2, float y2) {
    stroke(#00FF00);
    strokeWeight(1.5);
    float a = dist(x1, y1, x2, y2) / 30;
    pushMatrix();
    translate(x2, y2);
    rotate(atan2(y2 - y1, x2 - x1));
    triangle(-a * 2, -a, 0, 0, -a * 2, a);
    popMatrix();
    line(x1, y1, x2, y2);  
  }
}
