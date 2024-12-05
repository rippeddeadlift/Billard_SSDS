
/**
 * Basic version of balls-project 
 * 	(no collision, no textures)
 */
import ddf.minim.*;    // AudioPlayer, Minim

CBalls theBalls;
Table table;
int totalball = 1;               // number of balls 
BilliardCue billiardCue;
PFont helpFont;      
boolean showHelp=false;          // toggle help text
boolean forceFreeze = false;     // toggle game physics 
boolean frictionMode=false;      // may be used in class Ball
boolean randomFloor = true;      // may be used in class Ball

color c_red = color(255,0,0);
float leftwall_x  = 0;
float ceiling_y   = 0;
float rightwall_x;
float floor_y;
float mid_x;

Minim minim; 

void setup() 
{
  size(700, 700, P3D);           // although the game physics is 2D, we do the drawing in 3D to allow 
                                 // for 3D-balls (spheres) with directional light and shininess
  theBalls = new CBalls(this,totalball);
  table = new Table();
 billiardCue = new BilliardCue(150, 150, 450, 10); // Example position and color
  helpFont = createFont("Arial", 22, true);
  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;
}

void draw() 
{
  background(80);  // gray background
   billiardCue.drag(); // Allow dragging
  lightSpecular(255,255,255);
  directionalLight(204, 204, 204, 0, +1, -1);
  
  
  translate(0,0,-2);    // optional, just to show the box border
  table.draw();
  billiardCue.display(); // Display the cue
  boxDraw();
  theBalls.draw();
  if (!forceFreeze)  
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

    // ---- activate this code snippet for exercise U5 ------
    /*
    beginShape(LINES);
      vertex(mid_x ,  floor_y);
      vertex(mid_x ,ceiling_y);
    endShape();
    */            
    // ------------------------------------------------------
} // boxDraw()

void stop()
{
  theBalls.stop();
}

void keyPressed()
{
  switch(key)
  {
  case ESC:
    exit();
    break;
  case ' ':
    forceFreeze = !forceFreeze;
    break;
  case 'h':
    showHelp = !showHelp;
    break;
  case 'r':
    randomFloor = !randomFloor; 
    if ( randomFloor) println("State: random floor ON"); 
    if (!randomFloor) println("State: random floor OFF"); 
    break;
  case 'f':
    frictionMode = !frictionMode;
    if ( frictionMode) println("State: friction Mode ON"); 
    if (!frictionMode) println("State: friction Mode OFF"); 
    break;
  }
}
    
void mousePressed(){
  theBalls.Mouse();
  billiardCue.checkMousePressed(); // Check if the cue is clicked
}

void mouseReleased(){
  theBalls.MouseUp();
}
