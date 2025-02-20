CBalls theBalls;
Ball whiteBall;
Table table;
int totalball = 15;           
BilliardCue billiardCue;

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
  billiardCue = new BilliardCue(520, 866, 15, 500); 

  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;
}

void draw() {
  camera(camX, camY, camZ, width / 2, height / 2, 0, 0, 1, 0);
  background(color(255, 255, 255));
  billiardCue.drag(); 
  lightSpecular(255, 255, 255);
  directionalLight(204, 204, 204, 0, +1, -1);
  translate(0, 0, -2);    
  table.draw();
  billiardCue.display(); 

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
  
}
    
void mousePressed() {
  if (mouseButton == RIGHT) {
    prevMouseX = mouseX;
    prevMouseY = mouseY;
    dragging = true;
  }  
if (billiardCue.isMouseOverCue()) {
        billiardCue.isDragging = true; // Start dragging
        billiardCue.cueOffset = new PVector(mouseX - billiardCue.x, mouseY - billiardCue.y); // Calculate the offset from the mouse to the cue's top-left corner
    }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    dragging = false;
  }
   billiardCue.isDragging = false; 
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
  if (billiardCue.isDragging) {
        billiardCue.x = mouseX - billiardCue.cueOffset.x; 
        billiardCue.y = mouseY - billiardCue.cueOffset.y; 
    }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  camZ += e * 10;
}
