
class UserInterface{
  ControlP5 cp5;
  PeasyCam pc;
  MyCanvas cc;
  UserInterface(PApplet app, GameController gc){
    cp5 = new ControlP5(app);
    cc = new MyCanvas(gc);
    cc.post();
    cp5.addCanvas(cc);
    addSettings();
    cp5.setAutoDraw(false);
    pc = new PeasyCam(app, 0);
  } //<>//
  
  void addSettings(){
  Group g1 = cp5.addGroup("EINSTELLUNGEN")
                .setPosition(0,40)
                .setWidth(200)
                .setBackgroundHeight(140)
                .setOpen(false)
                .setBackgroundColor(color(255,50));
                     
  cp5.addSlider("FRICTION")
     .setPosition(10,20)
     .setSize(80,20)
     .setRange(0.9,0.999)
     .setValue(0.98)
     .setGroup(g1)
     .onChange(new CallbackListener(){
       public void controlEvent(CallbackEvent ev) {
         float newValue = ev.getController().getValue();
         theBalls.updateFriction(newValue);}
     });
          
  cp5.addSlider("BALLRADIUS")
     .setPosition(10,60)
     .setSize(80,20)
     .setRange(0.5,50)
     .setValue(0.4f * 35)
     .setGroup(g1)
     .onChange(new CallbackListener(){
       public void controlEvent(CallbackEvent ev) {
         float newValue = ev.getController().getValue();
         theBalls.updateRadius(newValue);}
     });
     
  cp5.addSlider("BALLMASS")
     .setPosition(10,100)
     .setSize(80,20)
     .setRange(0.5,5)
     .setValue(1)
     .setGroup(g1)
     .onChange(new CallbackListener(){
       public void controlEvent(CallbackEvent ev) {
         float newValue = ev.getController().getValue();
         theBalls.updateMass(newValue);}
     });
     
  }
  
  boolean isMouseOver(){
    return cp5.isMouseOver();
  }
 
 void draw(){
   pc.beginHUD();
   cp5.draw();
   shootingBar.draw();
   pc.endHUD();
 }
}

class MyCanvas extends Canvas {
  GameController gc;
  MyCanvas(GameController gc){
    this.gc = gc;
  }

  public void draw(PGraphics pg) {
    color bgColor = get(0, 0);
      pg.fill(255);
      if(bgColor == -1){
         pg.fill(0,0,0);
      }
      pg.textFont(createFont("Arial",24));
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
