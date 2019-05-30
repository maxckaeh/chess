import java.util.ArrayList;

Board theBoard;
ArrayList<Pawn> pWhite, pBlack;
ArrayList<Rook> rWhite, rBlack;
ArrayList<Knight> kWhite, kBlack;
ArrayList<Bishop> bWhite, bBlack;
ArrayList<Queen> qWhite, qBlack;
ArrayList<King> kiWhite, kiBlack;
ArrayList<Highlight> legalMoves;
ArrayList<Piece> pieces;
boolean whitesTurn;
int turnCounter;
Piece selected;

//Creating the board

color c1 = color(108, 108, 108);
color c2 = color(185, 185, 185);

int[][] layer = {
  {c2, c1, c2, c1, c2, c1, c2, c1 }, 
  {c1, c2, c1, c2, c1, c2, c1, c2 }, 
  {c2, c1, c2, c1, c2, c1, c2, c1 }, 
  {c1, c2, c1, c2, c1, c2, c1, c2 }, 
  {c2, c1, c2, c1, c2, c1, c2, c1 }, 
  {c1, c2, c1, c2, c1, c2, c1, c2 }, 
  {c2, c1, c2, c1, c2, c1, c2, c1 }, 
  {c1, c2, c1, c2, c1, c2, c1, c2 }, 
};
void setup() {
  size(1900, 1250);

  theBoard = new Board(width/6, height/6, 8, 8, 80);

  whitesTurn = true;
  turnCounter = 1;

  // Setting up all of the pieces
  //********************************************************************************************

  pieces = new ArrayList<Piece>();
  legalMoves = new ArrayList<Highlight>();

  pWhite = new ArrayList<Pawn>();
  for (int i = 0; i < 8; i++ ) {
    Pawn p = new Pawn(i+1, 6, i, true, false);
    theBoard.addItem(p);
    pieces.add(p);
    pWhite.add(p);
  }

  pBlack = new ArrayList<Pawn>();
  for (int i = 0; i < 8; i++ ) {
    Pawn p = new Pawn(i+1, 1, i, false, false);
    theBoard.addItem(p);
    pieces.add(p);
    pBlack.add(p);
  }

  rWhite = new ArrayList<Rook>();
  for (int i = 0; i < 2; i++ ) {
    Rook r = new Rook(i+1, 7, i*7, true, false);
    theBoard.addItem(r);
    pieces.add(r);
    rWhite.add(r);
  }

  rBlack = new ArrayList<Rook>();
  for (int i = 0; i < 2; i++ ) {
    Rook r = new Rook(i+1, 0, i*7, false, false);
    theBoard.addItem(r);
    pieces.add(r);
    rBlack.add(r);
  }

  kWhite = new ArrayList<Knight>();
  for (int i = 0; i < 2; i++ ) {
    Knight k = new Knight(i+1, 7, (i*5)+1, true, false);
    theBoard.addItem(k);
    pieces.add(k);
    kWhite.add(k);
  }
  kBlack = new ArrayList<Knight>();
  for (int i = 0; i < 2; i++ ) {
    Knight k = new Knight(i+1, 0, (i*5)+1, false, false);
    theBoard.addItem(k);
    pieces.add(k);
    kBlack.add(k);
  }

  bWhite = new ArrayList<Bishop>();
  for (int i = 0; i < 2; i++ ) {
    Bishop b = new Bishop(i+1, 7, (i*3)+2, true, false);
    theBoard.addItem(b);
    pieces.add(b);
    bWhite.add(b);
  }
  bBlack = new ArrayList<Bishop>();
  for (int i = 0; i < 2; i++ ) {
    Bishop b = new Bishop(i+1, 0, (i*3)+2, false, false);
    theBoard.addItem(b);
    pieces.add(b);
    bBlack.add(b);
  }

  qWhite = new ArrayList<Queen>();
  Queen qW = new Queen(1, 7, 3, true, false);
  theBoard.addItem(qW);
  pieces.add(qW);
  qWhite.add(qW);

  qBlack = new ArrayList<Queen>();
  Queen qB = new Queen(1, 0, 3, false, false);
  theBoard.addItem(qB);
  pieces.add(qB);
  qBlack.add(qB);

  kiWhite = new ArrayList<King>();
  King kW = new King(1, 7, 4, true, false);
  theBoard.addItem(kW);
  pieces.add(kW);
  kiWhite.add(kW);

  kiBlack = new ArrayList<King>();
  King kB = new King(1, 0, 4, false, false);
  theBoard.addItem(kB);
  pieces.add(kB);
  kiBlack.add(kB);
}

