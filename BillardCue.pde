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
  float cueLength = 400;   
  float cueOffset = 25;  
  float cueThickness = 10;
  float initialY;
  boolean isDragging = false;
  Ball whiteBall;
  int sides = 50;
  float radius = 5;
  PImage texture = loadImage("billard_textures/cue_texture.jpg");

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
    getCueShape();
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

  void getCueShape() {
  pushMatrix();
  rotateZ(HALF_PI);
  rotateX(HALF_PI);

fill(0, 255, 0);
  beginShape();
  for (int i = 0; i < sides; i++) {
    float angle = TWO_PI / sides * i;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    vertex(x, y, 0);
  }
  endShape(CLOSE);

  beginShape();
  for (int i = 0; i < sides; i++) {
    float angle = TWO_PI / sides * i;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    vertex(x, y, cueLength);
  }
  endShape(CLOSE);

  beginShape(QUAD_STRIP);
  texture(texture); // Apply the texture
  for (int i = 0; i <= sides; i++) {
    float angle = TWO_PI / sides * i;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    float u = map(i, 0, sides, 0, texture.width); // Map texture coordinates along the circumference
    vertex(x, y, 0, u, 0);
    vertex(x, y, cueLength, u, texture.height); // Stretch texture along the length
  }
  endShape();

  popMatrix();
}
}
