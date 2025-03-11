class Pockets{
  PVector topLeftCorner,topRightCorner,bottomLeftCorner,bottomRightCorner, middleLeft, middleRight;
  PImage blackTexture = loadImage("data/billard_textures/pocket_texture.jpg");
  ArrayList<PVector> coordinates;
  int pocketRadius = 40;
  
  Pockets(ArrayList<PVector> coords){
    topLeftCorner = new PVector(coords.get(0).x + 30, coords.get(0).y + 30);
    topRightCorner = new PVector(coords.get(1).x - 30, coords.get(1).y + 30);
    bottomLeftCorner = new PVector(coords.get(2).x + 30, coords.get(2).y - 30);
    bottomRightCorner = new PVector(coords.get(3).x - 30, coords.get(3).y - 30);
    middleLeft = new PVector(0, height/2);
    middleRight = new PVector(width, height/2);
    this.coordinates = new ArrayList(List.of(topLeftCorner, topRightCorner,bottomLeftCorner,bottomRightCorner, middleLeft, middleRight));
  }
  
  void draw(){
    for (PVector position : coordinates) {
      pushMatrix();
      PShape pocketShape = createShape(SPHERE, pocketRadius);
      pocketShape.setTexture(blackTexture);
      translate(position.x, position.y, -50);
      fill(255, 255, 255);
      shape(pocketShape);
      popMatrix();
    }
  }
 
}
