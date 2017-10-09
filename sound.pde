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
AudioSampleRepeater sSpawn;

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

  sSpawn = new AudioSampleRepeater("spawn.wav", 12);
}

void stop() {
  bg1.close();
  sSchiess.close();
  minim.stop();

  super.stop();
}

///////////////////////////////////////////////

class AudioSampleRepeater {
	AudioSample sample;
	float interval;
	ArrayList<Float> timer; 

	AudioSampleRepeater(String file, float interval_) {
		sample = minim.loadSample(file);
		interval = interval_;
		timer = new ArrayList<Float>();
	}

	void trigger(int n) {
		for (int i=0; i<n; i++) {
			timer.add(new Float(i * interval));
		}
	}
	
	void update() {
		for(int i=0; i<timer.size(); i++) {
			Float t = (Float) timer.get(i);
			t = new Float(t.floatValue() - delta);
			timer.set(i, t);
			if(t.floatValue() <= 0) {
				println("BUMM…");
				sample.trigger();
				timer.remove(i);
				i--;
			}
		}
	}
}
