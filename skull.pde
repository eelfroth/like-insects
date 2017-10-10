class Skull extends RigidBody{
  int index;
  float rotate, torque;
  
  Skull(float x, float y, int index){
    super(x, y, 6, 6, 0.2, 0.6);
    this.index = index;
    if (index == 0) {
      rotate = random(TWO_PI);
      torque = random(-random(3), random(3));
    }
  }
  
  void update() {
    super.update();
    rotate += torque * delta;
    torque *= 1 - 0.03 * delta;
  }

  void display() {
    if (index == 1) {
      tStar.scale.set(4, 4, 0);
      tStar.rotate = float(millis()) / 1000;
      tStar.tint = color(0, 200);
      tStar.draw(0, l.x+ 3, l.y + 3);
    }
    
    tSkull.rotate = rotate;
    tSkull.scale.set(1, 1, 0);
    tSkull.draw(index, l.x +3 +sin(rotate)*3, l.y +3 -cos(rotate)*2);
    /*
    pg.stroke(255, 255, 255);
    pg.noFill();
    pg.rect(l.x, l.y, size.x, size.y);*/
  }
  
  boolean is_skull() {
    return true;
  }
  
  void on_collide(RigidBody other) {
    if (other.is_enemy()) {
      other.kill();
    } 
    v.x += torque * 6;
  }
}
