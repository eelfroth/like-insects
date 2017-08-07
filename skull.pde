class Skull extends RigidBody{
  int index;
  float rotate;
  
  Skull(float x, float y, int index){
    super(x, y, 6, 6, 0.5, 0.9);
    this.index = index;
    if (index == 0) rotate = random(TWO_PI);
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
    tSkull.draw(index, l.x + 3, l.y + 3);
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
  }
}
