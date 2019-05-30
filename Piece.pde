public class Piece extends BoardItem {
  protected String pieceType;
  protected boolean isWhite;
  protected boolean isSelected;
  protected int id;
  public boolean hasMoved;
  
  public Piece(int id, int rowAt, int colAt, boolean isWhite, boolean isSelected) {
    super(rowAt, colAt);
    this.isWhite = isWhite;
    this.isSelected = isSelected;
    this.id = id;
    hasMoved = false;
  }

  void addPiece(Piece newPiece) { pieces.add( newPiece); }
  
  boolean isWhite() { return isWhite; }
  
  int getId() { return id; }
  
  boolean getSelection(){ return isSelected; }
  
  void selected() { isSelected = !isSelected; }
  
}
