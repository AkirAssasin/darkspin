int totalDots = 180;
int score = 0;
int gameState = 0;
int played = 0;
int switchTime = random(100,300);
Dot[] dots = new Dot[totalDots];
int r = random(50,255);
int g = random(50,255);
int b = random(50,255);
int musicPlaying = round(random(-0.5,5.4)); 
int timeSlow = 300;
 
int width, height;
color fillColor;
float diameter = 12.0;

var game1 = new Howl({
  urls: ['music/Cycles.mp3', 'music/Cycles.ogg'],
  loop: true,
});

var game2 = new Howl({
  urls: ['music/Boom.mp3', 'music/Boom.ogg'],
  loop: true,
});

var game3 = new Howl({
  urls: ['music/ThoughtBot.mp3', 'music/ThoughtBot.ogg'],
  loop: true,
});

var game4 = new Howl({
  urls: ['music/DubstepLight.mp3', 'music/DubstepLight.ogg'],
  loop: true,
});

var game5 = new Howl({
  urls: ['music/TechTalk.mp3', 'music/TechTalk.ogg'],
  loop: true,
});

void setup() {
    noCursor();
    game1.play();
    width = 960;
    height = 800;
    size(width, height);
    // initial fill colour
    fillColor = color(0, 0, 0);
    fill(fillColor);
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
    stroke(0, 15);
    fill(0, 15);
    rect(0, 0, width, height);
 
    if (mousePressed && (mouseButton == RIGHT) && timeSlow > 0) {
         if (gameState == 1) {
             fill((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
             textSize(60);
             text (round(timeSlow/60),width/2 + random(-2,2),60 + random(-2,2));
             fill(0);
             ellipse(mouseX,mouseY,300,300);
         };
         fill(0);
         stroke(r, g, b);
         timeSlow -= 1;
         for (int i = 0; i < totalDots; i++) {
             dots[i].timeShift();
         };
    } else {
        fill(r, g, b);
        if (gameState == 1) {
            score += 1;
            textSize(30);
            text (round(score/60) + "s",width/2 + random(-2,2),30 + random(-2,2));
        };
    };
    
    for (int i = 0; i < totalDots; i++) {
        
        dots[i].update();
        if (gameState == 1) {rect(dots[i].x, dots[i].y, diameter, diameter);};
    }
    
    if (gameState == 0) {
        document.body.style.background = '1C1C1C';
        for (int i = 0; i < totalDots; i++) {
            dots[i].sleep();
        };
        fill(r, g, b);
        if (played == 0) {
            textSize(60);
            text ("Darkrix",(width/2.43) + random(-2,2),(height/2.5) + random(-2,2));
        } else {
            fill(255,0,0);
            textSize(60);
            text ("Crushed",(width/2.55) + random(-2,2),(height/2.5) + random(-2,2));
            fill(r, g, b);
            textSize(30);
            text (round(score/60) + "s",width/1.6 + random(-2,2),height/2.05 + random(-2,2));
        };
        
        textSize(30);
        text ("LMB to start",width/2.35 + random(-1,1),height/2.2 + random(-1,1));
        textSize(20);
        text ("dodge the boxes",width/2.32 + random(-1,1),height/2.05 + random(-1,1));
        textSize(15);
        text ("RMB to slow down",width/2.25 + random(-1,1),height/1.95 + random(-1,1));
    };
    
    stroke((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
    fill((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
    strokeWeight(8);
    line(mouseX,mouseY,pmouseX,pmouseY);
    strokeWeight(1);
    
    if (gameState == 1) {
        document.body.style.background = hex(color(r/2,g/2,b/2),6);
        if (switchTime > 0) {
            switchTime -= 1;
        } else {
            switchTime = random(150,200);
            r = random(50,255);
            g = random(50,255);
            b = random(50,255);
            if (random(1) > 0.1) {
                for (int i = 0; i < totalDots; i++) {
                     dots[i].switchMode();
                };
            } else {
                for (int i = 0; i < totalDots; i++) {
                     dots[i].sweepMode();
                };
            };
        };
    };
};

void mouseClicked() {
    if (gameState == 0 && (mouseButton == LEFT)) {
        timeSlow = 300;
        score = 0;
        gameState = 1;
        if (played == 0) {
            if (musicPlaying == 2) {game1.stop(); game2.play();};
            if (musicPlaying == 3) {game1.stop(); game3.play();};
            if (musicPlaying == 4) {game1.stop(); game4.play();};
            if (musicPlaying == 5) {game1.stop(); game5.play();};
        };
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
    float mode = 6;
    
    void switchMode(){
        this.mode = round(random(3.4));
    };
    
    void sweepMode(){
        this.mode = round(random(3.5,5.4));
    };
    
    void timeShift (){
        if (dist((this.x + 6),(this.y + 6),mouseX,mouseY) < 200) {
            this.vx /= 1.4;
            this.vy /= 1.4;
        };
    };
    
    void wake(){
      this.mode = 0;
    };
    
    void sleep(){
      this.mode = 6;
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
        if (mouseX > this.x) {this.vx += random(0.25); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.25); this.vx *= .96;};
        if (mouseY > this.y) {this.vy += random(0.25); this.vy *= .96;};
        if (mouseY < this.y) {this.vy -= random(0.25); this.vy *= .96;};
      }
      
      if (this.mode == 2) {
        if (mouseX < this.x) {this.vx += random(0.5); this.vx *= .96;};
        if (mouseX > this.x) {this.vx -= random(0.5); this.vx *= .96;};
        if (mouseY > this.y) {this.vy += random(0.5); this.vy *= .96;};
        if (mouseY < this.y) {this.vy -= random(0.5); this.vy *= .96;};
      }
      
      if (this.mode == 3) {
        if (mouseX > this.x) {this.vx += random(0.5); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.5); this.vx *= .96;};
        if (mouseY < this.y) {this.vy += random(0.5); this.vy *= .96;};
        if (mouseY > this.y) {this.vy -= random(0.5); this.vy *= .96;};
      }
      
      if (this.mode == 4) {
        if (mouseX > this.x) {this.vx += random(0.35); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.35); this.vx *= .96;};
        this.vy += random(0.5);
        this.vy *= .96;
      }
      
      if (this.mode == 5) {
        if (mouseX > this.y) {this.vy += random(0.35); this.vy *= .96;};
        if (mouseX < this.y) {this.vy -= random(0.35); this.vy *= .96;};
        this.vx += random(0.5);
        this.vx *= .96;
      }
      
      if (this.mode == 6) {
        this.x = width/2;
        this.y = height/2;
        this.vx = 0;
        this.vy = 0;
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