void draw() {
  background(255);
  theBoard.show();
  theBoard.addLayer( layer );
  standardSelection();
}

void mousePressed() {
  Cell cellClicked = theBoard.getCell(mouseX, mouseY);
  // If there are highlighted tiles already on the board, this executes (Finalizes piece movement)
  // ****************************************************************************************************************************************  

  if (legalMoves.size() > 0) {
    for (Highlight h : legalMoves) {
      if (cellClicked.rowID() == h.row() && cellClicked.colID() == h.col()) {
        selected.updateRow(cellClicked.rowID());
        selected.updateCol(cellClicked.colID());
        for (int i = pieces.size()-1; i >= 0; i--) {
          Piece p = pieces.get(i);
          if (selected.row() == p.row() && selected.col() == p.col() && (p != selected)) {
            eliminator(p);
          }
        }
        selected.hasMoved = true;
        whitesTurn = !whitesTurn;
        turnCounter++;
      }
    }
    wipeAllHighlights();
    // In other circumstances, this is standard movement.
    //*******************************************************************************************************************************************
  } else {
    for (Piece p : pieces) {
      if ((cellClicked.rowID() == p.row() && cellClicked.colID() == p.col()) && correctTurn(p.isWhite(), whitesTurn)) {
        selected = p;
        if (selected instanceof Pawn) {
          legalPawnMoves(selected);
        }
        if (selected instanceof Rook) {
          legalRookMoves(selected);
        }
        if (selected instanceof Knight) {
          legalKnightMoves(selected);
        }
        if (selected instanceof Bishop) {
          legalBishopMoves(selected);
        }
        if (selected instanceof Queen) {
          legalQueenMoves(selected);
        }
        if (selected instanceof King) {
          legalKingMoves(selected);
        }
      }
    }
  }
}

//Movement methods
//*******************************************************************************************************

void legalPawnMoves(Piece p) {
  println("Pawn Selected!");
  p.isSelected = true;
  boolean flag = false;
  // This happens if the piece is white
  if (p.isWhite()) {
    for (Piece ps : pieces) {
      if (p.row()-1 == ps.row() && p.col() == ps.col() || p.row()-1 < 0 ) {
        flag = true;
        break;
      }
    }
    if (!flag) {
      Highlight move1 = new Highlight(p.row()-1, p.col());
      theBoard.addItem(move1);
      legalMoves.add(move1);
    }
    for (Piece ps : pieces) {
      if ((p.row()-2 == ps.row() && p.col() == ps.col()) || p.row()-2 < 0 ) {
        flag = true;
        break;
      }
    }
    if (!flag && !p.hasMoved) {
      Highlight move2 = new Highlight(p.row()-2, p.col());
      theBoard.addItem(move2);
      legalMoves.add(move2);
    }
    for (Piece ps : pieces) {
      if ((p.row()-1 == ps.row() && p.col()-1 == ps.col()) && !colorChecker(p, ps)) {
        Highlight move3 = new Highlight(p.row()-1, p.col()-1);
        theBoard.addItem(move3);
        legalMoves.add(move3);
        break;
      }
    }
    for (Piece ps : pieces) {
      if (p.row()-1 == ps.row() && p.col()+1 == ps.col() && !colorChecker(p, ps)) {
        Highlight move4 = new Highlight(p.row()-1, p.col()+1);
        theBoard.addItem(move4);
        legalMoves.add(move4);
        break;
      }
    }
    // Otherwise, this happens if the piece is black
  } else {
    for (Piece ps : pieces) {
      if (p.row()+1 == ps.row() && p.col() == ps.col() || p.row()+1 >= 8 ) {
        flag = true;
        break;
      }
    }
    if (!flag) {
      Highlight move1 = new Highlight(p.row()+1, p.col());
      theBoard.addItem(move1);
      legalMoves.add(move1);
    }
    for (Piece ps : pieces) {
      if (p.row()+2 == ps.row() && p.col() == ps.col() || p.row()+2 >= 8 ) {
        flag = true;
        break;
      }
    }
    if (!flag && !p.hasMoved) {
      Highlight move2 = new Highlight(p.row()+2, p.col());
      theBoard.addItem(move2);
      legalMoves.add(move2);
    }
    for (Piece ps : pieces) {
      if (p.row()+1 == ps.row() && p.col()-1 == ps.col()  && !colorChecker(p, ps)) {
        Highlight move3 = new Highlight(p.row()+1, p.col()-1);
        theBoard.addItem(move3);
        legalMoves.add(move3);
        break;
      }
    }
    for (Piece ps : pieces) {
      if (p.row()+1 == ps.row() && p.col()+1 == ps.col()  && !colorChecker(p, ps)) {
        Highlight move4 = new Highlight(p.row()+1, p.col()+1);
        theBoard.addItem(move4);
        legalMoves.add(move4);
        break;
      }
    }
  }
}



