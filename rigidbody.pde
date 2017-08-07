class RigidBody {
   PVector l, v, a, size;
   float mass, elasticity;
   boolean collision_x;
   boolean on_floor;
   boolean destroy;
   RigidBody collided_with;
   int health;
   
   RigidBody(float x, float y, float w, float h, float m, float e) {
     l = new PVector(x, y);
     v = new PVector(0, 0);
     a = new PVector(0, 0);
     size = new PVector(w, h);
     mass = m;
     elasticity = e;
     collision_x = false;
     on_floor = false;
     health = 1;
     
     bodies.add(this);
   }
   
   void update() {
     if (collided_with != null) {
       on_collide(collided_with);
     }
     
     if (health <= 0) kill();
     check_floor();
     
     control();
     move();
     
     collide_wall();
     collide_body();
   }
   
  void check_floor() {
    on_floor = false;
    PVector _l = new PVector(l.x, l.y +1);
    
    for(Wall other : walls) {
      if (collide(_l, size, other.l, other.size)) {  
        if (!collision_x) {
          on_floor = true;
        }
      }
    }
    
    for(RigidBody other : bodies) {
      if (other != this) {
        if (collide(_l, size, other.l, other.size)) {  
          if (!collision_x) {
            on_floor = true;
          }
        }
      }
    }
  }
  
  void control() {
    //There is nothing here. Please overload.
  }
  
  void move() {
    if (!on_floor) a.y += gravity * mass;
    else a.y = 0;
    v.add(PVector.mult(a, delta));
    v.mult((1-friction * delta) );
    
    l.add(PVector.mult(v, delta));
    
    if(l.y > pg.height-size.y) {
      l.y = pg.height-size.y;
      v.y *= -1 * elasticity;
    }
    
    if(on_floor) {
      if( abs(v.y) < 0.3) {
        v.y = 0;
      }
      v.x *= 1 - friction * delta;
    }
  }
  
  void collide_wall() {
    for(Wall other : walls) {
      
      if (collide(l, size, other.l, other.size)) {  
        if (collision_x) {
          v.x *= -elasticity;
          if (abs(v.x) < 0.3) v.x = 0;
        }
        else {
          v.y *= -elasticity;
        }
      }
      
    }
  }
  
  void collide_body() {
    collided_with = null;
    for(RigidBody other : bodies) {
      
      if (other != this) {
        if (collide(l, size, other.l, other.size)) {  
          float prop = mass / (mass + other.mass);
          if (collision_x) {
            float force = abs(v.x) + abs(other.v.x);
            if (v.x < other.v.x) {
              v.x += force * prop * elasticity;
              other.v.x -= force * (1-prop) * other.elasticity;
            }
            if (v.x > other.v.x) {
              v.x -= force * prop * elasticity;
              other.v.x += force * (1-prop) * other.elasticity;
            } 
          }
          else {
            if (!other.on_floor) {
              float force = abs(v.y * elasticity) + abs(other.v.y * other.elasticity);
              if (v.y < other.v.y) {
                v.y += force * prop * elasticity;
                other.v.y -= force * (1-prop) * other.elasticity;
              }
              if (v.y > other.v.y) {
                v.y -= force * prop * elasticity;
                other.v.y += force * (1-prop) * other.elasticity;
              }
            }
            else {
              v.y *= -elasticity * other.elasticity;
            }
          }
          collided_with = other;
        }
      }
      
    }
  }
  
  void on_collide(RigidBody other) {
    //empty
  }
   
  boolean collide(PVector l, PVector size, PVector _r2_l, PVector r2_s) {
    PVector r2_l=_r2_l.get();
    r2_l.add(PVector.mult(r2_s, 0.5));
    r2_l.sub(PVector.mult(size, 0.5));
    //Entfernung
    PVector distance = new PVector(r2_l.x - l.x, r2_l.y - l.y);
    
    //Kollision
    if (abs(distance.x) < size.x *0.5 + r2_s.x *0.5) {
      if (abs(distance.y) < size.y *0.5 + r2_s.y *0.5) {
        //Overlap
        float overlap_x = size.x *0.5 + r2_s.x *0.5 - abs(distance.x);
        float overlap_y = size.y *0.5 + r2_s.y *0.5 - abs(distance.y);
        if (overlap_y < overlap_x){
          //Kollision auf der x-Achse
          if(distance.y > 0) {
            l.y -= overlap_y;
            
            //a.x=0;
          }
          else {
            l.y += overlap_y;
          }
          
          collision_x = false;
          return true;
        }
        
        else {
          //Kollision auf der y-Achse
          if(distance.x > 0) {
            l.x -= overlap_x;
          }
          else {
            l.x += overlap_x;
          }
                    
          collision_x = true;
          return true;
        }
      }
    }
    return false;
  }
  
  void kill() {
    destroy = true;
    bodies.remove(this);
  }
  
  boolean is_enemy() {
    return false;
  }
  
  boolean is_corpse() {
    return false;
  }
  
  boolean is_skull() {
    return false;
  }
   
   void display() {
     pg.noStroke();
     pg.fill(255);
     pg.rect(l.x, l.y, size.x, size.y);
   }
}


