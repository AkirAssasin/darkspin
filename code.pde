/* @pjs pauseOnBlur="true"; */

int totalDots = 180;
int score = 0;
int gameState = 0;
int played = 0;
int switchTime = random(100,300);
Dot[] dots = new Dot[totalDots];
int r = random(255);
int g = random(255);
int b = random(255);
 
int width, height;
color fillColor;
float diameter = 12.0;

var menu = new Howl({
  urls: ['music/Cycles.mp3', 'music/Cycles.ogg'],
  loop: true,
});

var game = new Howl({
  urls: ['music/Boom.mp3', 'music/Boom.ogg'],
  loop: true,
});

void setup() {
    noCursor();
    menu.play();
    // initialization
    width = 960;
    height = 800;
    size(width, height);
    // initial fill colour
    fillColor = color(0, 0, 0);
    fill(fillColor);
    noStroke();
    // array of dots
    for (int i = 0; i < totalDots; i++) {
        Dot d = new Dot();
        d.x = width/2;
        d.y = height/2;
        dots[i] = d;
    }
    background(0);
};
 
void draw() {
    fill(0, 15);
    rect(0, 0, width, height);
 
    for (int i = 0; i < totalDots; i++) {
        fill(r, g, b);
        dots[i].update();
        rect(dots[i].x, dots[i].y, diameter, diameter);
    }
    
    if (gameState == 0) {
        for (int i = 0; i < totalDots; i++) {
            dots[i].sleep();
        };
        if (played == 0) {
            textSize(60);
            text ("Darkspin",(width/2.55) + random(-2,2),(height/2.5) + random(-2,2));
        } else {
            textSize(60);
            text ("Crushed",(width/2.55) + random(-2,2),(height/2.5) + random(-2,2));
            textSize(30);
            text (score,mouseX + random(-2,2),mouseY + random(-2,2));
        };
        
        textSize(30);
        text ("click to start",width/2.35 + random(-1,1),height/2.2 + random(-1,1));
    };
    
    fill((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
    ellipse((mouseX-4),(mouseY-4),4,4);
    
    if (gameState == 1) {
        score += 1;
        if (switchTime > 0) {
            switchTime -= 1;
        } else {
            switchTime = random(150,200);
            r = random(255);
            g = random(255);
            b = random(255);
            for (int i = 0; i < totalDots; i++) {
                dots[i].switchMode();
            };
        };
    };
};

void mouseClicked() {
    if (gameState == 0) {
        score = 0;
        gameState = 1;
        menu.stop();
        if (played == 0) {game.play();};
        played = 1;
        for (int i = 0; i < totalDots; i++) {
            dots[i].wake();
        };
    };
};

class Dot {
    float x = 0.0;
    float y = 0.0;
    float vx = 0.0;
    float vy = 0.0;
    float mode = 4;
    
    void switchMode(){
      this.mode = round(random(3.4));
    };
    
    void wake(){
      this.mode = 0;
    };
    
    void sleep(){
      this.mode = 4;
    };
    
    void update(){
      // update the velocity
      if (dist((this.x + 6),(this.y + 6),mouseX,mouseY) < 7) {gameState = 0;};
      
      if (this.mode == 0) {
        this.vx += random(0.8) - 0.4;
        this.vx *= .96;
        this.vy += random(0.8) - 0.4;
        this.vy *= .96;
      }
      if (this.mode == 1) {
        if (mouseX > this.x) {this.vx += random(0.2); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.2); this.vx *= .96;};
        if (mouseY > this.y) {this.vy += random(0.2); this.vy *= .96;};
        if (mouseY < this.y) {this.vy -= random(0.2); this.vy *= .96;};
      }
      if (this.mode == 2) {
        if (mouseX < this.x) {this.vx += random(0.5); this.vx *= .96;};
        if (mouseX > this.x) {this.vx -= random(0.5); this.vx *= .96;};
        if (mouseY > this.y) {this.vy += random(0.5); this.vy *= .96;};
        if (mouseY < this.y) {this.vy -= random(0.5); this.vy *= .96;};
      }
      if (this.mode == 4) {
        this.x = width/2;
        this.y = height/2;
        this.vx = 0;
        this.vy = 0;
      }
      if (this.mode == 3) {
        if (mouseX > this.x) {this.vx += random(0.5); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.5); this.vx *= .96;};
        if (mouseY < this.y) {this.vy += random(0.5); this.vy *= .96;};
        if (mouseY > this.y) {this.vy -= random(0.5); this.vy *= .96;};
      }
      // update the position
      this.x += this.vx;
      this.y += this.vy;
      // handle boundary collision
      if (this.x > width) {this.x = 0; if (this.mode == 2 || this.mode == 3) {this.mode = 1;};}
      if (this.x < 0) {this.x = width; if (this.mode == 2) {this.mode = 1;};}
      if (this.y > height) {this.y = 0; if (this.mode == 2) {this.mode = 1;};}
      if (this.y < 0) {this.y = height; if (this.mode == 2) {this.mode = 1;};}
    }
}