void legalRookMoves(Piece p) {
  println("Rook selected!");
  boolean flag1 = false;
  boolean flag2 = false;
  boolean flag3 = false;
  boolean flag4 = false;
  // This is for the bottom pieces
loopY1:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()+i == ps.row() && p.col() == ps.col()) || p.row() +i > 7) {
        if (!colorChecker(p, ps) && !(p.row()+i > 7)) {
          Highlight move = new Highlight(p.row()+i, p.col());
          theBoard.addItem(move);
          legalMoves.add(move);
        }
        flag1 = true;
        break loopY1;
      }
    }
    if (!flag1) {
      Highlight move = new Highlight(p.row()+i, p.col());
      theBoard.addItem(move);
      legalMoves.add(move);
    }
  }
  // This is for the top pieces
loopY2:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()-i == ps.row() && p.col() == ps.col()) || p.row() -i < 0) {
        if (!colorChecker(p, ps) && !(p.row() -i < 0)) {
          Highlight move2 = new Highlight(p.row()-i, p.col());
          theBoard.addItem(move2);
          legalMoves.add(move2);
        }
        flag2= true;
        break loopY2;
      }
    }
    if (!flag2) {
      Highlight move2 = new Highlight(p.row()-i, p.col());
      theBoard.addItem(move2);
      legalMoves.add(move2);
      //theBoard.printSpot();
    }
  }
loopX1:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row() == ps.row() && p.col()-i == ps.col()) || p.col()-i < 0) {
        if (!colorChecker(p, ps) && !(p.col()-i < 0)) {
          Highlight move3 = new Highlight(p.row(), p.col()-i);
          theBoard.addItem(move3);
          legalMoves.add(move3);
        }
        flag3 = true;
        break loopX1;
      }
    }
    if (!flag3) {
      Highlight move3 = new Highlight(p.row(), p.col()-i);
      theBoard.addItem(move3);
      legalMoves.add(move3);
    }
  }
loopX2:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row() == ps.row() && p.col()+i == ps.col()) || p.col()+i > 7) {
        if (!colorChecker(p, ps) && !(p.col()+i > 7)) {
          Highlight move4 = new Highlight(p.row(), p.col()+i);
          theBoard.addItem(move4);
          legalMoves.add(move4);
        }
        flag4 = true;
        break loopX2;
      }
    }
    if (!flag4) {
      Highlight move4 = new Highlight(p.row(), p.col()+i);
      theBoard.addItem(move4);
      legalMoves.add(move4);
    }
  }
}

