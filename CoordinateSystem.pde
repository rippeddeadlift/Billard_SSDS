public class CoordinateSystem{
  void draw() {
  stroke(0);
  // Draw x-axis
  line(0, height/2, width, height/2);
  // Draw y-axis
  line(width/2, 0, width/2, height);
  
  // Draw arrows for x-axis
  line(width, height/2, width-10, height/2-10);
  line(width, height/2, width-10, height/2+10);
  
  // Draw arrows for y-axis
  line(width/2, 0, width/2-10, 10);
  line(width/2, 0, width/2+10, 10);
  
  // Draw labels
  textSize(12);
  text("X", width-15, height/2-10);
  text("Y", width/2+10, 15);
  
  // Draw numbers on x-axis
  for (int i = -width/2; i <= width/2; i += 50) {
    if (i != 0) {
      text(i, width/2 + i, height/2 + 15);
    }
  }
  
  // Draw numbers on y-axis
  for (int i = -height/2; i <= height/2; i += 50) {
    if (i != 0) {
      text(i, width/2 + 5, height/2 - i);
    }
  }
}
}
