public class Table {

  float leftwall_x, rightwall_x, floor_y, ceiling_y;
  PShape shape, poolColor;
  PImage texture = loadImage("billard_textures/holz.jpg");
  PImage greenPoolTexture = loadImage("billard_textures/GreenPool.jpg");

  PVector topLeftCorner,topRightCorner,bottomLeftCorner,bottomRightCorner;
  ArrayList<PVector> pocket_coords = new ArrayList();
  Pockets pockets;
  final int DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX = 25;

  Table(float leftwall_x, float rightwall_x, float floor_y, float ceiling_y) {
    this.leftwall_x = leftwall_x;
    this.rightwall_x = rightwall_x;
    this.floor_y = floor_y;
    this.ceiling_y = ceiling_y;
    topLeftCorner = new PVector(leftwall_x - DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX, ceiling_y - DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
    topRightCorner = new PVector(width+ DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX, ceiling_y - DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
    bottomLeftCorner = new PVector(leftwall_x - DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX , height + DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
    bottomRightCorner = new PVector(width + DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX ,height + DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
    pocket_coords.addAll(List.of(topLeftCorner,topRightCorner,bottomLeftCorner,bottomRightCorner));
    pockets = new Pockets(pocket_coords);
  }

  void draw() {
    drawTableTop();
    drawTableLegs();
    drawBorders();
    pockets.draw();
  }

void drawTableTop() {
  pushMatrix();
  translate((topLeftCorner.x + topRightCorner.x) / 2, (topLeftCorner.y + bottomLeftCorner.y) / 2, -DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
  noStroke();
  fill(255,255,0);
  float[] surfaceSize = {width - leftwall_x, height - ceiling_y, 0};
  PShape surface = createShape(BOX, surfaceSize);
  
  surface.setTexture(greenPoolTexture);
  shape(surface);

  
  popMatrix();
}


  void drawTableLegs() {
    ArrayList<PVector> positions = new ArrayList();
    positions.addAll(List.of(topLeftCorner,topRightCorner,bottomLeftCorner,bottomRightCorner));
  
    for (PVector position : positions) {
      pushMatrix();
      translate(position.x, position.y, -height/4 + DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
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
    translate(width/2, ceiling_y - DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
    rotateX(PI/2);
    fill(150, 50, 0);
    noStroke();
    float[] p_y = {(float)width, (float)50, (float)50};
    shape = createShape(BOX, p_y);
    shape.setTexture(texture);
    shape(shape);
    popMatrix();

    // Bottom border
    pushMatrix();
    translate(width/2, height + DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX);
    rotateX(PI/2);
    fill(150, 50, 0);
    noStroke();
    shape = createShape(BOX, p_y);
    shape.setTexture(texture);
    shape(shape);
    popMatrix();

    // Left border
    pushMatrix();
    translate(leftwall_x - DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX, height/2);
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
    translate(width + DISTANCE_OF_OBJECTS_TO_BOUNDINGBOX, height/2);
    rotateX(PI/2);
    fill(150, 50, 0);
    noStroke();
    shape = createShape(BOX, p_x);
    shape.setTexture(texture);
    shape(shape);
    popMatrix();
  }
}