void legalKnightMoves(Piece p) {
  println("Knight Selected!");
  boolean flag1 = false;
  boolean flag2 = false;
  boolean flag3 = false;
  boolean flag4 = false;
  boolean flag5 = false;
  boolean flag6 = false;
  boolean flag7 = false;
  boolean flag8 = false;
  // This happens if the piece is white
  //********************************************************************************
  for (Piece ps : pieces) {
    if (p.row()-1 == ps.row() && p.col()-2 == ps.col() && colorChecker(p, ps) || p.row()-1 < 0 || p.col()-2 < 0) {
      flag1 = true;
      break;
    }
  }
  if (!flag1) {
    Highlight move1 = new Highlight(p.row()-1, p.col()-2);
    theBoard.addItem(move1);
    legalMoves.add(move1);
  }
  for (Piece ps : pieces) {
    if (p.row()-2 == ps.row() && p.col()-1 == ps.col() && colorChecker(p, ps) || p.row()-2 < 0 || p.col()-1 < 0) {
      flag2 = true;
      break;
    }
  }
  if (!flag2) {
    Highlight move2 = new Highlight(p.row()-2, p.col()-1);
    theBoard.addItem(move2);
    legalMoves.add(move2);
  }
  for (Piece ps : pieces) {
    if (p.row()+1 == ps.row() && p.col()-2 == ps.col() && colorChecker(p, ps) || p.row()+1 >= 8 || p.col()-2 < 0) {
      flag3 = true;
      break;
    }
  }
  if (!flag3) {
    Highlight move3 = new Highlight(p.row()+1, p.col()-2);
    theBoard.addItem(move3);
    legalMoves.add(move3);
  }
  for (Piece ps : pieces) {
    if (p.row()+2 == ps.row() && p.col()-1 == ps.col() && colorChecker(p, ps) || p.row()+2 > 8 || p.col()-1 < 0) {
      flag4 = true;
      break;
    }
  }
  if (!flag4) {
    Highlight move4 = new Highlight(p.row()+2, p.col()-1);
    theBoard.addItem(move4);
    legalMoves.add(move4);
  }
  for (Piece ps : pieces) {
    if (p.row()-1 == ps.row() && p.col()+2 == ps.col() && colorChecker(p, ps) || p.row()-1 < 0 || p.col()+2 >= 8) {
      flag5 = true;
      break;
    }
  }
  if (!flag5) {
    Highlight move1 = new Highlight(p.row()-1, p.col()+2);
    theBoard.addItem(move1);
    legalMoves.add(move1);
  }
  for (Piece ps : pieces) {
    if (p.row()-2 == ps.row() && p.col()+1 == ps.col() && colorChecker(p, ps) || p.row()-2 < 0 || p.col()+1 >= 8) {
      flag6 = true;
      break;
    }
  }
  if (!flag6) {
    Highlight move2 = new Highlight(p.row()-2, p.col()+1);
    theBoard.addItem(move2);
    legalMoves.add(move2);
  }
  for (Piece ps : pieces) {
    if (p.row()+1 == ps.row() && p.col()+2 == ps.col() && colorChecker(p, ps) || p.row()+1 >= 8 || p.col()+2 >= 8) {
      flag7 = true;
      break;
    }
  }
  if (!flag7) {
    Highlight move3 = new Highlight(p.row()+1, p.col()+2);
    theBoard.addItem(move3);
    legalMoves.add(move3);
  }
  for (Piece ps : pieces) {
    if (p.row()+2 == ps.row() && p.col()+1 == ps.col() && colorChecker(p, ps) || p.row()+2 > 8 || p.col()+1 >= 8) {
      flag8 = true;
      break;
    }
  }
  if (!flag8) {
    Highlight move4 = new Highlight(p.row()+2, p.col()+1);
    theBoard.addItem(move4);
    legalMoves.add(move4);
  }
}

