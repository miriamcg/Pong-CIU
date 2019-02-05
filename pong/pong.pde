import processing.sound.*;

boolean upP1, downP1, upP2, downP2, start, firstMove, reset, winP1, winP2;
int p1Score, p2Score;
PFont font;
SoundFile hitWall;
SoundFile hitPaddle;
SoundFile missBall;
Player p1;
Player p2;
Ball ball;

void setup(){
  size(600, 600);
  
  p1 = new Player(color(255,255,255), 10, height/2, 5, 20, 80);
  p2 = new Player(color(255,255,255), width/2 + 270, height/2, 5, 20, 80);
  ball = new Ball(color(255,255,255), width/2, height/2, 4, 4, 20, 20);
  
  font = createFont("joystix.ttf", 52);
  
  hitWall = new SoundFile(this, "hit_wall.wav");
  hitPaddle = new SoundFile(this, "hit_paddle.wav");
  missBall = new SoundFile(this, "miss_ball.wav");
}

void draw(){
  background(0);
  
  //línea divisoria
  fill(255,255,255);
  for (int i = 10; i < width; i = i + 30) {
    rect(width/2, i, 10, 10);
  }
  
  textFont(font, 52);
  text(p1Score, width/2 - 90, height/2 - 250);
  text(p2Score, width/2 + 50, height/2 - 250);
  
  //línea superior
  stroke(255);
  strokeWeight(5);
  line(0, width/205, width, height/205);
  
  //línea inferior
  stroke(255);
  strokeWeight(5);
  line(0, width, width, height);
  
  p1.display();
  p2.display();
  ball.display();
  
  //En caso de que no se haya empezado la partida
  if(!start){
    if(reset){
      fill(255);
      textSize(22);
      text("Press Enter", width/2 - 220, height/2 - 200);
      text("to restart", width/2 + 30, height/2 - 200);
      if(winP1){
        text("P1 WINS!", width/2 - 170, height/2);
        text("P2 LOSES!", width/2 + 50, height/2);
      }
      if(winP2){
        text("P1 LOSES!", width/2 - 180, height/2);
        text("P2 WINS!", width/2 + 50, height/2);
      }
    }else{
      fill(255);
      textSize(22);
      text("Press Enter", width/2 - 220, height/2 - 200);
      text("to start", width/2 + 30, height/2 - 200);
      text("P1 keys ", width/2 - 160, height/2);
      text("w + s", width/2 - 160, height/2 + 20);
      text("P2 keys ", width/2 + 50, height/2);
      text("UP + DOWN", width/2 + 50, height/2 + 20);
    }
  } else {
    p1.moveP1();
    p1.restrict();
    p1.collisionP1(ball);
    p2.moveP2();
    p2.restrict();
    p2.collisionP2(ball);
    ball.move();
    victory();
  }
}

void keyPressed(){
  if (key == 'w' || key == 'W') {
    upP1 = true;
  }
  if (key == 's' || key == 'S') {
    downP1 = true;
  }
  
  if (key == CODED) {
    if (keyCode == UP) {
      upP2 = true;
    }
    if (keyCode == DOWN) {
      downP2 = true;
    }
  }
  
  if(key == ENTER){
    start = true;
    firstMove = true;
    p1Score = 0;
    p2Score = 0;
  }
}

void keyReleased(){
  if (key == 'w' || key == 'W') {
    upP1 = false;
  }
  if (key == 's' || key == 'S') {
    downP1 = false;
  }
  if (key == CODED) {
    if (keyCode == UP) {
      upP2 = false;
    }
    if (keyCode == DOWN) {
      downP2 = false;
    }
  }
}

/*
* Método para determinar la victoria de un jugador
*/
void victory(){
  if(p1Score >= 5){
    start = false;
    reset = true;
    winP1 = true;
    winP2 = false;
  } else if(p2Score >= 5){
    start = false;
    reset = true;
    winP2 = true;
    winP1 = false;
  }
}

class Player{
  color c;
  int posX; 
  int posY;
  int speed;
  int pWidth;
  int pHeight;
  
  Player(color tempC, int tempPosx, int tempPosy, int tempSpeed, int tempWidth, int tempHeight) {
    c = tempC;
    posX = tempPosx;
    posY = tempPosy;
    speed = tempSpeed;
    pWidth = tempWidth;
    pHeight = tempHeight;
  }
  
  void display(){
    noStroke();
    fill(c);
    rect(posX, posY, pWidth, pHeight);
  }
  
  void moveP1(){
    if (upP1 && start) {
      posY = posY - speed;
    } 
    if (downP1 && start) {
      posY = posY + speed;
    }
  }
  
  void moveP2(){
    if (upP2 && start) {
      posY = posY - speed;
    } 
    if (downP2 && start) {
      posY = posY + speed;
    }
  }
  
  void restrict(){
    if (posY - pHeight/4 < 0) {
      posY = posY + speed;
    }
    if (posY + pHeight/4 > width - 80) {
      posY = posY - speed;
    }
  }
  
  void collisionP1(Ball b){
    if (b.posX - width/10 < posX + pWidth/3 && b.posY - pHeight/3 < posY + pHeight/3 && b.posY + pHeight/3 > posY - pHeight/3) {
      if(b.speedX < 0){
        b.speedX = -b.speedX;
        hitPaddle.play();
      }
    }
  }
  
  void collisionP2(Ball b){
    if (b.posX + width/10 > posX - pWidth/3 && b.posY - pHeight/3 < posY + pHeight/3 && b.posY + pHeight/3 > posY - pHeight/3) {
     if(b.speedX > 0){
        b.speedX = -b.speedX;
        hitPaddle.play();
      }
    }
  }
}

class Ball{
  color c;
  float posX;
  float posY;
  int speedX;
  int speedY;
  int bWidth;
  int bHeight;
  
   Ball(color tempC, float tempPosx, float tempPosy, int tempSpeedX, int tempSpeedY, int tempWidth, int tempHeight){
    c = tempC;
    posX = tempPosx;
    posY = tempPosy;
    speedX = tempSpeedX;
    speedY = tempSpeedY;
    bWidth = tempWidth;
    bHeight = tempHeight;
  }
  
    
  void display(){
    noStroke();
    fill(c);
    rect(posX, posY, bWidth, bHeight);
  }
  
  void move(){
    if(start || reset){
      if(firstMove){
        posX = posX + speedX + random(-200, 200);
        firstMove = false;
      } else {
        posX = posX + speedX;
        posY = posY + speedY;
      }
    }
      
    if (posX > width - bWidth/2) {
       speedX =- speedX;
       p1Score += 1;
       missBall.play();
    } else if (posX < 0 + bWidth/2){
      speedX =- speedX;
      p2Score += 1;
      missBall.play();
    }
    
    if (posY > height - bHeight/2 || posY < 0 + bHeight/2) {
       speedY =- speedY;
       hitWall.play();
    }
  }
}
