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
  PImage texture;
  PShape our_cue;

    BillardCue(float startX, float startY, float cueThickness, float cueLength, float cueOffset, PImage texture) {
        this.cueOffset = cueOffset;
        this.x = startX;
        this.y = startY;
        this.length = cueLength;
        this.thickness = cueThickness;
        this.mass = 3.2f;  
        this.vx = 0f;  
        this.vy = 0;
        our_cue = createShape();
        our_cue.beginShape(QUADS);
        our_cue.texture(texture);
        our_cue.noStroke();
        our_cue.vertex(0, -thickness / 2, 0, 0);
        our_cue.vertex(length, -thickness / 2, texture.width, 0);
        our_cue.vertex(length, thickness / 2, texture.width, texture.height);
        our_cue.vertex(0, thickness / 2, 0, texture.height);        
        our_cue.endShape();
    }

    void display() {
        pushMatrix(); 
        translate(x, y); 
        rotate(angle); 
        shape(our_cue);
        popMatrix(); 
    }

  




}
