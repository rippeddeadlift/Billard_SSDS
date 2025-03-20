import peasy.*;
import controlP5.*;

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
GameState currentGameState = GameState.MENU;
Player player1;
Player player2;
Player currentPlayer;
GameController gameController;
VectorDrawer vd;
UserInterface userInterface;

void setup() 
{
  size(600, 960, P3D);  
  initializePlayers();
  initializeTable();
  initializeGameComponents();
  userInterface = new UserInterface(this, gameController, currentGameState, totalball);
  initializeUI();
}

void draw() { //<>//
  if(currentGameState != GameState.MENU){ //<>//
    updateCamera();
    renderScene();
    updateGameLogic();
  }
  userInterface.draw(currentGameState);
}

void updateCamera() {
  camera(camX, camY, camZ, width/2, height/2, 0, 0, 1, 0);
  background(255);
  lightSpecular(255, 255, 255);
  directionalLight(204, 204, 204, 0, 1, -1);
  translate(0, 0, -2);
}

void resetCamera(){
  this.camX = 295;
  this.camY = 480;
  this.camZ = 900;
}

void renderScene() {
  table.draw();
  theBalls.draw(currentGameState);
}

void updateGameLogic() {
  if (currentGameState == GameState.FINISHED) {
    currentPlayer.draw();
    return;
  }

  if (theBalls.areAllBallsStationary() && currentGameState != GameState.BREAKSHOT && currentGameState != GameState.FOUL) {
    billardCue.display();
    vd.draw(theBalls, theBalls.getWhiteBall(), billardCue);
  }

  theBalls.game_physics(currentGameState != GameState.FOUL);
}


void initializePlayers() {
  player1 = new Player("PLAYER 1");
  player2 = new Player("PLAYER 2");
}

void initializeTable() {
  table = new Table(leftwall_x, rightwall_x, floor_y, ceiling_y);
}

void initializeGameComponents() {
  gameController = new GameController(player1, player2);
  theBalls = new CBalls(table, gameController);
  gameController.setBalls(theBalls);
  setupCue();
  theBalls.setCue(billardCue);
}

void initializeUI() {
  shootingBar = new ShootingBar(width / 3.0, height - 30, 150, 200, 20, billardCue);
}

void startGame() {
  currentGameState = GameState.BREAKSHOT;
  rightwall_x = width;
  floor_y = height;
  mid_x = width / 2.0;
  currentPlayer = player1;
  currentPlayer.startTurn();
  vd = new VectorDrawer();
}
void setupCue() {
    billardCue = new BillardCue(theBalls.getWhiteBall());
}

void updateGameState(){
  if(theBalls.areAllBallsStationary()){
    this.currentGameState = GameState.READY;
  }else{
    this.currentGameState = GameState.WAITING;
  }
}

void setCurrentGameState(GameState gameState){
  this.currentGameState = gameState;
}

void mousePressed() {
  if(!userInterface.isMouseOver()){
    if(mouseButton == LEFT){
    theBalls.mousePressed();
  }
    if (mouseButton == RIGHT) {
      prevMouseX = mouseX;
      prevMouseY = mouseY;
      dragging = true;
    } 
  }
}

void mouseReleased() {
  if(!userInterface.isMouseOver()){
    if (mouseButton == RIGHT) {
    dragging = false;
  }
    if(mouseButton == LEFT && (currentGameState == GameState.BREAKSHOT || currentGameState == GameState.FOUL) && theBalls.areAllBallsStationary()){
      currentGameState = GameState.READY;
    }
    if (mouseButton == LEFT){
      theBalls.mouseReleased();
    }
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
