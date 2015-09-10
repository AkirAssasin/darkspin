/* @pjs font='fonts/induction.ttf' */ 

var myfont = loadFont("fonts/induction.ttf"); 

ArrayList dots;
int totalDots;

float startDelay;

int isDebug = 0;

int prevDots = 0;
var prevMode;
float score = 0;
int gameState = 0;
int played = 0;
float switchTime = 150;
float r = random(50,255);
float g = random(50,255);
float b = random(50,255);
float timeSlow = 300;
float surroundDia = 230;
int keyIsHold = 0;

int gameMode = 1;
float NormalChance = 0.2;
float FullSurroundChance = 0.1;
float SurroundChance = 0.8;
float UniqueChance = 0.5;
float SurroundMissileChance = 0.9995;
float timeSlowMax = 300;

float width, height;
color fillColor;
float diameter = 12.0;

var impact = new Howl({
  urls: ['music/Impact.mp3', 'music/Impact.ogg'],
});

var[] bgm = new var[4];
int musicPlaying = 0; 

bgm[0] = new Howl({
  urls: ['music/Cycles.mp3', 'music/Cycles.ogg'],
  loop: true,
});

bgm[1] = new Howl({
  urls: ['music/Boom.mp3', 'music/Boom.ogg'],
  loop: true,
});

bgm[2] = new Howl({
  urls: ['music/TechTalk.mp3', 'music/TechTalk.ogg'],
  loop: true,
});

bgm[3] = new Howl({
  urls: ['music/DubstepLight.mp3', 'music/DubstepLight.ogg'],
  loop: true,
});

void setup() {
    noCursor();
    width = window.innerWidth;
    height = window.innerHeight;
    size(width, height);
    dots = new ArrayList();
    fillColor = color(0, 0, 0);
    fill(fillColor);
    background(0);
    totalDots = round(180*(width+height)/(1760));
};
 
Number.prototype.between = function (min, max) {
    return this > min && this < max;
}; 