void legalBishopMoves(Piece p) {
  println("Bishop selected!");
  boolean flag1 = false;
  boolean flag2 = false;
  boolean flag3 = false;
  boolean flag4 = false;
  // This is for the bottom pieces
loop1:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()+i == ps.row() && p.col()+i == ps.col()) || p.row()+i > 7 || p.col()+i > 7) {
        if (!colorChecker(p, ps) && !(p.row()+i > 7 || p.col()+i > 7)) {
          Highlight move = new Highlight(p.row()+i, p.col()+i);
          theBoard.addItem(move);
          legalMoves.add(move);
        }
        flag1 = true;
        break loop1;
      }
    }
    if (!flag1) {
      Highlight move = new Highlight(p.row()+i, p.col()+i);
      theBoard.addItem(move);
      legalMoves.add(move);
    }
  }
  // This is for the top pieces
loop2:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()-i == ps.row() && p.col()+i == ps.col()) || p.row()-i < 0 || p.col()+i > 7) {
        if (!colorChecker(p, ps) && !(p.row()-i < 0 || p.col()+i > 7)) {
          Highlight move2 = new Highlight(p.row()-i, p.col()+i);
          theBoard.addItem(move2);
          legalMoves.add(move2);
        }
        flag2= true;
        break loop2;
      }
    }
    if (!flag2) {
      Highlight move2 = new Highlight(p.row()-i, p.col()+i);
      theBoard.addItem(move2);
      legalMoves.add(move2);
    }
  }
loop3:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()+i == ps.row() && p.col()-i == ps.col()) || p.col()-i < 0 || p.row()+i > 7) {
        if (!colorChecker(p, ps) && !(p.col()-i < 0 || p.row()+i > 7)) {
          Highlight move3 = new Highlight(p.row()+i, p.col()-i);
          theBoard.addItem(move3);
          legalMoves.add(move3);
        }
        flag3 = true;
        break loop3;
      }
    }
    if (!flag3) {
      Highlight move3 = new Highlight(p.row()+i, p.col()-i);
      theBoard.addItem(move3);
      legalMoves.add(move3);
    }
  }
loop4:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()-i == ps.row() && p.col()-i == ps.col()) || p.col()-i < 0 || p.row()-i < 0) {
        if (!colorChecker(p, ps) && !(p.col()-i < 0 || p.row()-i < 0)) {
          Highlight move4 = new Highlight(p.row()-i, p.col()-i);
          theBoard.addItem(move4);
          legalMoves.add(move4);
        }
        flag4 = true;
        break loop4;
      }
    }
    if (!flag4) {
      Highlight move4 = new Highlight(p.row()-i, p.col()-i);
      theBoard.addItem(move4);
      legalMoves.add(move4);
    }
  }
} 

void legalQueenMoves(Piece p) {
  println("Queen selected!");
  boolean flag1 = false;
  boolean flag2 = false;
  boolean flag3 = false;
  boolean flag4 = false;
  boolean flag5 = false;
  boolean flag6 = false;
  boolean flag7 = false;
  boolean flag8 = false;
  // This is for the bottom pieces
loop1:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()+i == ps.row() && p.col()+i == ps.col()) || p.row()+i > 7 || p.col()+i > 7) {
        if (!colorChecker(p, ps) && !(p.row()+i > 7 || p.col()+i > 7)) {
          Highlight move = new Highlight(p.row()+i, p.col()+i);
          theBoard.addItem(move);
          legalMoves.add(move);
        }
        flag1 = true;
        break loop1;
      }
    }
    if (!flag1) {
      Highlight move = new Highlight(p.row()+i, p.col()+i);
      theBoard.addItem(move);
      legalMoves.add(move);
    }
  }
  // This is for the top pieces
loop2:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()-i == ps.row() && p.col()+i == ps.col()) || p.row()-i < 0 || p.col()+i > 7) {
        if (!colorChecker(p, ps) && !(p.row()-i < 0 || p.col()+i > 7)) {
          Highlight move2 = new Highlight(p.row()-i, p.col()+i);
          theBoard.addItem(move2);
          legalMoves.add(move2);
        }
        flag2= true;
        break loop2;
      }
    }
    if (!flag2) {
      Highlight move2 = new Highlight(p.row()-i, p.col()+i);
      theBoard.addItem(move2);
      legalMoves.add(move2);
    }
  }
