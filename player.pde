class Player extends RigidBody {
  boolean jumped, taken;
  ArrayList<Bullet> bullets;
  int flip;
  float take, take_time;
  
  Player(float x, float y) {
    super(x, y,
          12, 20,
          1, 0);
    jumped = false;
    bullets = new ArrayList<Bullet>();
    flip = 0;
    
    take = 0;
    take_time = 40;
    taken = false;
    aPlayer.scale.x = 1;
  }
  
  void update() {
    super.update();
    for(int i=0; i<bullets.size(); i++) {
      Bullet b = bullets.get(i);
      b.update();
      if (b.destroy) {
        bullets.remove(i);
        i--;
      }
    }
  }
  
  void display() {
    //super.display();
    
    pg.tint(0);
    pg.imageMode(CENTER);
    float s = random(64, 128);
    pg.image(iGradient, l.x +6, l.y +10, s, s);
    pg.imageMode(CORNER);
    
    tSpiral.scale.set(4, 4, 0);
    tSpiral.rotate = float(millis()) / 100;
    tSpiral.tint = color(0, 100);
    tSpiral.draw(0, (mouseX-offset_x)/scaling_x, (mouseY-offset_y)/scaling_y);
    
    
    if(take == 0) aPlayer.draw(l.x + (16*flip) -2, l.y);

    for(Bullet b : bullets) {
      b.display();
    }
    if(take == 0) {
      tSkull.rotate = 0;
      tSkull.scale.x = 1 -2*flip;
      tSkull.draw(1, l.x + (6*flip) + 3, l.y - 2);
    }
    else{
      tTake.scale.set(1 -2*flip, 1, 0);
      if (take <  take_time/2) tTake.draw(0, l.x + (20*flip) -4, l.y -10);
      else tTake.draw(1, l.x + (20*flip) -4, l.y -10);
    }  
  }
  
  void control() {
    if (take == 0) {
      if (on_floor) {
        aPlayer.speed = 0.1;
      }
      else{
        aPlayer.speed = 0;
        aPlayer.index = 1;
      }
      
      if (check_key('a'))  {
        a.x = -0.5;
        flip = 0;
        aPlayer.scale.x = 1;
      }
      else if (check_key('d')) {
        a.x = 0.5;
        flip = 1;
        aPlayer.scale.x = -1;
      }
      else {
        a.x = 0;
        aPlayer.speed = 0;
        aPlayer.index = 0;
      }
      if (check_key('w')) {
        if (on_floor && !jumped) {
          v.y = -5;
          jumped = true;
          sSpring.trigger();
        }
      }
      else {
        if (!on_floor && v.y < 0) {
          v.y = 0;
        }
        jumped = false;
      }
      
      if (mLeft) {
        PVector bullet_v = new PVector ((mouseX-offset_x)/scaling_x - (l.x + 6), (mouseY-offset_y)/scaling_y - (l.y));
        bullet_v.normalize();
        bullet_v.mult(5);
        bullets.add(new Bullet(l.x + 6, l.y,
                               bullet_v.x + random(-0.5, 0.5),
                               bullet_v.y + random(-0.5, 0.5)));
        if (frameCount % 4 < 1) {
          sSchiess.trigger();
        }
      }
      
      if(check_key(' ')) {
	take = 1;
	if (v.y < 0) v.y = 0;
      }
    }
     
    else {
      a.x = 0;
      take += delta;
      if(take >= take_time) {
        take = 0;
        taken = false;
      }
      else if (take >= take_time/2 && !taken) {
        RigidBody b = check_body(l.x+6, l.y + 21);
	if (b == null || !b.is_corpse()) b = check_body(l.x, l.y + 21);
	if (b == null || !b.is_corpse()) b = check_body(l.x+12, l.y + 21);
        if(b != null) {
          if (b.is_corpse()) {
	    b.kill();
            taken = true;
            skulls_taken++;
          } else take = 0;
        } else take = 0;
      }
      if (on_floor && check_key(' ')) take = 1;
    }
  }
  
  
  
  void kill() {
    super.kill();
    skulls.add(new Skull(l.x, l.y, 1));
    
    sPStirb.trigger();
    
    bg1 = minim.loadFile("bg2.mp3");
    bg1.play();
    bg1.loop();
  }
  
}

class Bullet {
  PVector l, v;
  boolean destroy;
  
  Bullet(float x, float y, float vx, float vy) {
    l = new PVector(x, y);
    v = new PVector(vx, vy);
  }
  
  void update() {
    l.add(PVector.mult(v, delta));
    
    if(check_wall(l.x, l.y) != null) {
      destroy = true;
    }
    
    if(l.y < 0 || l.y > pg.height || l.x < 0 || l.x > pg.width) destroy = true;
    
    RigidBody other = check_body(l.x, l.y);
    if(other != null && other != player) {
      if (other.is_enemy() || other.is_corpse()) {
        other.health -= 1;
        if(frameCount % 4 < 1) sTreff.trigger();
        
        Particle p = new Blood(l.x, l.y);
        p.v.y = v.y;
        p.v.x = v.x;
        particles.add(p);
      }
      destroy = true;
    }
  }
  
  void display() {
    pg.tint(0, 128);
    pg.imageMode(CENTER);
    float s = random(16, 32);
    pg.image(iGradient, l.x, l.y, s, s);
    pg.imageMode(CORNER);
    
    pg.stroke(200);
    pg.line(l.x, l.y, l.x - v.x, l.y - v.y);
  }
}
