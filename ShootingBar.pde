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

    void updateStrength() {
        cue.shootStrength = map(sin(cue.cueAnimationProgress), -1, 1, 0, maxStrength); 
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
