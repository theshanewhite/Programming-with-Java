
float spring = 0.05;
float gravity = 0.03;
float friction = -0.95;
float secDiam = 10;
float minuteDiam = 20;
ArrayList<Ball> balls = new ArrayList<Ball>();
color nowColor;
boolean newMin = true;
boolean newHour = true;
int sec;

void setup() {
  size(640, 480);
  sec = second();
  
  for(int i = 0; i < minute(); i ++){
    nowColor = color(random(50,255),random(50,255),random(50,255));
    balls.add(new Ball(random(width), random(height), 0, minuteDiam,  nowColor, balls));
  }
  nowColor = color(random(50,255),random(50,255),random(50,255));
  for(int i = 0; i < second(); i ++){
    balls.add(new Ball(random(width), random(height), 0, secDiam,  nowColor, balls));
  }
  noStroke();
}

void draw() {
  //background(0);
  fill(0,15);
  rect(0,0,width,height);
  fill(255);
  text(hour()+":"+minute()+":"+second() + ","+balls.size(),0,15);
  
  //if(second() == 0 && minute() == 0 && newHour){
  //  balls.clear();
  //  newHour = false;
  //}
  //else if(minute() > 0){
  //  newHour = true;
  //} 
  if(second() == 0 && newMin){
    balls.add(new Ball(width-12, 50, -3, minuteDiam, nowColor, balls));
    nowColor = color(random(50,255),random(50,255),random(50,255));
    newMin = false;
  }
  else if(second() > 0){
    newMin = true;
  }
  if (sec != second()){
    balls.add(new Ball(12, 50, 3, secDiam, nowColor, balls));
  }
  for(int i = 0; i < hour(); i++){
    fill(255-map(i,0,24,0,255),map(i,0,24,0,255),150,25);
    rect(0,height - (height/24)*(1+i),width, height/24);
  }
  
  sec = second();
  Ball dead = null;
  for (Ball ball : balls) {
    ball.move();
    ball.display();
    if(dead == null)
      dead = ball.collide();
  }
  if(dead != null){
    balls.remove(dead);
  }
  
  
}

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int min;
  int hour;
  ArrayList<Ball> others;
  color col;
 
  Ball(float xin, float yin, float vxin, float din, color colin,ArrayList<Ball> oin) {
    x = xin;
    y = yin;
    diameter = din;
    others = oin;
    vx = vxin;
    vx += random(-0.5,0.5);
    col = colin;
    min = minute();
    hour = hour();
  } 
  
  int getWidth(){
    return int(diameter);
  }
  int getMin(){
    return min;
  }
  
  color getColor(){
    return col;
  }
  
  Ball collide() {
    for (int i = 0; i < others.size(); i++) {
      if(i != others.indexOf(this)){
        float dx = others.get(i).x - x;
        float dy = others.get(i).y - y;
        float distance = sqrt(dx*dx + dy*dy);
        float minDist = others.get(i).diameter/2 + diameter/2;
        if (distance < minDist) { 
          if(getWidth() > others.get(i).getWidth() && getMin()-1 == others.get(i).getMin()){
            //balls.remove(others.get(i));
            return others.get(i);
          }
          else{
            float angle = atan2(dy, dx);
            float targetX = x + cos(angle) * minDist;
            float targetY = y + sin(angle) * minDist;
            float ax = (targetX - others.get(i).x) * spring;
            float ay = (targetY - others.get(i).y) * spring;
            vx -= ax;
            vy -= ay;
            others.get(i).vx += ax;
            others.get(i).vy += ay;
          }
          
        }
        else if(y > height + 50){
            return others.get(i);
        }
      }   
    }
    return null;
  }
  
  void move() {
    
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height && hour == hour()) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    fill(col, 200);
    ellipse(x, y, diameter, diameter);
  }
}
