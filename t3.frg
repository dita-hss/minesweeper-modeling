#lang forge

option run_sterling "t3_backroom.js"

abstract sig CellState {}
one sig Hidden, Revealed, Ignored extends CellState {}

sig Board {
    cells: pfunc Int -> Int -> CellState,
    -- want to map mines to coords
    mines: pfunc Int -> Int -> Int,
    -- keep track of how many mines are adjacent to a cell
    adjacentMines: pfunc Int -> Int -> Int
}

one sig Game {
    first: one Board, 
    next: pfunc Board -> Board
}

-- constants for rows and columns
fun MIN: one Int { 0 }
-- TODO: we can make board bigger but for now it is 4x4
fun MAXCOL: one Int { 4 }
fun MAXROW: one Int { 4 }
-- TODO: come up with a good equation that determines the number of mines based on board dimensions
fun MAXMINES: one Int { 12 }

-- make sure that all boards are a certain size
pred wellformed[b: Board] {
    -- out of bounds
    all x: Int, y: Int | (x < MIN || x > MAXCOL || y < MIN || y > MAXROW) implies {b.cells[x][y] = Ignored
                                                                                    Board.mines[x][y] = 0}
                                                                                    
    -- in bounds                                                                                
    all x: Int, y: Int | (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies{ b.cells[x][y] != Ignored 
                                                                                       Board.mines[x][y] = 0 or Board.mines[x][y] = 1}
    
    -- no more than 4 mines
    #{row, col: Int | Board.mines[row][col] = 1} = MAXMINES

     -- cells will show the adjacent Mines
    all x,y: Int|(x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies{ adjacentMinesPopulate[b,x,y] }
}

-- initial board has all cells hidden
pred initial[b: Board] {
    all x: Int, y: Int | (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies { b.cells[x][y] = Hidden }
}

-- count the number of adjacent mines 
pred adjacentMinesPopulate[b:Board, row:Int, col:Int]{
    b.adjacentMines[row][col] = add[
        b.mines[row][add[col,1]],
        b.mines[row][add[col,-1]],
        b.mines[add[row,1]][col],
        b.mines[add[row,-1]][col],
        b.mines[add[row,1]][add[col,1]],
        b.mines[add[row,1]][add[col,-1]],
        b.mines[add[row,-1]][add[col,1]],
        b.mines[add[row,-1]][add[col,-1]]]
}

-- win condition
pred won[b: Board]{
    -- cells with mines are still hidden and cells without mines are revealed
    all row, col : Int | {
        (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW && b.mines[row][col] = 1) implies b.cells[row][col] = Hidden
        (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW && b.mines[row][col] = 0) implies b.cells[row][col] = Revealed       
    }
}

-- lose condition
pred lost[b: Board] {
    -- a loss is a trace where any mine is revealed
    some row, col : Int | (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW && b.mines[row][col] = 1) implies b.cells[row][col] = Revealed
}

//Gotta changed only reveals a 3by3 now but want to change to
//if clicked on a empty square with an adjacent empty square until no more adjacent empty squares
//could keep for simplicity
pred openUpBoardHelper[b: Board, row:Int, col:Int]{
    b.cells[row][add[col,1]] = Revealed
    b.cells[row][add[col,-1]] = Revealed
    b.cells[add[row,1]][col] = Revealed
    b.cells[add[row,-1]][col] = Revealed
    b.cells[add[row,1]][add[col,1]] = Revealed
    b.cells[add[row,1]][add[col,-1]] = Revealed
    b.cells[add[row,-1]][add[col,1]] = Revealed
    b.cells[add[row,-1]][add[col,-1]] = Revealed
}

-- do nothing condition - no cell state has changed. 
pred doNothing[pre, post: Board] {
  all row, col: Int | {
    post.cells[row][col] = pre.cells[row][col]
  }
}

-- so far : a trace involves the board being wellformed and the initial board
pred game_trace {
    all board: Board | wellformed[board]
    initial[Game.first]
}

run {game_trace} for 1 Board, 1 Game, 5 Int