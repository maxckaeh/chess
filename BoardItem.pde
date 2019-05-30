PFont font;
import java.util.ArrayList;

public class BoardItem {

  protected  int colId, rowId;
  private int maxRow, maxCol;
  protected int[][] glyphData;

  public BoardItem(int rowAt, int colAt) {
    rowId = rowAt;
    colId = colAt;
    this.maxRow = maxRow;
    this.maxCol = maxCol;
    font = loadFont("MS-Gothic-48.vlw");
  }

  public void setData(int[][] data) {
    glyphData = data;
  }

  public int row() { 
    return rowId;
  }

  public int col() { 
    return colId;
  }

  public void show(int xAt, int yAt, int cellSize) {
    fill(0);
    //Piece.show(xAt,yAt,cellSize);
  }

  public void setBonds(int rows, int cols) {
    maxRow = rows;
    maxCol = cols;
  }

  public void updateCol(int to) {
    colId = to;
  }
  
  public void updateRow(int to) {
    rowId = to;
  }

  String getCharFromUni(String uni) { 
    int n = unhex(uni); 
    String sh = new String(Character.toChars(n)); 
    return sh;
  }
}
