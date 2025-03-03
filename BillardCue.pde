class BillardCue {
  PVector cuePosition;
  boolean isSelected = false;
  float cueMass = 3.2f;
  PVector cueVelocity = new PVector(0f,0f);
  float angle = HALF_PI;  
  float shootStrength;
  boolean isCueVisible = true;
  boolean cueAnimating = false;
  float cueAnimationProgress = -HALF_PI;
  float cueSpeed = 0.05;
  float cueLength = 500;   
  float cueOffset = 50;  
  float cueThickness = 10;


    BillardCue(Ball whiteBall) {
        this.cuePosition = new PVector(whiteBall.Sx() - cueThickness / 2, whiteBall.Sy());
    }

    void display() {
        float animatedOffset = 50 * sin(cueAnimationProgress) + 20; 
        float offsetX = animatedOffset * cos(angle); 
        float offsetY = animatedOffset * sin(angle);  
        pushMatrix(); 
        translate(cuePosition.x + offsetX, cuePosition.y + offsetY);
        rotate(angle); 
        shape(getCueShape());
        popMatrix(); 
    }
  void resetCue() {
      cueAnimationProgress = -HALF_PI;
      shootStrength = 0;
  }


  PShape getCueShape(){
    PShape our_cue;
    PImage texture = loadImage("billard_textures/cue.jpg");
    our_cue = createShape();
    our_cue.beginShape(QUADS);
    our_cue.texture(texture);
    our_cue.noStroke();
    our_cue.vertex(0, -cueThickness / 2, 0, 0);
    our_cue.vertex(cueLength, -cueThickness / 2, texture.width, 0);
    our_cue.vertex(cueLength, cueThickness / 2, texture.width, texture.height);
    our_cue.vertex(0, cueThickness / 2, 0, texture.height);        
    our_cue.endShape();
    return our_cue;
  }

  void animateHit() {
    if (!cueAnimating) {
      cueAnimationProgress = -HALF_PI;
      cueAnimating = true;
    }
  }
}
