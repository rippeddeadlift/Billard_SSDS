public class Table {
  int t_x, t_y, t_z;

  Table(int t_x, int t_y, int t_z) {
    this.t_x = t_x;
    this.t_y = t_y;
    this.t_z = t_z;
  }

  void draw() {
    background(200);
    lights();
    camera(mouseX, mouseY, (height/2)/tan(PI/6), width/2, height/2, 0, 0, 1, 0);
    
    drawPockets();
    drawBorders();
    drawTableTop();
    drawTableLegs();
  }

  void drawTableTop() {
    pushMatrix();
    translate(width/2, height/2, 0);
    fill(0, 150, 25);
    box(this.t_x, this.t_y, this.t_z);
    popMatrix();
  }

  void drawTableLegs() {
    for (int x = this.t_x/-3; x <= this.t_x/3; x += this.t_x/3) {
      for (int z = -40; z <= 40; z += 80) {
        pushMatrix();
        translate(width/2 + x, height/2 + 55, z);
        fill(100, 50, 0); // Darker brown
        box(50, 100, 40); // width, height, depth
        popMatrix();
      }
    }
  }

  void drawBorders() {
    float borderThickness = 15;
    float borderHeight = 15;

    // Top border
    pushMatrix();
    translate(width/2, height/2 - this.t_y/2 - borderHeight/2, -this.t_z/2);
    fill(100, 50, 0);
    box(this.t_x + borderThickness * 2, borderHeight, borderThickness);
    popMatrix();

    // Bottom border
    pushMatrix();
    translate(width/2, height/2 - this.t_y/2 - borderHeight/2, this.t_z/2);
    fill(100, 0, 0);
    box(this.t_x + borderThickness * 2, borderHeight, borderThickness);
    popMatrix();

    // Left border
    pushMatrix();
    translate(width/2 - this.t_x/2 - borderThickness/2, height/2 - this.t_y/2 - borderHeight/2, 0);
    fill(100, 50, 0);
    box(borderThickness, borderHeight, this.t_z + borderThickness);
    popMatrix();

    // Right border
    pushMatrix();
    translate(width/2 + this.t_x/2 + borderThickness/2, height/2 - this.t_y/2 - borderHeight/2, 0);
    fill(100, 50, 0);
    box(borderThickness, borderHeight, this.t_z + borderThickness);
    popMatrix();
  }

  void drawPockets() {
    fill(0); // Black color for pockets

    // Corner pockets
    drawPocket(width/2 - this.t_x/2 + 15, height/2 - this.t_y/2 + 10, -this.t_z/2 + 15); //LINKS OBEN
    drawPocket(width/2 + this.t_x/2 - 15, height/2 - this.t_y/2 + 10, -this.t_z/2 + 15); // RECHTS OBEN
    drawPocket(width/2 - this.t_x/2 + 15, height/2 - this.t_y/2 + 10, this.t_z/2 - 15); // LINKS UNTEN
    drawPocket(width/2 + this.t_x/2 - 15, height/2 - this.t_y/2 + 10, this.t_z/2 - 15); // RECHTS UNTEN

    // Side pockets
    drawPocket(width/2, height/2 - this.t_y/2, -this.t_z/2);
    drawPocket(width/2, height/2 - this.t_y/2, this.t_z/2);
  }

  void drawPocket(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    sphere(20);
    popMatrix();
  }
}