loop3:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()+i == ps.row() && p.col()-i == ps.col()) || p.col()-i < 0 || p.row()+i > 7) {
        if (!colorChecker(p, ps) && !(p.col()-i < 0 || p.row()+i > 7)) {
          Highlight move3 = new Highlight(p.row()+i, p.col()-i);
          theBoard.addItem(move3);
          legalMoves.add(move3);
        }
        flag3 = true;
        break loop3;
      }
    }
    if (!flag3) {
      Highlight move3 = new Highlight(p.row()+i, p.col()-i);
      theBoard.addItem(move3);
      legalMoves.add(move3);
    }
  }
loop4:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()-i == ps.row() && p.col()-i == ps.col()) || p.col()-i < 0 || p.row()-i < 0) {
        if (!colorChecker(p, ps) && !(p.col()-i < 0 || p.row()-i < 0)) {
          Highlight move4 = new Highlight(p.row()-i, p.col()-i);
          theBoard.addItem(move4);
          legalMoves.add(move4);
        }
        flag4 = true;
        break loop4;
      }
    }
    if (!flag4) {
      Highlight move4 = new Highlight(p.row()-i, p.col()-i);
      theBoard.addItem(move4);
      legalMoves.add(move4);
    }
  }
loopY1:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()+i == ps.row() && p.col() == ps.col()) || p.row() +i > 7) {
        if (!colorChecker(p, ps) && !(p.row() +i > 7)) {
          Highlight move5 = new Highlight(p.row()+i, p.col());
          theBoard.addItem(move5);
          legalMoves.add(move5);
        }
        flag5 = true;
        break loopY1;
      }
    }
    if (!flag5) {
      Highlight move5 = new Highlight(p.row()+i, p.col());
      theBoard.addItem(move5);
      legalMoves.add(move5);
    }
  }
  // This is for the top pieces
loopY2:
  for (int i = 1; i <= 8; i++) {
    for (Piece ps : pieces) {
      if ((p.row()-i == ps.row() && p.col() == ps.col()) || p.row() -i < 0) {
        if (!colorChecker(p, ps) && !(p.row() -i < 0)) {
          Highlight move6 = new Highlight(p.row()-i, p.col());
          theBoard.addItem(move6);
          legalMoves.add(move6);
        }
        flag6 = true;
        break loopY2;
      }
    }
    if (!flag6) {
      Highlight move6 = new Highlight(p.row()-i, p.col());
      theBoard.addItem(move6);
      legalMoves.add(move6);
    }
  }
loopX1:
  for (int i = 1; i <= 7; i++) {
    for (Piece ps : pieces) {
      if ((p.row() == ps.row() && p.col()-i == ps.col()) || p.col()-i < 0) {
        if (!colorChecker(p, ps) && !(p.col()-i < 0)) {
          Highlight move7 = new Highlight(p.row(), p.col()-i);
          theBoard.addItem(move7);
          legalMoves.add(move7);
        }
        flag7 = true;
        break loopX1;
      }
    }
    if (!flag7) {
      Highlight move7 = new Highlight(p.row(), p.col()-i);
      theBoard.addItem(move7);
      legalMoves.add(move7);
    }
  }
loopX2:
  for (int i = 1; i <= 7; i++) {
    for (Piece ps : pieces) {
      if ((p.row() == ps.row() && p.col()+i == ps.col()) || p.col()+i > 7) {
        if (!colorChecker(p, ps) && !(p.col()+i > 7)) {
          Highlight move8 = new Highlight(p.row(), p.col()+i);
          theBoard.addItem(move8);
          legalMoves.add(move8);
        }
        flag8 = true;
        break loopX2;
      }
    }
    if (!flag8) {
      Highlight move8 = new Highlight(p.row(), p.col()+i);
      theBoard.addItem(move8);
      legalMoves.add(move8);
    }
  }
} 

