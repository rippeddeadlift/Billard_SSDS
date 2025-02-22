class ShootingBar {
        
    BillardCue cue;
    float maxStrength;      
    float barWidth;         
    float barHeight;        
    float x, y;         
    ShootingBar(float x, float y, float maxStrength, float barWidth, float barHeight, BillardCue billardCue) {
        cue = billardCue;
        this.x = x;
        this.y = y;
        this.maxStrength = maxStrength;
        this.barWidth = barWidth;
        this.barHeight = barHeight;
        cue.shootStrength = 0; 
    }

    void increaseStrength() {
        cue.shootStrength += 1; 
        if (cue.shootStrength > maxStrength) {
            cue.shootStrength = maxStrength; 
        }
    }


    void decreaseStrength() {
        cue.shootStrength -= 50; 
        if (cue.shootStrength < 0) {
            cue.shootStrength = 0; 
        }
    }

    
void draw() {
    pushMatrix();
    camera(); 
    fill(200);
    rect(x, y, barWidth, barHeight);    
    float strengthRatio = cue.shootStrength / maxStrength;
    fill(0, 255, 0);
    rect(x, y, barWidth * strengthRatio, barHeight);
    popMatrix();
}


}
