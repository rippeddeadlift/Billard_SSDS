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
Player player1;
Player player2;
Player currentPlayer;
GameController gameController;
VectorDrawer vd;

void setup() 
{
  size(600, 960, P3D);   
  noCursor();
  
  player1 = new Player("Player 1");
  player2 = new Player("Player 2");
  
  table = new Table(leftwall_x, rightwall_x, floor_y, ceiling_y); 
  
  gameController = new GameController(player1, player2);
  theBalls = new CBalls(totalball, table, gameController);
  gameController.setBalls(theBalls);
  setupCue();  
  shootingBar = new ShootingBar(width/3.0, height - 30, 150, 200, 20, billardCue);
  theBalls.setCue(billardCue); 
  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;
  currentPlayer = player1;
  currentPlayer.startTurn();
  vd = new VectorDrawer();
}
void draw() {
  camera(camX, camY, camZ, width / 2, height / 2, 0, 0, 1, 0);
  background(color(255, 255, 255));
  lightSpecular(255, 255, 255);
  directionalLight(204, 204, 204, 0, +1, -1);
  translate(0, 0, -2);    
  table.draw();  
  if (currentGameState == GameState.FINISHED){
    currentPlayer.draw();
  }else{
  if(theBalls.areAllBallsStationary() && currentGameState != GameState.BREAKSHOT && currentGameState != GameState.FOUL) {
    updateCue(); 
    billardCue.display(); 
    vd.draw(theBalls, theBalls.getWhiteBall(), billardCue);
    shootingBar.updateStrength(); 
    shootingBar.draw();
  }
  theBalls.draw(currentGameState);
  theBalls.game_physics(currentGameState != GameState.FOUL);
  // Display Player Info
  fill(0);
  textSize(20);
  text(player1.getStatus(), 20, 30);
  text(player2.getStatus(), 20, 60);
  }

  
}
void setupCue() {
    billardCue = new BillardCue(theBalls.getWhiteBall());
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
    float cueStartX = ballX + cos(angle) * (cueOffset + billardCue.cueThickness / 2); 
    float cueStartY = ballY + sin(angle) * (cueOffset + billardCue.cueThickness / 2); 
    billardCue.cuePosition.x = cueStartX; 
    billardCue.cuePosition.y = cueStartY; 
    if (billardCue.cueAnimating) billardCue.cueAnimationProgress += billardCue.cueSpeed;
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