void legalKingMoves(Piece p) {
  println("King Selected!");
  boolean flag1 = false;
  boolean flag2 = false;
  boolean flag3 = false;
  boolean flag4 = false;
  boolean flag5 = false;
  boolean flag6 = false;
  boolean flag7 = false;
  boolean flag8 = false;
  // This happens if the piece is white
  //********************************************************************************
  if (p.isWhite()) {
    Piece r = rWhite.get(1);
    castleKing(p, r);
    Piece r2 = rWhite.get(0);
    castleQueen(p, r2);
  } else {
    Piece r = rBlack.get(1);
    castleKing(p, r);
    Piece r2 = rBlack.get(0);
    castleQueen(p, r2);
  }

  for (Piece ps : pieces) {
    if (p.row()-1 == ps.row() && p.col()-1 == ps.col() && colorChecker(p, ps) || p.row()-1 < 0 || p.col()-1 < 0) {
      flag1 = true;
      break;
    }
  }
  if (!flag1) {
    Highlight move1 = new Highlight(p.row()-1, p.col()-1);
    theBoard.addItem(move1);
    legalMoves.add(move1);
  }
  for (Piece ps : pieces) {
    if (p.row()-1 == ps.row() && p.col() == ps.col() && colorChecker(p, ps) || p.row()-1 < 0) {
      flag2 = true;
      break;
    }
  }
  if (!flag2) {
    Highlight move2 = new Highlight(p.row()-1, p.col());
    theBoard.addItem(move2);
    legalMoves.add(move2);
  }
  for (Piece ps : pieces) {
    if (p.row()-1 == ps.row() && p.col()+1 == ps.col() && colorChecker(p, ps) || p.row()-1 < 0 || p.col()+1 >= 8) {
      flag3 = true;
      break;
    }
  }
  if (!flag3) {
    Highlight move3 = new Highlight(p.row()-1, p.col()+1);
    theBoard.addItem(move3);
    legalMoves.add(move3);
  }
  for (Piece ps : pieces) {
    if (p.row() == ps.row() && p.col()-1 == ps.col() && colorChecker(p, ps) || p.col()-1 < 0) {
      flag4 = true;
      break;
    }
  }
  if (!flag4) {
    Highlight move4 = new Highlight(p.row(), p.col()-1);
    theBoard.addItem(move4);
    legalMoves.add(move4);
  }
  for (Piece ps : pieces) {
    if (p.row() == ps.row() && p.col()+1 == ps.col() && colorChecker(p, ps) || p.col()+1 >= 8) {
      flag5 = true;
      break;
    }
  }
  if (!flag5) {
    Highlight move1 = new Highlight(p.row(), p.col()+1);
    theBoard.addItem(move1);
    legalMoves.add(move1);
  }
  for (Piece ps : pieces) {
    if (p.row()+1 == ps.row() && p.col()-1 == ps.col() && colorChecker(p, ps) || p.row()+1 >= 8 || p.col()-1 < 0) {
      flag6 = true;
      break;
    }
  }
  if (!flag6) {
    Highlight move2 = new Highlight(p.row()+1, p.col()-1);
    theBoard.addItem(move2);
    legalMoves.add(move2);
  }
  for (Piece ps : pieces) {
    if (p.row()+1 == ps.row() && p.col() == ps.col() && colorChecker(p, ps) || p.row()+1 >= 8) {
      flag7 = true;
      break;
    }
  }
  if (!flag7) {
    Highlight move3 = new Highlight(p.row()+1, p.col());
    theBoard.addItem(move3);
    legalMoves.add(move3);
  }
  for (Piece ps : pieces) {
    if (p.row()+1 == ps.row() && p.col()+1 == ps.col() && colorChecker(p, ps) || p.row()+1 >= 8 || p.col()+1 >= 8) {
      flag8 = true;
      break;
    }
  }
  if (!flag8) {
    Highlight move4 = new Highlight(p.row()+1, p.col()+1);
    theBoard.addItem(move4);
    legalMoves.add(move4);
  }
} 

