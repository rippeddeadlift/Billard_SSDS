class ShootingBar {
    BillardCue cue;
    float maxStrength;      
    float barWidth;         
    float barHeight;        
    float x, y; 
    PFont font = createFont("Calibri",16);

    ShootingBar(float x, float y, float maxStrength, float barWidth, float barHeight, BillardCue billardCue) {
        cue = billardCue;
        this.x = x;
        this.y = y;
        this.maxStrength = maxStrength; 
        this.barWidth = barWidth;
        this.barHeight = barHeight;
        cue.shootStrength = 0; 
    }

    void updateStrength() {
        cue.shootStrength = map(sin(cue.cueAnimationProgress), -1, 1, 0, maxStrength); 
    }

    void draw() {
        pushMatrix();
        color bgColor = get((int)x, (int)y);
        noFill();
        if(bgColor == -1){
          stroke(0,0,0);
        }else{
          stroke(255,255,255);
        }
        rect(x, y, barWidth, barHeight);
        
        if(bgColor == -1){
          fill(0,0,0);
        }else{
          fill(255,255,255);
        }
        textFont(font);
    textAlign(LEFT);
    text("POWER", x + barWidth / 2 - 30, y + barHeight / 2 + 5);
    float strengthRatio = cue.shootStrength / maxStrength;
    fill(255,255 - (255*strengthRatio),0);
    rect(x, y, barWidth * strengthRatio, barHeight); 

    popMatrix();
    }
}
