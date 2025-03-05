class BillardCue {
  PVector cuePosition;
  boolean isSelected = false;
  float cueMass = 3.2f;
  PVector cueVelocity = new PVector(0f, 0f);
  float angle = HALF_PI;  
  float shootStrength;
  boolean isCueVisible = true;
  boolean cueAnimating = false;
  float cueAnimationProgress = -HALF_PI;
  float cueSpeed = 0.05;
  float cueLength = 500;   
  float cueOffset = 25;  
  float cueThickness = 10;
  float initialY;
  boolean isDragging = false;
  Ball whiteBall;

  BillardCue(Ball whiteBall) {
    this.cuePosition = new PVector(whiteBall.Sx() - cueThickness / 2, whiteBall.Sy());
    this.whiteBall = whiteBall;
  }

void display() {
    if (isDragging) {
        updateDrag( mouseY);  
    } else {
        updateCue();  
    }
    pushMatrix();
    translate(cuePosition.x, cuePosition.y);  
    rotate(angle);  
    shape(getCueShape());  
    popMatrix();
}

void updateDrag(float mouseY) { 
    if (isDragging) {
        float dragDistance = mouseY - initialY;
        dragDistance = constrain(dragDistance, 0, 150);
        cuePosition.y = whiteBall.Sy() + dragDistance; 
        shootStrength = map(abs(dragDistance), 0, 150, 0, 150);
        float cueOffset = whiteBall.Radius() + shootStrength + 6; 
        cuePosition.x = whiteBall.Sx() + cos(angle) * cueOffset;
        cuePosition.y = whiteBall.Sy() + sin(angle) * cueOffset;
    }
}

  void updateCue() {
      float ballX = (float) whiteBall.sx;
      float ballY = (float) whiteBall.sy;
      float cueOffset = this.cueOffset;

      if (mouseButton != RIGHT) {
          float dx = mouseX - ballX;
          float dy = mouseY - ballY;
          angle = atan2(dy, dx);
      }
      float cueStartX = ballX + cos(angle) * (cueOffset + cueThickness / 2);
      float cueStartY = ballY + sin(angle) * (cueOffset + cueThickness / 2);
      cuePosition.x = cueStartX;
      cuePosition.y = cueStartY;
      if (cueAnimating) {
          cueAnimationProgress += cueSpeed;
      }
  }

  void resetCue() {
    cueAnimationProgress = -HALF_PI;
    shootStrength = 0;
  }

  void startDrag() {
    isDragging = true;
    initialY = mouseY;
  }

  float releaseDrag() {
    isDragging = false;
    cuePosition.y = initialY; 
    return shootStrength;
  }

  PShape getCueShape() {
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
}
