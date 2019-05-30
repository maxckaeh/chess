void setup(){
 size(1900,1000);
 background(255);
 
}

void draw(){
  int repetitions = 10;
  int oX1 = 950;
  int oY1 = 200;
  int oX2 = 750;
  int oY2 = 500;
  int oX3 = 1150;
  fill(255,0,0);
  fill(255,0,0);
  drawTriangle(oX1, oY1, oX2, oY2, oX3, oY2, distance(oX1,oX2,oY1,oY2));
  fill(0);
}
 
  int midpointX(int x1, int x2) {
    return (x1+x2)/2;
  }
  int midpointY(int y1, int y2) {
    return (y1 + y2)/2;
  }
  float distance(int x1,int x2,int y1,int y2){
    return sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1));
  }
  
void drawTriangle(int x1, int y1, int x2, int y2, int x3, int y3, float distance) {
  pushMatrix();
  triangle(x1, y1, x2, y2, x3, y2);
  distance = distance(x1,x2,y1,y2);
  if(distance > 1){
    int nX1 = midpointX(x3,x2);
    int nY1 = midpointY(y2,y2);
    int nX2 = midpointX(x3,x1);
    int nY2 = midpointY(y2,y1);
    int nX3 = midpointX(x2,x1);
    int nY3 = midpointY(y1,y2);
    drawTriangle(midpointX(x3,x2),midpointY(y2,y2),midpointX(x3,x1),midpointY(y2,y1),midpointX(x2,x1),midpointY(y1,y2),distance);
    drawTriangle(midpointX(nX2,nX3),midpointY(nY2,nY2),midpointX(nX2,x1),midpointY(nY3,y2),midpointX(nX3,x1),midpointY(nY3,y1),distance);
  }
  popMatrix();
  }
