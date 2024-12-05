class BilliardCue {
  float x;         
  float y;       
  float length;   
  float thickness; 
  boolean isSelected = false;
  float mass ;      // Mass of the cue (add this variable)
  float vx;        // Velocity of the cue along the x-axis
  float vy;        // Velocity of the cue along the y-axis

  // Constructor
  BilliardCue(float startX, float startY, float cueLength, float cueThickness) {
    x = startX;
    y = startY;
    length = cueLength;
    thickness = cueThickness;
    mass = 3.5f;  // Directly assign mass
    vx = 5.0f;    // Directly assign velocity
    vy = 0;
  }

  // Method to display the cue
  void display() {
    noStroke();

    // Cue Shaft
    fill(205, 133, 63); 
    rect(x, y, length, thickness); 

    // Cue Tip
    fill(30, 30, 30); 
    ellipse(x + length, y + thickness / 2, thickness, thickness); 

    // Grip Area
    fill(139, 69, 19); 
    rect(x, y, length * 0.25, thickness); 
  }

  void checkMousePressed() {
    if (mouseX >= x && mouseX <= x + length &&
        mouseY >= y && mouseY <= y + thickness) {
      isSelected = true; // Set to selected if clicked
    } else {
      isSelected = false; // Deselect if clicked outside
    }
  }
  
  void drag() {
  if (isSelected && mousePressed) {
    x = mouseX - length / 4; // Center cue under the mouse
    y = mouseY - thickness / 4;
  }
}
  void updateVelocity(float newVx, float newVy) {
    vx = newVx;
    vy = newVy;
  }



}
