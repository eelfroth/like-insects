class Sky {
  float c, v;
  Cloud[] clouds, clouds2;
  
  Sky() {
    c = 6;
    v = -10;
    clouds = new Cloud[10];
    clouds2 = new Cloud[10];
    for(int i=0; i<clouds.length; i++) {
      clouds[i] = new Cloud(random(-50, width));
      clouds2[i] = new Cloud(random(-50, width));
    }
  }
  
  void update() {
    c += random(-3, 3);
    if (c > 64) c = 32;
    else if (c < 0) c = 0;
    for(int i=0; i<clouds.length; i++) {
      clouds[i].move(v);
      if (clouds[i].destroy) clouds[i] = new Cloud(width+150);
      clouds2[i].move(v);
      if (clouds2[i].destroy) clouds2[i] = new Cloud(width+150);
    }
  }
  
  void display() {
    pg.background(c, 100);
    for(int i=0; i<clouds.length; i++) {
      clouds[i].display();
    }
    pg.tint(255);
    if(mLeft) {
      pg.image(iBg, 20-(player.l.x/pg.width)*40 + random(-1, 1), 5-(player.l.y/pg.height)*10 + random(-1, 1), pg.width, pg.height);
      pg.image(iFg, random(-0.5, 0.5), pg.height/2 + random(-0.5, 0.5), pg.width, pg.height/2);
    }
    else {
      pg.image(iBg, 20-(player.l.x/pg.width)*40, 5-(player.l.y/pg.height)*10, pg.width, pg.height);
      pg.image(iFg, 0, pg.height/2, pg.width, pg.height/2);
    }
  }
}

class Cloud {
  PVector l, scale;
  float c;
  boolean destroy;
  
  Cloud(float x) {
    l = new PVector(x, random(-100, pg.height), random(5));
    scale = new PVector(random(40,100) / l.z, random(30, 100) / l.z);
    c = random(32);
  }
  
  void move(float v) {
    l.x += (v / l.z) * delta;
    if (l.x < -200 || l.x > width+200) destroy = true;
  } 
  
  void display() {
    tCloud.scale.set(scale.x/4, scale.y/4, 0);
    tCloud.tint = color(c, l.z * 40);
    tCloud.draw(0, l.x - (scale.x*16)/2, l.y);
  }
}

