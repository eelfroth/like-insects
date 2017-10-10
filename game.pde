///////////////////////////////////////////////////

//Assets
Animation aPlayer;
Tileset tEnemy;
Tileset tSkull;
Tileset tCorpse;
Tileset tCloud;
PImage iBg, iFg, iGradient;
Tileset tSpiral;
Tileset tCross;
Tileset tTake;
Tileset tAttack;
Tileset tStar;
Font font;
Tileset tLimb;
PImage title;

void load_assets(){
  aPlayer = new Animation("player.png", 16, 20, 2, pg);
  tEnemy = new Tileset("enemy.png", 16, 24, 2, pg);
  tSkull = new Tileset("skull.png", 9, 9, 2, pg);
  tSkull.origin.set(3, 3, 0);
  tCorpse = new Tileset("corpse.png", 24, 12, 1, pg);
  tCloud = new Tileset("cloud.png", 64, 32, 1, pg);
  iBg = loadImage("bg.png");
  iFg = loadImage("fg.png");
  iGradient = loadImage("gradient.png");
  tSpiral = new Tileset("spiral.png", 160, 160, 1, pg);
  tSpiral.origin.set(80, 80, 0);
  tStar = new Tileset("star.png", 160, 160, 1, pg);
  tStar.origin.set(80, 80, 0);
  tCross = new Tileset("crosshair.png", 17, 17, 1, pg);
  tCross.origin.set(8, 8, 0);
  tTake = new Tileset("player_take.png", 20, 30, 2, pg);
  tAttack = new Tileset("enemy_attack.png", 20, 24, 1, pg);
  font = new Font("font.png", 12, 12, 94, pg);
  font.spacing.y = 2;
  tLimb = new Tileset("limbs.png", 10, 4, 5, pg);
  tLimb.origin.set(5, 2, 0);
  title = loadImage("title.png");
}
///////////////////////////////////////////////////

//Pointers
ArrayList<Wall> walls;
ArrayList<RigidBody> bodies;
Player player;
ArrayList<Enemy> enemies;
ArrayList<Corpse> corpses;
Sky sky;
ArrayList<Skull> skulls;
ArrayList<Particle> particles;

//Global Variables
float gravity = 0.05;
float friction = 0.1;
float enemy_max;
float wave, wave_time;
int skulls_taken, kills;
float rain, rain_time;
boolean startscreen=true;

void initialize() {
  initialize_sound();

  walls = new ArrayList<Wall>();
  walls.add(new Wall(0, pg.height-16, pg.width, 20));
  walls.add(new Wall(-16, -16, 16, pg.height+16));
  walls.add(new Wall(pg.width, -16, 16, pg.height+16));

  bodies = new ArrayList<RigidBody>();
  player = new Player(200, 180);

  enemies = new ArrayList<Enemy>();
  corpses = new ArrayList<Corpse>();
  sky = new Sky();

  skulls = new ArrayList<Skull>();
  particles = new ArrayList<Particle>();
  /*for(int i=0;i<100;i++) {
    Skull s = new Skull(random(pg.width/2 - 100, pg.width/2 + 100), 0, 0);
    skulls.add(s);
  }*/

  enemy_max = 1;
  wave_time = 200;
  wave = 100;

  rain_time = 30;
  rain = 0;

  skulls_taken = 0;
  kills = 0;
}
///////////////////////////////////////////////////

