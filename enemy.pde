class Enemy extends RigidBody {
  boolean left, right, jump;
  int flip;
  float image_index;
  boolean reached_ground;
  float attack = 0, attack_time = 30;
  
  Enemy(float x, float y) {
    super(x, y,
          12, 20,
          1, 0);
    flip = 0;
    reached_ground = false;
    health = 3;
  }
  
  void control() {
    if (attack == 0) {
      if (reached_ground) ki();
      
      if (on_floor) {
        image_index += 0.1;
        reached_ground = true;
      }
      else{
        image_index = 1;
      }
      if (left)  {
        a.x = -0.3;
        flip = 0;
      }
      else if (right) {
        a.x = 0.3;
        flip = 1;
      }
      else {
        a.x = 0;
        image_index = 0;
      }
      if (jump) {
        if (on_floor) {
          v.y = -7.5;
          //sSpring.trigger();
        }
      }
      else {
        if (!on_floor && v.y < 0) {
          v.y = 0;
        }
      }
      RigidBody b = check_body(l.x -3 +18*flip, l.y + 4);
      if (b == player) {
        attack = 1;
        sHau.trigger();
      }
    }
    else {
      a.x = 0;
      attack += delta;
      RigidBody b = check_body(l.x -1 +14*flip, l.y + 4);
      if (b == player) {
        player.kill();
      }
      if (attack >= attack_time) attack = 0;
    }
    
    if (image_index >= 2) image_index = 0;
  }
  
  void ki() {
    if (player.l.x > l.x) right = true;
    else right = false;
    if (player.l.x < l.x) left = true;
    else left = false;
    
    jump = false;
    if (left) {
      if (check_wall(l.x+6 -16, l.y + 19) != null) {
        jump = true;
      }
      RigidBody other = check_body(l.x+6 -16, l.y + 19);
      if (other != null) {
        if(!other.is_enemy() && other != player) jump = true;
      }
    }
    if (right) {
      if (check_wall(l.x+6 +16, l.y + 19) != null) {
        jump = true;
      }
      RigidBody other = check_body(l.x+6 +16, l.y + 19);
      if (other != null) {
        if(!other.is_enemy() && other != player) jump = true;
      }
    }
  }
  
  void kill(boolean splatter) {
    super.kill();
    Corpse corpse = new Corpse(l.x, l.y, flip);
    corpse.v.set(v.x, 0);
    corpses.add(corpse);
    if (splatter) corpse.kill();
    sStirb.trigger();
    for(int i=0; i<10; i++) {
      Particle p = new Blood(l.x+6, l.y+4);
      p.v.y = -random(i/4);
      p.v.x = random(i/2 - i * flip);
      particles.add(p);
    } 
    if (!player.destroy) {
      kills++;
    }
  }

  void kill() {
    kill(false);
  }
  
  boolean is_enemy() {
    return true;
  }
  
  void on_collide(RigidBody other) {
    if (other.is_skull()) {
      kill();
    } 
  }
  
  void display() {
    if (attack == 0) {
      tEnemy.scale.x = 1 -2*flip;
      tEnemy.draw(floor(image_index), l.x + (16*flip) -2, l.y - 4);
    }
    else {
      tAttack.scale.x = 1 -2*flip;
      tAttack.draw(0, l.x + (20*flip) -4, l.y - 4);
    }
    /*
    pg.stroke(255);
    pg.noFill();
    pg.rect(l.x, l.y, size.x, size.y);*/
  }
  
}

class Corpse extends RigidBody {
  int flip;
  
  Corpse(float x, float y, int flip) {
    super(x, y,
          20, 7,
          2, 0.5);
    this.flip = flip;
    health = 32;
  }
  
  void display() {
    tCorpse.scale.x = 1 -2*flip;
    tCorpse.draw(0, l.x + (20*flip), l.y -1);
   /* pg.stroke(255);
    pg.noFill();
    pg.rect(l.x, l.y, size.x, size.y);*/
  }
  
  boolean is_corpse() {
    return true;
  }
  
  void kill() {
    super.kill();
    sZerleg.trigger();
    for(int i=0; i<100; i++) {
      Particle p = new Blood(l.x+10, l.y+4);
      p.v.y = -random(i/10);
      p.v.x = random(-i/10, i/10);
      particles.add(p);
    } 
    particles.add(new Limb(l.x+10, l.y+4, 0));
    particles.add(new Limb(l.x+10, l.y+4, 0));
    particles.add(new Limb(l.x+10, l.y+4, 1));
    particles.add(new Limb(l.x+10, l.y+4, 1));
    particles.add(new Limb(l.x+10, l.y+4, 2));
    particles.add(new Limb(l.x+10, l.y+4, 3));
    particles.add(new Limb(l.x+10, l.y+4, 4));
  }
}


