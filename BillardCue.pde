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
  boolean isCueVisible = true;

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
  float cueTipX = x + cos(angle) * length; 
  float cueTipY = y + sin(angle) * length; 
  stroke(#D19A6A);
  strokeWeight(thickness);
  line(x, y, cueTipX, cueTipY); 
}

  




}
