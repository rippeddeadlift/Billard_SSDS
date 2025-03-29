
class UserInterface {
  ControlP5 cp5;
  PeasyCam pc;
  MyCanvas cc;
  GameState currentGameState;
  boolean gameStarted = false;
  int ballCount;
  PFont font = createFont("Calibri",16);

  UserInterface(PApplet app, GameController gc, GameState gameState, int ballCount) {
    currentGameState = gameState;
    this.ballCount = ballCount;
    cp5 = new ControlP5(app); //<>//
    cp5.setFont(font);
    cc = new MyCanvas(gc);
    cc.post();
    cp5.addCanvas(cc);
    addMainMenu();
    addMenuButton();
    addSettings();
    cp5.setAutoDraw(false);
    pc = new PeasyCam(app, 0);
  }
  
  void addMenuButton(){
    cp5.addButton("mainMenu")
    .setLabel("Menu")
    .setPosition(0, 40)
    .setVisible(false)
    .onClick(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           setCurrentGameState(GameState.MENU);
         }
       });
  }

  void addSettings() {
    
    cp5.addButton("resetCamera")
    .setLabel("Kamera zuruecksetzen")
    .setPosition(0, height-25)
    .setSize(250,20)
    .setVisible(false)
    .onClick(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           resetCamera();
         }
       });

    cp5.addSlider("FRICTION")
       .setPosition(width/2-100, height/2-55)
       .setSize(200, 50)
       .setRange(0.9, 0.999)
       .setValue(0.98)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent ev) {
           float newValue = ev.getController().getValue();
           theBalls.updateFriction(newValue);
         }
       });

    cp5.addSlider("BALLRADIUS")
       .setPosition(width/2-100, height/2)
       .setSize(200, 50)
       .setRange(10, 25)
       .setValue(0.4f * 35)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent ev) {
           float newValue = ev.getController().getValue();
           theBalls.updateRadius(newValue);
         }
       });

    cp5.addSlider("BALLMASS")
       .setPosition(width/2-100, height/2+55)
       .setSize(200, 50)
       .setRange(0.5, 5)
       .setValue(1)
       .onChange(new CallbackListener() {
         public void controlEvent(CallbackEvent ev) {
           float newValue = ev.getController().getValue();
           theBalls.updateMass(newValue);
         }
       });
  }

  void addMainMenu() {
    cp5.addButton("startButton")
       .setLabel("Start")
       .setPosition(width/2-100, height/3)
       .setSize(200, 50)
       .onClick(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           gameStarted = true;
           theBalls.initializeBalls(ballCount);
           startGame();
         }
       });
       cp5.addButton("resumeButton")
       .setLabel("Fortsetzen")
       .setPosition(width/2-100, height/3)
       .setSize(200, 50)
       .onClick(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           setCurrentGameState(GameState.READY);
         }
       });
       

    cp5.addButton("exitButton")
       .setLabel("Beenden")
       .setPosition(width/2-100, height/1.5)
       .setSize(200, 50)
       .onClick(new CallbackListener() {
         public void controlEvent(CallbackEvent event) {
           exit();
         }
       });
  }

  void showMainMenu() {
    
    cp5.getController("mainMenu").hide();
    cp5.getController("resetCamera").hide();
    if(gameStarted){
      cp5.getController("startButton").hide();
      cp5.getController("resumeButton").show();
    }else{
      cp5.getController("startButton").show();
      cp5.getController("resumeButton").hide();
    }
    cp5.getController("exitButton").show();
    cp5.getController("BALLMASS").show();
    cp5.getController("BALLRADIUS").show();
    cp5.getController("FRICTION").show();
    cc.setVisibility(false);
  }

  void hideMainMenu() {
    cp5.getController("startButton").hide();
    cp5.getController("resumeButton").hide();
    cp5.getController("exitButton").hide();
    cp5.getController("BALLMASS").hide();
    cp5.getController("BALLRADIUS").hide();
    cp5.getController("FRICTION").hide();
    cp5.getController("mainMenu").show();
    cp5.getController("resetCamera").show();
    cc.setVisibility(true);
  }

  boolean isMouseOver() {
    return cp5.isMouseOver();
  }

  void draw(GameState currentGameState) {
    pc.beginHUD();
    cp5.draw();

    if (currentGameState == GameState.MENU) {
      showMainMenu();
    } else {
      hideMainMenu();
     
    shootingBar.draw();
    }
 pc.endHUD();
  }
}

class MyCanvas extends Canvas {
  GameController gc;
  boolean visible = false;
  PFont font = createFont("Calibri",24);
  MyCanvas(GameController gc){
    this.gc = gc;
  }
  
  public void setVisibility(boolean visibility){
    this.visible = visibility;
  }

  public void draw(PGraphics pg) {
    if(visible){
      color bgColor = get(0, 0);
      pg.fill(255);
      if(bgColor == -1){
         pg.fill(0,0,0);
      }
      pg.textFont(font);
      pg.textAlign(TOP,TOP);
    Player currentPlayer = gc.getCurrentPlayer();
    if(currentPlayer.ballType == BallType.NONE){
      pg.text(currentPlayer.name + "(BREAKSHOT)", 0,10);
    }else{
      pg.text(currentPlayer.name + "(" + currentPlayer.ballType + ")", 0,10);
      pg.fill(255);
      drawPocketedBallsForPlayer(currentPlayer);
    }
    }
  }
  
  private void drawPocketedBallsForPlayer(Player currentPlayer){
    var scoredBalls = currentPlayer.getScoredBalls();
    var initialCircleXPosition = 250;
    if(scoredBalls.size() > 0){ 
      for(Ball b : scoredBalls){
        imageMode(CENTER);
        image(b.getIcon(), initialCircleXPosition += 30, 25, 30, 30);
      }
    }
  }
}
