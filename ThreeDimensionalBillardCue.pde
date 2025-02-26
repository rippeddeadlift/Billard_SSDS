class ThreeDimensionalBillardCue {
  int sides = 50;
  float radius = 5;
  float cueLength = 600;
  PVector startPoint;
  float dragDistance = 0;
  boolean isDragging = false;
  PVector cueTipPosition, mousePos, direction, whiteBallCoordinates;
  PVector cueVelocity = new PVector();
  
  ThreeDimensionalBillardCue() {
    startPoint = new PVector();
  }
  
  void draw(PVector whiteBallCoordinates, boolean shouldDisplayCue) {
    this.whiteBallCoordinates = whiteBallCoordinates;
    if (shouldDisplayCue) {
    mousePos = new PVector(mouseX, mouseY, 0);
    direction = PVector.sub(mousePos, whiteBallCoordinates);
    direction.normalize();
    startPoint = PVector.sub(whiteBallCoordinates, PVector.mult(direction, cueLength / 2 + 50));
    
      if (mousePressed && mouseButton == LEFT) {
      if (!isDragging) {
        // Initialize startPoint when dragging starts
        startPoint = PVector.sub(whiteBallCoordinates, PVector.mult(direction, cueLength / 2 + 50));
        isDragging = true;
      }
        // Adjust dragDistance based on mouse drag
        dragDistance += mouseY - pmouseY; // Adjust these values as needed
        PVector dragVector = PVector.mult(direction, dragDistance);
        startPoint = PVector.sub(whiteBallCoordinates, PVector.mult(direction, cueLength / 2 + 50)).add(dragVector);
    }
    
      //PVector startPoint = PVector.sub(whiteBallCoordinates, PVector.mult(direction, cueLength / 2 + 50));
      float angleZ = atan2(direction.y, direction.x);
      float angleY = acos(direction.z);
     
      
      pushMatrix();
      translate(startPoint.x, startPoint.y, startPoint.z);
     
      noStroke();
      fill(150, 50, 0);
      rotateZ(angleZ);
      rotateY(angleY);
     
      renderShapes();
      cueTipPosition = PVector.add(startPoint, PVector.mult(direction, cueLength / 2));
      
      popMatrix();
    }else{
      
      mousePos = new PVector(0,0, 0);
      direction = new PVector(0,0,0);
      direction.normalize();
      startPoint = new PVector(0,0,0);;
      cueTipPosition = new PVector(0,0,0);
    }
  }
  
  void renderShapes(){
      beginShape();
      for (int i = 0; i < sides; i++) {
        float angle = TWO_PI / sides * i;
        float x = cos(angle) * radius;
        float y = sin(angle) * radius;
        vertex(x, y, -cueLength / 2);
      }
      endShape(CLOSE);
      
      
      //untere cue tip
      beginShape();
      for (int i = 0; i < sides; i++) {
        float angle = TWO_PI / sides * i;
        float x = cos(angle) * radius;
        float y = sin(angle) * radius;
        vertex(x, y, cueLength / 2);
      }
      endShape(CLOSE);
      
      //seite des cue
      beginShape(QUAD_STRIP);
      for (int i = 0; i <= sides; i++) {
        float angle = TWO_PI / sides * i;
        float x = cos(angle) * radius;
        float y = sin(angle) * radius;
        vertex(x, y, -cueLength / 2);
        vertex(x, y, cueLength / 2);
      }
      endShape();
  }
  
  void shoot() {
  println("should shoot");
  PVector direction = PVector.sub(whiteBallCoordinates, startPoint);
  direction.normalize();
  float speed = map(abs(dragDistance), 0, 200, 0, 20); // Adjust the mapping as needed
  cueVelocity = PVector.mult(direction, speed);
  println("Cue Velocity: " + cueVelocity);
}
}
