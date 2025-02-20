CBalls theBalls;
Ball whiteBall;
Table table;
int totalball = 16;           
BillardCue billardCue;

color c_red = color(255,0,0);
float leftwall_x  = 0;
float ceiling_y   = 0;
float rightwall_x;
float floor_y;
float mid_x;
float camX = 294;
float camY = 481;
float camZ = 900;
float prevMouseX, prevMouseY;
boolean dragging = false;

void setup() 
{
  size(600, 960, P3D);      
  theBalls = new CBalls(totalball);
  table = new Table(leftwall_x, rightwall_x, floor_y, ceiling_y);  
  setupCue();
  theBalls.setCue(billardCue);

  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;
}

void setupCue() {
    whiteBall = theBalls.ballContainer.get(15);
    float ballX = (float) whiteBall.sx;
    float ballY = (float) whiteBall.sy;

    float cueLength = 500;  
    float cueOffset = 300;  
    float cueThickness = 10;
    float cueStartX = ballX - cueThickness / 2; // Center the cue under the ball
    float cueStartY = ballY + cueOffset; // Start the cue offset from the ball
    billardCue = new BillardCue(cueStartX, cueStartY, cueThickness, cueLength, cueOffset);
}

void updateCue() {
    float ballX = (float) whiteBall.sx; 
    float ballY = (float) whiteBall.sy; 
    float cueLength = billardCue.length; 
    float cueOffset = billardCue.cueOffset; 

    // Update the cue's angle based on your input; it might be an adjustment variable
    // Ensure angle is in radians
    float angle = billardCue.angle; 

    // Calculate the tip position based on the angle and length of the cue
    float cueTipX = ballX + cos(angle) * cueLength; 
    float cueTipY = ballY + sin(angle) * cueLength; 

    // Update cue's starting position
    billardCue.x = ballX - billardCue.thickness / 2; // Keep cue centered under the ball
    billardCue.y = ballY + cueOffset; // Adjust the Y position if needed

    println("Cue Tip Position: (" + cueTipX + ", " + cueTipY + ")");
}







void draw() {
  camera(camX, camY, camZ, width / 2, height / 2, 0, 0, 1, 0);
  background(color(255, 255, 255));
  billardCue.drag(); 
  lightSpecular(255, 255, 255);
  directionalLight(204, 204, 204, 0, +1, -1);
  translate(0, 0, -2);    
  table.draw();
  updateCue();
  billardCue.display(); 

  boxDraw();
  theBalls.draw();
  theBalls.game_physics();
}


// draw the sphere-confing box
void boxDraw() {
    stroke(c_red);
    noFill();
    beginShape(QUADS);
           vertex(leftwall_x ,  floor_y);
           vertex(leftwall_x ,ceiling_y);
           vertex(rightwall_x,ceiling_y);
           vertex(rightwall_x,  floor_y);
    endShape();
}

void keyPressed()
{
  theBalls.keyPressed();
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    prevMouseX = mouseX;
    prevMouseY = mouseY;
    dragging = true;
  }  
  

}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    dragging = false;
  }
   billardCue.isDragging = false; 
}

void mouseDragged() {
  if (dragging) {
    float dx = mouseX - prevMouseX;
    float dy = mouseY - prevMouseY;
    
    camX -= dx;
    camY -= dy;
    
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }

}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  camZ += e * 10;
}
