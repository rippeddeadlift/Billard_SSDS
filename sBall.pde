import ddf.minim.*;

public class Ball {
  double DT = 0.06; // time increment
  double MASS = 1.0;
  double FRICTION = 0.99; // friction coefficient
  double ROT_FRICTION = 0.98; // rotational friction coefficient

  double times; // time since start
  double sx, sy; // actual position 
  double vx, vy; // actual velocity 
  double ax, ay; // acceleration
  double radius;
  double angleX = 0; // current rotation angle around x-axis
  double angleY = 0; // current rotation angle around y-axis
  double angularVelocityX = 0; // current angular velocity around x-axis
  double angularVelocityY = 0; // current angular velocity around y-axis
  int bn; // ball number
  //TODO: Refactoren sodass es exakt in der mitte des Tisches ist (plazierungslogik ändern damit man von dem ersten ball ausgeht und danach die bälle von "unten" aufbaut)
  // width/2 für den ball in der spitze
  int firstRowXAxis = 200;
  int firstRowYAxis = 200;
  PShape our_sphere;
  PImage texture;

  boolean mousedown = false;

  Ball(int count, PImage texture) {
    radius = 0.4f * 60;
    this.bn = count;
    initializePosition(count);
    our_sphere = createShape(SPHERE, this.Radius());
    our_sphere.setStroke(false);
    our_sphere.setTexture(texture);
  }

  Ball(int count) {
    radius = 0.4f * 60;
        this.bn = count;
    this.vy = 0;
    this.sy = 800;
    this.vx = 0;
    this.sx = width / 2;
    our_sphere = createShape(SPHERE, this.Radius());
    our_sphere.setStroke(false);
    our_sphere.setFill(color(255, 255, 255));
  }

  void initializePosition(int count) {
    if (bn < 5) {
      this.vy = 0;
      this.sy = firstRowYAxis;
      this.vx = 0;
      this.sx = firstRowXAxis + count * this.Radius() * 2;
    } else if (bn < 9) {
      this.vy = 0;
      this.sy = firstRowYAxis + this.Radius() * 2;
      this.vx = 0;
      this.sx = (firstRowXAxis + this.Radius()) + (count - 5) * this.Radius() * 2;
    } else if (bn < 12) {
      this.vy = 0;
      this.sy = firstRowYAxis + this.Radius() * 4;
      this.vx = 0;
      this.sx = (firstRowXAxis + this.Radius() * 2) + (count - 9) * this.Radius() * 2;
    } else if (bn < 14) {
      this.vy = 0;
      this.sy = firstRowYAxis + this.Radius() * 6;
      this.vx = 0;
      this.sx = (firstRowXAxis + this.Radius() * 3) + (count - 12) * this.Radius() * 2;
    } else {
      this.vy = 0;
      this.sy = firstRowYAxis + this.Radius() * 8;
      this.vx = 0;
      this.sx = (firstRowXAxis + this.Radius() * 4) + (count - 14) * this.Radius() * 2;
    }
  }

  void draw() {
    pushMatrix();
    translate(Sx(), Sy(), 0);
    rotateX((float) angleX);
    rotateY((float) angleY);
    shape(our_sphere);
    popMatrix();
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
    this.angleY -= (this.vx / this.radius) * DT;
    this.angularVelocityX *= ROT_FRICTION;
    this.angularVelocityY *= ROT_FRICTION;
  }

  void accumulateForces() {
    double Fx = 0;
    double Fy = 0;

    this.ax = Fx / MASS;
    this.ay = Fy / MASS;
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

    confineToBox();
  }

  void confineToBox() {
    if (this.sx < leftwall_x + this.radius) this.sx = leftwall_x + this.radius;
    if (this.sy < ceiling_y + this.radius) this.sy = ceiling_y + this.radius;
    if (this.sx > rightwall_x - this.radius) this.sx = rightwall_x - this.radius;
    if (this.sy > floor_y - this.radius) this.sy = floor_y - this.radius;
  }

  void Mouse() {
    if (mouseButton == LEFT) {
      mousedown = true;
    }
  }

  void MouseUp() {
    mousedown = false;
  }

  float Radius() {
    return (float) radius;
  }

  float Sx() {
    return (float) sx;
  }

  float Sy() {
    return (float) sy;
  }
}
