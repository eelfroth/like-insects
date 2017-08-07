Minim minim;

AudioPlayer bg1;
AudioSample sSchiess;
AudioSample sSpring;
AudioSample sTreff;
AudioSample sStirb;
AudioSample sHau;
AudioSample sPStirb;
AudioSample sZerleg;
AudioSample sFall;

void initialize_sound() {
   minim = new Minim(this);

  // this loads mysong.wav from the data folder
  bg1 = minim.loadFile("bg.mp3");
  bg1.play();
  bg1.loop();
  
  sSchiess = minim.loadSample("schiess.wav");
  sSpring = minim.loadSample("spring.wav");
  sTreff = minim.loadSample("triff.wav");
  sStirb = minim.loadSample("stirb.wav");
  sHau = minim.loadSample("hau.wav");
  sPStirb = minim.loadSample("pstirb.wav");
  sZerleg = minim.loadSample("zerleg.wav");
  sFall = minim.loadSample("fall.wav");
}

void stop()
{
bg1.close();
sSchiess.close();
minim.stop();

super.stop();
}