void update() {
  if (!startscreen) {
    if (!player.destroy) {
      wave -= delta;
      if (wave <= 0) {
        enemy_max += 0.2;
        while(enemies.size() < floor(enemy_max)) {
          float x = random(pg.width-12);
          if (x > player.l.x-50 && x < player.l.x+50) continue;
          enemies.add(new Enemy(x, -20));
        }
        wave = wave_time;
        sSpawn.trigger(floor(enemy_max));
      }

      sSpawn.update();
      player.update();
    }
    else {
      rain -= delta;
      if (rain <= 0) {
        rain = rain_time;
        if(skulls.size()-1 < skulls_taken) {
          Skull s = new Skull(pg.width/2, 0, 0);
          s.v.x = random(-5, 5);
          skulls.add(s);
          sFall.trigger();
        }
      }
    }

    for(int i=0; i<enemies.size();i++) {
      Enemy e = enemies.get(i);
      e.update();
      if (e.destroy) {
        enemies.remove(i);
        i--;
      }
    }

    for(int i=0; i<corpses.size();i++) {
      Corpse e = corpses.get(i);
      e.update();
      if (e.destroy) {
        corpses.remove(i);
        i--;
      }
    }

    for(int i=0; i<skulls.size();i++) {
      Skull e = skulls.get(i);
      e.update();
      if (e.destroy) {
        skulls.remove(i);
        i--;
      }
    }
    for(int i=0; i<particles.size();i++) {
      Particle e = particles.get(i);
      e.update();
      if (e.destroy) {
        particles.remove(i);
        i--;
      }
    }
    sky.update();
  }
  //editor();
}
///////////////////////////////////////////////////

void display(){
  sky.display();

  for(Enemy e : enemies) {
    e.display();
  }
  for(Corpse e : corpses) {
    e.display();
  }
  for(Particle e : particles) {
    e.display();
  }
  for(Skull e : skulls) {
    e.display();
  }
  

  if (!player.destroy) {
    if (!startscreen) player.display();
  }
  else {
    font.align.x = CENTER;
    font.text("score: " + str(skulls.size()-1), pg.width/2, pg.height/2);
  }


  for(int i=0; i<sky.clouds2.length; i++) {
      sky.clouds2[i].display();
  }
  if (!player.destroy) {
    tCross.rotate = float(millis()) / 1000;
    tCross.tint = color(random(255));
    tCross.draw(0, (mouseX-offset_x)/scaling_x, (mouseY-offset_y)/scaling_y);
  }

  if(startscreen) {
    pg.imageMode(CENTER);
    pg.image(title, pg.width/2, 48);
    pg.imageMode(CORNER);
    font.align.x = CENTER;
    font.align.y = CENTER;
    font.text("MOVE: WASD\nSHOOT: MOUSE\nPRESS SPACE TO\nHARVEST SKULLS!\n\n-CLICK TO START-", pg.width/2, pg.height/2+20);
    font.text("EELFROTH\t V1.2\n", pg.width/2, pg.height - 13);
  }
}
///////////////////////////////////////////////////
boolean mLeft, mRight;

void mousePressed() {
  if (mouseButton == LEFT) {
    mLeft = true;
    /*if (check_key(KeyEvent.VK_F2)) {
      enemies.add(new Enemy(mouseX/scaling_x-6, mouseY/scaling_y-10));
    }*/
  }
  if (mouseButton == RIGHT) {
    mRight = true;
  }
}

void mouseReleased() {
    mLeft = false;
    mRight = false;
    if (startscreen) startscreen = false;
    if (player.destroy) {
      if (skulls.size() > skulls_taken) {
        bg1.close();
        minim.stop();
	startscreen = true;
        initialize();
      }
    }
}

void editor() {
  float x = mouseX / scaling_x;
  float y = mouseY / scaling_y;

  /*if (check_key(KeyEvent.VK_F1)) {
    if (mLeft) {
      if (check_wall(x, y) == null) {
        walls.add(new Wall(round((x-8)/16)*16, round((y-8)/16)*16, 16, 16));
      }
    }

    else if (mRight) {
      Wall w = check_wall(x, y);
      if (w != null) {
        walls.remove(w);
      }
    }
  }*/
}

Wall check_wall(float x, float y) {
  for(Wall w : walls) {
    if (x >= w.l.x && x <= w.l.x + w.size.x) {
      if (y >= w.l.y && y <= w.l.y + w.size.y) {
        return w;
      }
    }
  }

  return null;
}

RigidBody check_body(float x, float y) {
  for(RigidBody b : bodies) {
    if (x >= b.l.x && x <= b.l.x + b.size.x) {
      if (y >= b.l.y && y <= b.l.y + b.size.y) {
        return b;
      }
    }
  }

  return null;
}

////////////////////////////////////////////

