public class Table{
  void draw() {
    background(200);
    lights();
    camera(mouseX, mouseY, (height/2)/tan(PI/6), width/2, height/2, 0, 0, 1, 0);
    drawTableTop();
    drawTableLegs();
    drawBorders();
  }

  void drawTableTop(){
    pushMatrix();
    translate(width/2, height/2, 0);
    fill(0, 51, 25); 
    box(300, 30, 200);
    popMatrix();
  }

  void drawTableLegs(){
    for (int x = -90; x <= 90; x += 180) {
      for (int z = -40; z <= 40; z += 80) {
        pushMatrix();
        translate(width/2 + x, height/2 + 55, z);
        fill(100, 50, 0); // Darker brown
        box(50, 100, 40); // width, height, depth
        popMatrix();
      }
    }
  }
  
  void drawBorders(){
  pushMatrix();
  translate(width/2, height/2 - 5,-100);
  fill(100, 50, 0); 
  box(300, 50, 10);
  popMatrix();
  
  // Bottom border
  pushMatrix();
  translate(width/2, height/2 - 5, 100);
  fill(100, 50, 0);
  box(300, 50, 10);
  popMatrix();
  
  // Left border
  pushMatrix();
  translate(width/2-150, height/2 - 5, 0);
  fill(100, 50, 0);
  box(10, 50, 200);
  popMatrix();
  
  // Right border
  pushMatrix();
  translate(width/2 + 150, height/2 - 5, 0);
  fill(100, 50, 0);
  box(10, 50, 200);
  popMatrix();
  }
}
