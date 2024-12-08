/**
 * Class for a single ball, contains game physics, boundary reflections
 * and audio effects:
 *    (i)   a 'kick' sound when hitting the floor
 *    (ii)  a 'snare' sound when hitting one of the other three walls
 */
public class Ball 
{
  double DT = 0.06;	// time increment
  double MASS = 1.0;
  double g_acc = +9.8;	// gravity constant

  double times;		// time since start
  double sx, sy;		// actual position 
  double vx, vy;		// actual velocity 
  double ax, ay;		// acceleration, currently constant = (0,+9.8)
  double radius;
  int bn;                 // ball number
  AudioPlayer kick;       // one audio-object for each ball --> ensure a multi-kick when 
  AudioPlayer snare;      // two or more balls hit the floor nearly at the same time 
  // (otherwise the first playing audio snippet would hinder the
  // 2nd or 3rd snippet to be played)

  boolean mousedown   = false;

  Ball (Minim minim, int count) {
    radius=0.4f*60;
    this.bn=count;
    // we initialize with increasingly more negative 'times' 
    // >> the balls pop up one after another:
    this.times=-10*DT*count;
    this.vy=random(50);  
    this.sy=+50;      
    this.vx=random(50);  
    this.sx=100;      

    this.kick = minim.loadFile("kick.wav");
    this.snare = minim.loadFile("hat.wav");
  }

  void draw() 
  {
    if (times>=0) {
      pushMatrix();
      fill(c_red);
      noStroke();
      specular(c_red);
      shininess(5.0);

      translate(Sx(), Sy(), 0 );
      sphere(this.Radius());
      popMatrix();
    }

    audioRewind();
  } 

  void game_physics()
  {
    double dx, dy;
    this.times+=DT;

    accumulateForces();              

    dx = this.vx * DT;
    dy = this.vy * DT; 
    this.vx += this.ax * DT;
    this.vy += this.ay * DT;

    applyBoundaryReflections(dx, dy); // modifies this.sx, .sy, .vx, .vy

    /*
     println("sx,sy = "+ this.sx+", "+this.sy);                  
     println("ax,ay = "+ this.ax+", "+this.ay);                  
     println("vx,vy = "+ this.vx+", "+this.vy);                  
     println("dx,dy = "+ dx+", "+dy);                  
     */
  }

  void accumulateForces() {
    double Fx = 0;
    double Fy = MASS*g_acc;

    this.ax = Fx/MASS;
    this.ay = Fy/MASS;
  }

  /*
   * applyBoundaryReflections: check whether the suggested space step (dx,dy)  
   * for this ball would bring it outside the confining box. If so, then
   * change (dx,dy) to go not further than the box wall AND reflect the 
   * velocity (vx,vy) of the ball. For ceiling, left and rigth wall the 
   * reflection is deterministic. The reflection normal to the wall is 
   * dampened with factor refl. For the floor the reflection has a  
   * random component to bring new 'energy' into the game.
   * 
   * Returns a modified this.sx, .sy, .vx, .vy.
   */
  void applyBoundaryReflections(double dx, double dy)
  {      
    float refl=0.9;		// percent of reflected velocity (normal to the wall)

    // Reflections at floor, ceiling, left and right wall:
    if ((this.sy + dy > floor_y - this.radius)) {			
      dy = floor_y - this.radius - this.sy;

      // the random-floor action:
      this.vy = -random(150)-50;
      this.vx += random(150)-75;
      //
      // TODO: distinguish, depending on variable randomFloor,
      // whether to do random-floor reflection or deterministic reflection
      //

      this.kick.play();
      //println("floor");
    } else if (this.sy + dy < ceiling_y + this.radius) {  
      dy = ceiling_y + this.radius - this.sy;
      this.vy = - refl*this.vy;
      this.snare.play();
      //println("ceiling");
    }

    if (this.sx + dx > rightwall_x - this.radius) {		
      dx = rightwall_x - this.radius - this.sx;
      this.vx = - refl*this.vx;
      this.snare.play();
      //println("right");
    } else if (this.sx + dx < leftwall_x + this.radius) {		
      dx = leftwall_x + this.radius - this.sx;
      this.vx = - refl*this.vx;
      this.snare.play();
      //println("left");
    }

    this.sx += dx;
    this.sy += dy;

    confineToBox();
  }

  /* 
   * ensure that sphere does not move out of confining box
   */
  void confineToBox() 
  {
    if (this.sx < leftwall_x+150  + this.radius)  this.sx = leftwall_x+150  + this.radius;
    if (this.sy < ceiling_y-100   + this.radius)  this.sy = ceiling_y-100   + this.radius;
    if (this.sx > rightwall_x-150 - this.radius)  this.sx = rightwall_x-150 - this.radius;
    if (this.sy > floor_y-600    - this.radius)  this.sy =floor_y-600    - this.radius;
  }

  /* 
   * ensure that audio snippets are again at starting positions after they have been played
   */
  void audioRewind() {
    if (!kick.isPlaying()) {
      kick.rewind();
      kick.pause();
    }
    if (!snare.isPlaying()) {
      snare.rewind();
      snare.pause();
    }
  } 

  /* Clicked mouse */
  void Mouse ()
  {
    if (mouseButton == LEFT)           // if user clicked
    {
      mousedown = true;
    }
  }

  /* Released mouse */
  void MouseUp ()
  {
    mousedown = false;
  }

  float Radius() { 
    return (float)radius;
  }
  float Sx() { 
    return (float)sx;
  }
  float Sy() { 
    return (float)sy;
  }
}
