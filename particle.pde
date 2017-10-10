class Particle extends RigidBody {
  float life;
  
  Particle(float x, float y, float w, float h, float m, float e, float life) {
    super(x, y, w, h, m, e);
    this.life = life;
    bodies.remove(this);
  }
  
  void update() {
    super.update();
    
    life -= delta;
    if (life <= 0) kill();
  }
  
  void collide_body() {
    //empty
  }
}

class Blood extends Particle{
  float c;
  float life_max;

  Blood(float x, float y) {
    super(x, y, 1, 1, 0.1, 0.1, 1000);
    c = 200;
    life_max = 1000;
    //v.y = -random(random(8));
    //v.x = random(-random(8), random(8));
  }
  
  void display() {
    pg.stroke(c, life/life_max * 255);
    pg.point(l.x, l.y);
  }
}

class Limb extends Particle{
  int index;
  float rotate;
  
  Limb(float x, float y, int index) {
    super(x, y, 1, 1, 0.3, 0.75, 1000);
    this.index = index;
    rotate = random(TWO_PI);
    v.y = -random(4);
    v.x = random(-5, 5);
    //bodies.add(this);
  }
  
  void display() {
    tLimb.tint = color(255, life/1000 * 255);
    tLimb.rotate = rotate;
    tLimb.draw(index, l.x, l.y);
  }
}
