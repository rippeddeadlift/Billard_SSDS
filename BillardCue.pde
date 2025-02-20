class BillardCue {
  float x;         
  float y;       
  float length;   
  float thickness; 
  boolean isSelected = false;
  float mass ;      
  float vx;        // Velocity x-axis
  float vy;        // Velocity y-axis
  float angle = HALF_PI;  
  float cueOffset;
  float shootStrength;
boolean isDragging = false; 
  BillardCue(float startX, float startY, float cueThickness, float cueLength, float cueOffset) {
    this.cueOffset = cueOffset;
    x = startX;
    y = startY;
    length = cueLength;
    thickness = cueThickness;
    mass = 3.2f;  
    vx = 0f;  
    vy = 0;
  }
void display() {
  float cueTipX = x + cos(angle) * length; // End position X
  float cueTipY = y + sin(angle) * length; // End position Y


  stroke(#D19A6A);
  strokeWeight(thickness);
  line(x, y, cueTipX, cueTipY); // Draw the line from the starting position to the tip
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
