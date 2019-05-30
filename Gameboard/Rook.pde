class Rook extends Piece {
  int xOffSet = 5;
  int yOffSet = -5;
  boolean myColor;
  boolean selection;
  String white = "2656";
  String black = "265C";
  
  Rook(int id, int rowAt, int colAt, boolean isWhite, boolean isSelected){
    super(id, rowAt, colAt, isWhite, isSelected);
    myColor = isWhite;
    selection = isSelected;
  }

// Actually draws them depending on if they're white or black

  public void show(int xAt, int yAt, int cellSize) {
    if(myColor == true){
      showWhite(xAt, yAt, cellSize);
    } else {
      showBlack(xAt, yAt, cellSize);
    }
    
  }

// Creates both pieces

  public void showWhite(int xAt, int yAt, int cellSize) {
    pushMatrix();
    fill(255);
    translate(xAt, yAt);
    textFont(font, 70);
    textFont(font, 70);
    text(getCharFromUni(white), xOffSet, cellSize+yOffSet);
    popMatrix();
   }
  
  public void showBlack(int xAt, int yAt, int cellSize) {
    pushMatrix();
    fill(0);
    translate(xAt, yAt);
    textFont(font, 70);
    textFont(font, 70);
    text(getCharFromUni(black), xOffSet, cellSize+yOffSet);
    popMatrix();
  }
}