void draw() {
    if (width != window.innerWidth) {
      width = window.innerWidth;
      size(width, height);
    }
    if (height != window.innerHeight) {
      height = window.innerHeight;
      size(width, height);
    }
    if (mousePressed && (mouseButton == RIGHT) && timeSlow > 0) {
         if (gameState == 1) {
             stroke(0,30);
             fill(0,30);
             rect(0,0,width,height);
             fill((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
             stroke((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
             fill(8,5);
             ellipse(mouseX,mouseY,400,400);
             fill((255 - r/1.1),(255 - g/1.1),(255 - b/1.1),5);
             ellipse(mouseX,mouseY,timeSlow,timeSlow);
             Howler.volume(1 - (timeSlow/timeSlowMax));
             timeSlow -= 1;
         };
         for (int i=dots.size()-1; i>=0; i--) {
             Particle d = (Dot) dots.get(i);
             d.timeShift();
         }
    } else {
        if (gameState == 1) {
            stroke(0, 15);
            fill(0, 15);
            rect(0, 0, width, height);
            fill(r, g, b);
            Howler.volume(1);
            score += 1;
            if (!(mousePressed && mouseButton == RIGHT)) {
                if (timeSlow < timeSlowMax) {timeSlow += 0.3;};
            };
        };
    };
    for (int i=dots.size()-1; i>=0; i--) {
             Particle d = (Dot) dots.get(i);
             d.update();
             d.draw();
    }
    
    if (gameState == 0) {
        stroke(0, 15);
        fill(0, 15);
        rect(0, 0, width, height);
        Howler.volume(1);
        for (int i=dots.size()-1; i>=0; i--) {
             Particle d = (Dot) dots.get(i);
             dots.remove(i);
        }
        fill(r, g, b);
        if (played == 0) {
            textFont(myfont,60);
            textAlign(CENTER);
            text("Darkrix",width/2 + random(-3,3),height/4 + random(-3,3));
        } else {
            fill(255,0,0);
            textFont(myfont,60);
            textAlign(CENTER);
            text ("Crushed",width/2,height/4 + random(-3,3));
            fill(r, g, b);
            textFont(0,30);
            text (round(score/60) + "s in " + prevMode + " with " + prevDots + " boxes",width/2 + random(-2,2),height/2 + random(-2,2));
        };
        textFont(0,20);
        textAlign(CENTER);
        text(totalDots + " boxes",width/2 + random(-1,1),height/2 + 50 + random(-1,1));

        
        textSize(20);
        textAlign(LEFT,BOTTOM);
        switch(musicPlaying) {
            case 1:
                text ("Cycles",random(2),height + random(-2,0));
                break;
            case 2:
                text ("Boom",random(2),height + random(-2,0));
                break;
            case 3:
                text ("Tech Talk",random(2),height + random(-2,0));
                break;
            case 4:
                text ("Dubstep Light",random(2),height + random(-2,0));
                break;
            case 0:
                text ("- -",random(2),height + random(-2,0));
                break;
        }
        
        fill((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
        textSize(20);
        if (gameMode == 0) {
            NormalChance = 0.2;
            SurroundChance = 0.8;
            FullSurroundChance = 0.1;
            SurroundMissileChance = 0.9995;
            UniqueChance = 0.5;
            timeSlowMax = 300;
        };
        if (gameMode == 1) {
            NormalChance = 1;
            SurroundChance = 0;
            FullSurroundChance = 0.3;
            SurroundMissileChance = 0.999;
            UniqueChance = 1;
            timeSlowMax = 0;
        };
        if (gameMode == 2) {
            NormalChance = 1;
            SurroundChance = 1;
            FullSurroundChance = 0.1;
            SurroundMissileChance = 0.9995;
            UniqueChance = 0.5;
            timeSlowMax = 360;
        };
        textSize(40);
        textAlign(CENTER);
            if (gameMode == 0) {
                text ("Normal",width/2 + random(-2,2),(height/2.35) + random(-2,2));
            };
            if (gameMode == 1) {
                text ("Annulus",width/2 + random(-2,2),(height/2.35) + random(-2,2));
            };
            if (gameMode == 2) {
                text ("Death Duet",width/2 + random(-2,2),(height/2.35) + random(-2,2));
            };
        
        textSize(40);
        text ("ENTER to Start",width/2 + random(-1,1),height/1.5 + random(-1,1));
    };
    
    stroke((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
    fill((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
    strokeWeight(8);
    line(mouseX,mouseY,pmouseX,pmouseY);
    if (isDebug == 1) {text(mouseX + ", " + mouseY,mouseX,mouseY);}
    
    strokeWeight(1);
    
    if (gameState == 1) {
        textSize(30);
        text (round(score/60) + "s",width/2 + random(-2,2),30 + random(-2,2));
        if (switchTime > 0) {
            switchTime -= 1;
        } else {
            switchTime = random(150,200);
            r = random(50,255);
            g = random(50,255);
            b = random(50,255);
            if (random(1) > NormalChance) {
                for (int i=dots.size()-1; i>=0; i--) {
                    Particle d = (Dot) dots.get(i);
                    d.switchMode();
                };
            } else {
                if (random(1) > SurroundChance) {
                    if (gameMode == 1) {switchTime = random(290,450);} else {switchTime = random(300,600);};
                    if (random(1) > FullSurroundChance) {
                        if (gameMode == 1) {
                            surroundDia = random(50,dist(mouseX,mouseY,width/2,height/2));
                        } else {
                            surroundDia = (dist(mouseX,mouseY,width/2,height/2) - 100 + random(-50,50));
                        };
                    } else {
                        surroundDia = width;
                    };
                    for (int i=dots.size()-1; i>=0; i--) {
                        Particle d = (Dot) dots.get(i);
                        d.surroundMode();
                    };
                } else {
                    if (random(1) > UniqueChance) {
                        for (int i=dots.size()-1; i>=0; i--) {
                            Particle d = (Dot) dots.get(i);
                            d.crushMode();
                        };
                    } else {
                        for (int i=dots.size()-1; i>=0; i--) {
                            Particle d = (Dot) dots.get(i);
                            d.sweepMode();
                        };
                    };
                };
            };
        };
    };
};

void mouseClicked() {

};

void keyPressed() {
    if (gameState == 0) {
        if (key == 'w' || key == 'W') {if (totalDots < round(250*(width+height)/(1760))) {totalDots += 10;}}
        if (key == 's' || key == 'S') {if (totalDots > round(50*(width+height)/(1760))) {totalDots -= 10;}}
        if (keyCode == ENTER) {
            switchTime = 150;
            timeSlow = timeSlowMax;
            score = 0;
            gameState = 1;
            played = 1;
            prevDots = totalDots;
            switch(gameMode) {
            case 0:
                prevMode = "Normal";
                break;
            case 1:
                prevMode = "Annulus";
                break;
            case 2:
                prevMode = "Death Duet";
                break;
            };
            for (int i; i<=totalDots; i++) {
            dots.add(new Dot());
            };
        }
        if (key == ' ') {
          switch(gameMode) {
            case 0:
                gameMode = 1;
                break;
            case 1:
                gameMode = 2;
                break;
            case 2:
                gameMode = 0;
                break;
            };
        }
    }
    if (key == 'd' || key == 'D') {isDebug = 1;}
    if (key == 'm' || key == 'M') {
        hasMed = 1;
        switch(musicPlaying) {
            case 0:
                bgm[0].play();
                musicPlaying += 1;
                break;
            case 1:
                bgm[0].stop();
                bgm[1].play();
                musicPlaying += 1;
                break;
            case 2:
                bgm[1].stop();
                bgm[2].play();
                musicPlaying += 1;
                break;
            case 3:
                bgm[2].stop();
                bgm[3].play();
                musicPlaying += 1;
                break;
            case 4:
                bgm[3].stop();
                musicPlaying = 0;
                break;
        }
    };
};

class Dot {
    float x = 0.0;
    float y = 0.0;
    float vx = 0.0;
    float vy = 0.0;
    float mode = 1;
    
    Dot() {
        x = width/2;
        y = height/2;
    };
    void switchMode(){
        this.mode = round(random(0.5,4.4));
    };
    
    void surroundMode(){
            this.mode = 5;
    };
    
    void crushMode(){
        this.mode = round(random(5.5,7.4));
    };
    
    void sweepMode(){
        this.mode = round(random(7.5,9.4));
    };
    
    void timeShift (){
        if (dist((this.x + 6),(this.y + 6),mouseX,mouseY) < 200 && gameState == 1) {
            this.vx /= 1.1;
            this.vy /= 1.1;
        if (dist((this.x + 6),(this.y + 6),mouseX,mouseY) < (timeSlow/2) && gameState == 1) {
            this.vx /= 1.4;
            this.vy /= 1.4;
        };
            strokeWeight(0);
            stroke((255 - r/1.1),(255 - g/1.1),(255 - b/1.1));
            if (dist((this.x + 6),(this.y + 6),mouseX,mouseY) < 80) {stroke(255,0,0);}
            line(this.x,this.y,mouseX,mouseY);
        };
    };
    
    void draw () {
        fill(r, g, b);
        stroke(r, g, b);
        if (mousePressed && (mouseButton == RIGHT) && timeSlow > 0 && dist((this.x + 6),(this.y + 6),mouseX,mouseY) < 200) {
            fill((r-(200 - dist((this.x + 6),(this.y + 6),mouseX,mouseY))),(g-(200 - dist((this.x + 6),(this.y + 6),mouseX,mouseY))),(b-(200 - dist((this.x + 6),(this.y + 6),mouseX,mouseY))));
        };
        rect(this.x - diameter/2, this.y - diameter/2, diameter, diameter);
    };
    
    void update(){
      if (mouseX.between(this.x-6,this.x+6) && mouseY.between(this.y-6,this.y+6)) {gameState = 0; impact.play();};

      
      if (this.mode == 0) {
        this.x = width/2;
        this.y = height/2;
        this.vx = 0;
        this.vy = 0;
      }
      
      if (this.mode == 1) {
        this.vx += random(0.8) - 0.4;
        this.vx *= .96;
        this.vy += random(0.8) - 0.4;
        this.vy *= .96;
      }
      
      if (this.mode == 2) {
        if (mouseX > this.x) {this.vx += random(0.25); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.25); this.vx *= .96;};
        if (mouseY > this.y) {this.vy += random(0.25); this.vy *= .96;};
        if (mouseY < this.y) {this.vy -= random(0.25); this.vy *= .96;};
      }
      
      if (this.mode == 3) {
        if (mouseX < this.x) {this.vx += random(0.5); this.vx *= .96;};
        if (mouseX > this.x) {this.vx -= random(0.5); this.vx *= .96;};
        if (mouseY > this.y) {this.vy += random(0.5); this.vy *= .96;};
        if (mouseY < this.y) {this.vy -= random(0.5); this.vy *= .96;};
      }
      
      if (this.mode == 4) {
        if (mouseX > this.x) {this.vx += random(0.5); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.5); this.vx *= .96;};
        if (mouseY < this.y) {this.vy += random(0.5); this.vy *= .96;};
        if (mouseY > this.y) {this.vy -= random(0.5); this.vy *= .96;};
      }
      
      if (this.mode == 5) {
        if (switchTime < 50 && switchTime > 30 && surroundDia > 40) {surroundDia -= 1;};
        if (switchTime < 20) {surroundDia = 100;};
        if (dist((this.x + 6),(this.y + 6),width/2,height/2) > surroundDia) {
            if (width/2 > this.x) {this.vx += random(1.0); this.vx *= .96;};
            if (width/2 < this.x) {this.vx -= random(1.0); this.vx *= .96;};
            if (height/2 > this.y) {this.vy += random(1.0); this.vy *= .96;};
            if (height/2 < this.y) {this.vy -= random(1.0); this.vy *= .96;};
        } else {
            if (random(1) > SurroundMissileChance) {
                if (gameMode == 1) {this.mode = round(random(2.5,11.4))} else {this.mode = 10;};
            };
            if (width/2 < this.x) {this.vx += random(0.7); this.vx *= .96;};
            if (width/2 > this.x) {this.vx -= random(0.7); this.vx *= .96;};
            if (height/2 < this.y) {this.vy += random(0.7); this.vy *= .96;};
            if (height/2 > this.y) {this.vy -= random(0.7); this.vy *= .96;};
        };
      }
      
      if (this.mode == 6) {
        if (mouseX > this.x) {this.vx += random(0.35); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.35); this.vx *= .96;};
        this.vy += random(0.5);
        this.vy *= .96;
      }
      
      if (this.mode == 7) {
        if (mouseX > this.y) {this.vy += random(0.35); this.vy *= .96;};
        if (mouseX < this.y) {this.vy -= random(0.35); this.vy *= .96;};
        this.vx += random(0.5);
        this.vx *= .96;
      }
      
      if (this.mode == 8) {
        if (mouseX > this.x) {this.vx += random(0.35); this.vx *= .96;};
        if (mouseX < this.x) {this.vx -= random(0.35); this.vx *= .96;};
      }
      
      if (this.mode == 9) {
        if (mouseX > this.y) {this.vy += random(0.35); this.vy *= .96;};
        if (mouseX < this.y) {this.vy -= random(0.35); this.vy *= .96;};
      }
      
      if (this.mode == 10) {
        if (mouseX + random(-50,50) > this.x) {this.vx += random(0.8); this.vx *= .96;};
        if (mouseX + random(-50,50) < this.x) {this.vx -= random(0.8); this.vx *= .96;};
        if (mouseY + random(-50,50) > this.y) {this.vy += random(0.8); this.vy *= .96;};
        if (mouseY + random(-50,50) < this.y) {this.vy -= random(0.8); this.vy *= .96;};
      }
      
      if (this.mode == 11) {
        if (mouseX + random(-30,30) > this.x) {this.vx += random(0.7); this.vx *= .96;};
        if (mouseX + random(-30,30) < this.x) {this.vx -= random(0.7); this.vx *= .96;};
        if (mouseY + random(-30,30) > this.y) {this.vy += random(0.7); this.vy *= .96;};
        if (mouseY + random(-30,30) < this.y) {this.vy -= random(0.7); this.vy *= .96;};
      }
      
      this.x += this.vx;
      this.y += this.vy;
      
      if (this.x > width) {this.x = 0; if (this.mode == 3 || this.mode == 4) {this.mode = 2;};}
      if (this.x < 0) {this.x = width; if (this.mode == 3 || this.mode == 4) {this.mode = 2;};}
      if (this.y > height) {this.y = 0; if (this.mode == 3 || this.mode == 4) {this.mode = 2;};}
      if (this.y < 0) {this.y = height; if (this.mode == 3 || this.mode == 4) {this.mode = 2;};}
    }
}
