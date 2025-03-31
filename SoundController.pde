import ddf.minim.*;

public class SoundController{
  Minim minim;
  AudioPlayer ballOnWallSound;
  AudioPlayer ballOnBallSound;
  AudioPlayer cueOnBallSound;
  AudioPlayer pocketedSound;
  
  public SoundController(PApplet pApp){
    minim = new Minim(pApp);
    ballOnBallSound = minim.loadFile("billard_sounds/sound_ball_on_ball.wav");
    ballOnBallSound.setGain(-15);
    ballOnWallSound = minim.loadFile("billard_sounds/sound_ball_on_wall.wav");
    cueOnBallSound = minim.loadFile("billard_sounds/sound_cue_on_ball.wav");
    pocketedSound = minim.loadFile("billard_sounds/sound_pocketing.wav");
  }
  
  void playWoodCollisionSound(){
    ballOnWallSound.play();
  }
  void playBallCollisionSound(){
    ballOnBallSound.play();
  }
  void playPutCollisionSound(){
    pocketedSound.play();
  }
  void playHitCollisionSound(){
    cueOnBallSound.play();
  }
   void audioRewind() {
    if (!ballOnWallSound.isPlaying()) {
      ballOnWallSound.rewind();
      ballOnWallSound.pause();
    }
    if (!cueOnBallSound.isPlaying()) {
      cueOnBallSound.rewind();
      cueOnBallSound.pause();
    }
    if (!ballOnBallSound.isPlaying()) {
      ballOnBallSound.rewind();
      ballOnBallSound.pause();
    }
    if (!pocketedSound.isPlaying()) {
      pocketedSound.rewind();
      pocketedSound.pause();
    }
  } 
}
