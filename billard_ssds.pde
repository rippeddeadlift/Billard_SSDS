CBalls theBalls;
Ball whiteBall;
Table table;
int totalball = 15;           
BillardCue billardCue;
ShootingBar shootingBar;
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
PImage texture;
GameState currentGameState = GameState.BREAKSHOT;

void setup() 
{
  size(600, 960, P3D);   
  noCursor();
  table = new Table(leftwall_x, rightwall_x, floor_y, ceiling_y);  //<>//
  theBalls = new CBalls(totalball,table);
  setupCue();  
  shootingBar = new ShootingBar(width/3.0, height - 30, 150, 200, 20, billardCue);
  theBalls.setCue(billardCue);

  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;
}

void setupCue() {
    this.whiteBall = theBalls.getWhiteBall(); //<>//
    float ballX = (float) whiteBall.sx;  //<>//
    float ballY = (float) whiteBall.sy;
    texture = loadImage("billard_textures/cue.jpg");
    float cueLength = 500;   
    float cueOffset = 50;  
    float cueThickness = 10;
    float cueStartX = ballX - cueThickness / 2; 
    float cueStartY = ballY ; 
    billardCue = new BillardCue(cueStartX, cueStartY, cueThickness, cueLength, cueOffset,texture);
}

void updateCue() {
    this.whiteBall = theBalls.getWhiteBall();
    float ballX = (float) whiteBall.sx; 
    float ballY = (float) whiteBall.sy; 
    float cueOffset = billardCue.cueOffset; 
    
    if (mouseButton != RIGHT){
      float dx = mouseX - ballX;
      float dy = mouseY - ballY;
      billardCue.angle = atan2(dy, dx);  
    }
    
    float angle = billardCue.angle; 
    float cueStartX = ballX + cos(angle) * (cueOffset + billardCue.thickness / 2); 
    float cueStartY = ballY + sin(angle) * (cueOffset + billardCue.thickness / 2); 
    billardCue.x = cueStartX; 
    billardCue.y = cueStartY; 
    if (billardCue.cueAnimating) billardCue.cueAnimationProgress += billardCue.cueSpeed;
}


void draw() {
  camera(camX, camY, camZ, width / 2, height / 2, 0, 0, 1, 0);
  background(color(255, 255, 255));
  lightSpecular(255, 255, 255);
  directionalLight(204, 204, 204, 0, +1, -1);
  translate(0, 0, -2);    
  table.draw();  
  if(theBalls.areAllBallsStationary() && currentGameState != GameState.BREAKSHOT && currentGameState != GameState.FOUL) {
    updateCue(); 
    billardCue.display(); 
    shootingBar.updateStrength(); 
    shootingBar.draw();
  }
  theBalls.draw(currentGameState);
  theBalls.game_physics(currentGameState != GameState.FOUL);
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

void updateGameState(){
  if(theBalls.areAllBallsStationary()){
    this.currentGameState = GameState.READY;
  }else{
    this.currentGameState = GameState.WAITING;
  }
}
    
void keyReleased(){
  theBalls.keyReleased();
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
  if(mouseButton == LEFT && (currentGameState == GameState.BREAKSHOT || currentGameState == GameState.FOUL) && theBalls.areAllBallsStationary()){
    currentGameState = GameState.READY;
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
