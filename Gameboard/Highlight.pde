public class Highlight extends BoardItem { 
  
  public Highlight(int rowAt, int colAt) {
    super(rowAt, colAt);
  }


  public void show(int xAt, int yAt, int cellSize) {
    pushMatrix();
    fill(0, 200, 0);
    //translate(xAt, yAt);
    stroke(70);
    rect(xAt, yAt, cellSize, cellSize);
    stroke(0);
    popMatrix();
  }
  
  String toString(){
     return "[" + colId + ", " + rowId + "]"; 
  }
}
