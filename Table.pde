public class Table {

  float leftwall_x, rightwall_x, floor_y, ceiling_y;
  PShape shape;
  PImage texture = loadImage("billard_textures/holz.jpg");
  PVector topLeftCorner,topRightCorner,bottomLeftCorner,bottomRightCorner;

  Table(float leftwall_x, float rightwall_x, float floor_y, float ceiling_y) {
    this.leftwall_x = leftwall_x;
    this.rightwall_x = rightwall_x;
    this.floor_y = floor_y;
    this.ceiling_y = ceiling_y;
    topLeftCorner = new PVector(leftwall_x, ceiling_y);
    topRightCorner = new PVector(width, ceiling_y);
    bottomLeftCorner = new PVector(leftwall_x, height);
    bottomRightCorner = new PVector(width,height);
  }

  void draw() {
    //lights();
    drawTableTop();
    drawTableLegs();
    drawBorders();
  }

  void drawTableTop() {
    pushMatrix();
    translate((topLeftCorner.x + topRightCorner.x) / 2, (topLeftCorner.y + bottomLeftCorner.y) / 2, -25);
    fill(color(0,128,0)); 
    noStroke();
    float[] surfaceSize = {width - leftwall_x, height - ceiling_y, 0};
    PShape surface = createShape(BOX, surfaceSize);
    shape(surface);
    popMatrix();
  }

  void drawTableLegs() {
    ArrayList<PVector> positions = new ArrayList();
    positions.addAll(List.of(topLeftCorner,topRightCorner,bottomLeftCorner,bottomRightCorner));
  
    for (PVector position : positions) {
      pushMatrix();
      translate(position.x, position.y, -height/4 + 25); // 25 = width von den holzteilen
      fill(150, 50, 0);
      float[] p_yx = {(float)50, (float)50, (float)height / 2};
      PShape shape = createShape(BOX, p_yx);
      shape.setTexture(texture);
      shape(shape);
      popMatrix();
    }
  }

  void drawBorders() {
    pushMatrix();
    translate(width/2, ceiling_y);
    rotateX(PI/2);
    fill(150, 50, 0);
    noStroke();
    float[] p_y = {(float)width, (float)50, (float)50};
    var shape = createShape(BOX, p_y);
    shape.setTexture(texture);
    shape(shape);
    popMatrix();

    // Bottom border
    pushMatrix();
    translate(width/2, height);
    rotateX(PI/2);
    fill(150, 50, 0);
    noStroke();
    shape = createShape(BOX, p_y);
    shape.setTexture(texture);
    shape(shape);
    popMatrix();

    // Left border
    pushMatrix();
    translate(leftwall_x, height/2);
    rotateX(PI/2);
    fill(150, 50, 0);
    noStroke();
    float[] p_x = {(float)50, (float)50, (float)height};
    shape = createShape(BOX, p_x);
    shape.setTexture(texture);
    shape(shape);
    popMatrix();

    // Right border
    pushMatrix();
    translate(width, height/2);
    rotateX(PI/2);
    fill(150, 50, 0);
    noStroke();
    shape = createShape(BOX, p_x);
    shape.setTexture(texture);
    shape(shape);
    popMatrix();
  }
}
