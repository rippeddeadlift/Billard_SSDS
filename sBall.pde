public class Ball {
  double DT = 0.06; // time increment
  double MASS = 1.0;
  double FRICTION = 0.985; // friction coefficient
  double ROT_FRICTION = 0.8; // rotational friction coefficient
  double times; // time since start
  double sx,sy,sz; //position
  double vx, vy; // actual velocity 
  double ax, ay; // acceleration
  double radius;
  BallType ballType;
  double angleX = 0; // current rotation angle around x-axis
  double angleY = 0; // current rotation angle around y-axis
  double angularVelocityX = 0; // current angular velocity around x-axis
  double angularVelocityY = 0; // current angular velocity around y-axis
  int bn; // ball number
  PShape our_sphere;
  PImage ballIcon;
  boolean isWhiteBall,isBlackBall = false;
  boolean visible = true;
  boolean pocketed = false; 
  double scale = 1;
  boolean isFadingOut = false;
  int ballId;
  PImage texture;
  PVector pocketedCoordinates;

  boolean mousedown = false;

  Ball(int count, PImage texture, int ballId, PVector position, double radius) {
    this.bn = count;   
    this.texture = texture;
    switch (ballId) {
            case 8: 
                this.ballType = BallType.BLACK;
                break;
            case 1: case 2: case 3: case 4: case 5: case 6: case 7:  
                this.ballType = BallType.SOLID;
                break;
            case 9: case 10: case 11: case 12: case 13: case 14: case 15:
                this.ballType = BallType.STRIPE;
                break;
            default:
                  this.ballType = BallType.WHITE;
                break;	
        }
    if(bn == 10){
      this.isBlackBall = true;
    }
    this.sx = position.x;
    this.sy = position.y;
    this.ballId = ballId;
    this.radius = radius;
    this.ballIcon = loadImage("billard_icons/" + ballId + ".png");
    our_sphere = createShape(SPHERE, this.Radius());
    our_sphere.setStroke(false);
    our_sphere.setTexture(this.texture);
  }

  Ball(double radius) {
    this.sx = width/2;
    this.sy = 800;
    this.vx = 0;
    this.vy = 0;
    this.radius = radius;
    this.isWhiteBall = true;
    our_sphere = createShape(SPHERE, this.Radius());
    our_sphere.setStroke(false);
    our_sphere.setFill(color(255, 255, 255));
  }
  
void draw() {
        if (visible && currentGameState != GameState.FINISHED) {
            pushMatrix();
            translate(Sx(), Sy(), Sz());
            rotateX((float) angleX);
            rotateY((float) angleY);
            animateRemoval();
            shape(our_sphere);
            popMatrix();
        }
    }


  void game_physics() {
    double dx, dy;
    this.times += DT;

    accumulateForces();

    dx = this.vx * DT;
    dy = this.vy * DT;
    this.vx += this.ax * DT;
    this.vy += this.ay * DT;

    applyBoundaryReflections(dx, dy);

    // Apply friction
    this.vx *= FRICTION;
    this.vy *= FRICTION;

    // Update rotation
    this.angleX -= (this.vy / this.radius) * DT;
    this.angleY += (this.vx / this.radius) * DT;

    if (cos((float) this.angleX) < 0) {  
        this.angleY -= (this.vx / this.radius) * DT * 2;  
    }
    
    this.angularVelocityX *= ROT_FRICTION;
    this.angularVelocityY *= ROT_FRICTION;
  }

  void accumulateForces() {
    double Fx = 0;
    double Fy = 0;

    this.ax = Fx / MASS;
    this.ay = Fy / MASS;
  }
  boolean isPocketed() {
          return pocketed;
      }
  void applyBoundaryReflections(double dx, double dy) {
    float refl = 0.9; // percent of reflected velocity (normal to the wall)

    // Reflections at floor, ceiling, left and right wall:
    if ((this.sy + dy > floor_y - this.radius)) {
      dy = floor_y - this.radius - this.sy;
      this.vy = -refl * this.vy;
    } else if (this.sy + dy < ceiling_y + this.radius) {
      dy = ceiling_y + this.radius - this.sy;
      this.vy = -refl * this.vy;
    }

    if (this.sx + dx > rightwall_x - this.radius) {
      dx = rightwall_x - this.radius - this.sx;
      this.vx = -refl * this.vx;
    } else if (this.sx + dx < leftwall_x + this.radius) {
      dx = leftwall_x + this.radius - this.sx;
      this.vx = -refl * this.vx;
    }

    this.sx += dx;
    this.sy += dy;
      if(pocketed){
        confineToPocket();
      }
       confineToBox();
      
}
  
  void animateRemoval(){
    //scale it down slowly, make it only move around in constraints of pocket
    if (this.pocketed){
       this.sx += (pocketedCoordinates.x - this.sx - this.radius) * 0.15;
       this.sy += (pocketedCoordinates.y - this.sy + this.radius) * 0.15;
       if(this.sz >= -45) this.sz -= 0.5;
       if( scale > 0.5){
         scale *= 0.95;
         our_sphere.scale(0.95);   
       }  
    }
  }
  void confineToBox() {
    if (this.sx < leftwall_x + this.radius) this.sx = leftwall_x + this.radius;
    if (this.sy < ceiling_y + this.radius) this.sy = ceiling_y + this.radius;
    if (this.sx > rightwall_x - this.radius) this.sx = rightwall_x - this.radius;
    if (this.sy > floor_y - this.radius) this.sy = floor_y - this.radius;
  }
  void confineToPocket() {
    if (this.sx < pocketedCoordinates.x + 40) this.vx *= 0.7; this.vy *= 0.7;
    if (this.sy < pocketedCoordinates.y + 40) this.vx *= 0.7; this.vy *= 0.7;
    if (this.sx > pocketedCoordinates.x - 40) this.vx *= 0.7; this.vy *= 0.7;
    if (this.sy > pocketedCoordinates.y - 40) this.vx *= 0.7; this.vy *= 0.7;
  }

  void Mouse() { //<>//
    if (mouseButton == LEFT) {
      mousedown = true;
    }
  }

  void MouseUp() {
    mousedown = false;
  }
  
  void setVisibility(boolean v){
    this.visible = v;
  }
  
  PImage getIcon(){
    return this.ballIcon;
  }
  
  public void setRadius(float newValue){
    this.radius = newValue;
    our_sphere = createShape(SPHERE, this.Radius());
    our_sphere.setStroke(false);
    our_sphere.setTexture(this.texture);
  }
  
  public void setFriction(float newValue){
    this.FRICTION = newValue;
  }
  public void setMass(float newValue){
    this.MASS = newValue;
  }
  

  float Radius() {
    return (float) radius;
  }

  float Sx() {
    return (float) this.sx;
  }

  float Sy() {
    return (float) this.sy;
  }
  
  float Sz() {
    return (float) sz;
  }
}