void wipeAllHighlights() {
  theBoard.removeHighLights();
}

// Changes the cursor depending on if the mouse is over a playable piece
//***************************************************************************************************************
boolean hotZone = false;

void standardSelection() {
  Cell mouseAt = theBoard.getCell(mouseX, mouseY);
  if (!hotZone)
    cursor(ARROW);
  for (Piece p : pieces) {
    if (correctTurn(p.isWhite(), whitesTurn)) {
      if ((mouseAt.rowID() == p.row() && mouseAt.colID() == p.col())) {
        cursor(HAND);
        hotZone = true;
        return;
      }
    }
  }
  hotZone = false;
}

boolean legalZone = false;

// Checks to see if the turn number and color match
// ***************************************************************************************************

boolean correctTurn(boolean pieceTurn, boolean turnColor) {
  if ((pieceTurn && turnColor) || (!pieceTurn && !turnColor)) {
    return true;
  } else {
    return false;
  }
}


// Checks if two pieces are the same color or not.
// **************************************************************************
boolean colorChecker(Piece piece1, Piece piece2) {
  if (piece1.isWhite() && piece2.isWhite()) {
    return true;
  } else if (!piece1.isWhite() && !piece2.isWhite()) {
    return true;
  } else {
    return false;
  }
}

// Removes the piece from the board depending on its color and type
// *************************************************************************
void eliminator(Piece p) {
  pieces.remove(p);
  theBoard.removeItem(p);
  if (p instanceof Pawn) {
    if (!p.isWhite()) {
      pBlack.remove(p);
    } else {
      pWhite.remove(p);
    }
  }
  if (p instanceof Rook) {
    if (!p.isWhite()) {
      rBlack.remove(p);
      if (selected instanceof King) {
        Rook r = new Rook(2, 0, 4, false, false);
        theBoard.addItem(r);
        pieces.add(r);
        rBlack.add(r);
      }
    } else {
      rWhite.remove(p);
      if (selected instanceof King) {
        Rook r = new Rook(2, 7, 4, true, false);
        theBoard.addItem(r);
        pieces.add(r);
        rWhite.add(r);
      }
    }
  }
  if (p instanceof Knight) {
    if (!p.isWhite()) {
      kBlack.remove(p);
    } else {
      kWhite.remove(p);
    }
  }
  if (p instanceof Bishop) {
    if (!p.isWhite()) {
      bBlack.remove(p);
    } else {
      bWhite.remove(p);
    }
  }
  if (p instanceof Queen) {
    if (!p.isWhite()) {
      qBlack.remove(p);
    } else {
      qWhite.remove(p);
    }
  }
  if (p instanceof King) {
    if (!p.isWhite()) {
      kiBlack.remove(p);
      println("GAME OVER.");
    } else {
      kiWhite.remove(p);
      println("GAME OVER.");
    }
  }
}

//Castling moves

void castleKing(Piece p, Piece p2) {
  boolean flag = false;
  if (!p.hasMoved && !p2.hasMoved) {
    for (Piece ps : pieces) {
      for (int i = 1; i < 3; i++)
        if (p.row() == ps.row() && p.col()+i == ps.col() && !(ps instanceof Rook)) {
          println("Error.");
          flag = true;
          break;
        }
    }
    if (!flag) {
      Highlight moveC = new Highlight(p2.row(), p2.col());
      theBoard.addItem(moveC);
      legalMoves.add(moveC);
    }
  }
}

void castleQueen(Piece p, Piece p2) {
  boolean flag = false;
  if (!p.hasMoved && !p2.hasMoved) {
    for (Piece ps : pieces) {
      for (int i = 1; i < 4; i++)
        if (p.row() == ps.row() && p.col()-i == ps.col() && !(ps instanceof Rook)) {
          println("Error.");
          flag = true;
          break;
        }
    }
    if (!flag) {
      Highlight moveC = new Highlight(p2.row(), p2.col());
      theBoard.addItem(moveC);
      legalMoves.add(moveC);
    }
  }
}
