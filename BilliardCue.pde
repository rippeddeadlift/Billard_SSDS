class BilliardCue {
  float x;         
  float y;       
  float length;   
  float thickness; 
  boolean isSelected = false;
  float mass ;      
  float vx;        // Velocity x-axis
  float vy;        // Velocity y-axis
boolean isDragging = false; 
PVector cueOffset;
  // Constructor
  BilliardCue(float startX, float startY, float cueThickness, float cueLength) {
    x = startX;
    y = startY;
    length = cueLength;
    thickness = cueThickness;
    mass = 5f;  
    vx = 10f;  
    vy = 0;
  }
void display() {
    noStroke();

    fill(205, 133, 63);
    rect(x, y - length, thickness, length); 
    // (top of the cue)
    fill(30, 30, 30);
    ellipse(x + thickness / 2, y - length, thickness, thickness); 
    fill(139, 69, 19);
    rect(x, y - length, thickness * 0.25, length);
}
boolean isMouseOverCue() {
    boolean isOverCue = mouseX >= x - thickness&& mouseX <= x  && 
                        mouseY <= y && mouseY >= y - length;
    System.out.printf("Mouse Position: X=%.2f, Y=%.2f\n", (float) mouseX, (float) mouseY);
    System.out.printf("Cue Position: X=%.2f, Y=%.2f | Length=%.2f, Thickness=%.2f\n", x, y, length, thickness);
    System.out.printf("Is Mouse Over Cue: %s\n", isOverCue ? "YES" : "NO");
    return isOverCue;
}
  
    void drag() {
    if (isSelected) {
      x = mouseX - length / 2; 
      y = mouseY - thickness / 2;
    }
  }
  void updateVelocity(float newVx, float newVy) {
    vx = newVx;
    vy = newVy;
  }



}
