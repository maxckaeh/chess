/*
  Board Class
 */
public class Board {
  int x_pos, y_pos;
  int cellSize;
  int rows, cols;
  int[][] layer;
  ArrayList<BoardItem> items;

  public Board(int x, int y, int numRows, int numCols, int cellSize) {
    x_pos = x;
    y_pos = y;
    this.cellSize = cellSize;
    rows = numRows;
    cols = numCols;
    layer = null;
    items = new ArrayList<BoardItem>();
  }

  public void addItem(BoardItem item) {
    items.add(item);
  }


  public void removeHighLights() {
    for (int i = items.size()-1; i >=0; i--) {
      if ( items.get(i) instanceof Highlight ) {
        items.remove(i);
      }
      if (i < legalMoves.size()) {
        legalMoves.remove(i);
      }
    }
  }

  public void removeItem(BoardItem item) {
    items.remove(item);
  }

  public void show() {
    pushMatrix();
    translate(x_pos, y_pos);
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        int xAt = i * cellSize;
        int yAt = j * cellSize;

        drawLayerCell(j, i, xAt, yAt);
      }
    }

    for (BoardItem item : items) {
      int xAt = item.col()*cellSize;
      int yAt = item.row()*cellSize;
      item.show(xAt, yAt, cellSize);
    }
    popMatrix();
  }

  public void printSpot() {
    println("x = " + (mouseX - x_pos) + " y = " + (mouseY - y_pos));
    println("Cell = " + getCell(mouseX, mouseY));
  }

  protected void drawLayerCell(int rowId, int colId, int xPos, int yPos) {
    if (layer != null) {
      if (layer.length > rowId) {
        if (layer[rowId].length > colId) {
          int cellColor = layer[rowId][colId];
          fill(cellColor);
          stroke(70);
          rect(xPos, yPos, cellSize, cellSize);
          stroke(0);
        }
      }
    }
  }

  public void addLayer(int[][] theLayer) {
    this.layer = theLayer;
  }

  public Cell getCell(int xClicked, int yClicked) {
    xClicked = xClicked - x_pos;
    yClicked = yClicked - y_pos;

    int xAt = xClicked/cellSize;
    int yAt = yClicked/cellSize;

    return new Cell(yAt, xAt);
  }

  public float getXAt() {
    return x_pos;
  }

  public float getYAt() {
    return y_pos;
  }
}
