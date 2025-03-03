public class VectorDrawer {
  public void draw(CBalls balls, Ball b, BillardCue cue) {
    getVectorCollision(balls, b, cue);
  }
  
  void getVectorCollision(CBalls balls,Ball b, BillardCue c){
    PVector endPoint = new PVector(b.Sx(), b.Sy());
    PVector cueDirection = PVector.sub(new PVector(b.Sx(), b.Sy()), c.cuePosition).normalize();
    boolean hit = false;
    
    while (!hit) {
        endPoint.add(cueDirection);
        for (Ball ball : balls.ballContainer) {
            if (ball != b && PVector.dist(endPoint, new PVector(ball.Sx(), ball.Sy())) < ball.Radius() + b.Radius()) {
                hit = true;
                drawPredictedPath(ball, new PVector(endPoint.x, endPoint.y), cueDirection);
                break;
            }
        }
        
        if (endPoint.x < 0 || endPoint.x > width || endPoint.y < 0 || endPoint.y > height) {
            hit = true;
        }
    }
    stroke(#FFFFFF);
    strokeWeight(1);
    line(c.cuePosition.x, c.cuePosition.y, endPoint.x, endPoint.y);
    noFill();
    ellipse(endPoint.x, endPoint.y, b.Radius() * 2, b.Radius() * 2);
  }
  
   void drawPredictedPath(Ball hitBall, PVector ellipsePosition, PVector cueDirection) {
      PVector collisionNormal = PVector.sub(new PVector(hitBall.Sx(), hitBall.Sy()), ellipsePosition).normalize();
      PVector relativeVelocity = cueDirection.copy();
      float speed = relativeVelocity.dot(collisionNormal);
      float impulse = 2 * speed / ((float)hitBall.MASS * 2);
      PVector predictedVelocity = collisionNormal.copy().mult(impulse * (float)hitBall.MASS);
      PVector futurePosition = new PVector(hitBall.Sx(), hitBall.Sy()).add(PVector.mult(predictedVelocity, 100));
      stroke(255, 0, 0);
      line(hitBall.Sx(), hitBall.Sy(), futurePosition.x, futurePosition.y);
  } //<>//
}
