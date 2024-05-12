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
fun MAXCOL: one Int { 3 }
fun MAXROW: one Int { 3 }
-- TODO: come up with a good equation that determines the number of mines based on board dimensions
fun MAXMINES: one Int { 7 }

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
        (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW && b.mines[row][col] = 1) implies {b.cells[row][col] = Hidden}
        (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW && b.mines[row][col] = 0) implies {b.cells[row][col] = Revealed}       
    }
}

-- lose condition
pred lost[b: Board] {
    -- a loss is a trace where any mine is revealed
    some row, col : Int | (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW && b.mines[row][col] = 1) implies b.cells[row][col] = Revealed
}

-- do nothing condition - no cell state has changed. 
pred doNothing[pre, post: Board] {
  all row, col: Int | {
    post.cells[row][col] = pre.cells[row][col]
  }
}

-- what should happen when a player makes a move
pred openTile[pre, post: Board, row: Int, col: Int] {
    -- if the cell is hidden, it should be revealed
    pre.cells[row][col] = Hidden
    post.cells[row][col] = Revealed
}

-- maintain the boards previous state except for the cell that was 'clicked' on
pred maintainPreviousBoard[pre, post: Board, row: Int, col: Int] {
    all r, c: Int | (r != row || c != col) implies {
        post.cells[r][c] = pre.cells[r][c]
        post.mines[r][c] = pre.mines[r][c]
        post.adjacentMines[r][c] = pre.adjacentMines[r][c]
    }
}

-- cell does not have a mine
pred noMine[b: Board, row: Int, col: Int] {
    b.mines[row][col] = 0
}

-- so far : a trace involves the board being wellformed and the initial board
pred game_trace {
    -- all boards are wellformed
    all board: Board | { wellformed[board] }

    -- the first board is the initial board- all cells are hidden
    initial[Game.first]

    -- the first board is one with no previous board
    no prev: Board | Game.next[prev] = Game.first

    all b: Board | some Game.next[b] implies {
        one row, col: Int | {
            --maintain the previous board state
            maintainPreviousBoard[b, Game.next[b], row, col]
            --row and col does not have a mine
            noMine[b, row, col]
            --if the cell is hidden, it should be revealed
            openTile[b, Game.next[b], row, col]
        }
    }
}

-- optimizer to limit the scope of variables and improve performance
inst optimizer {
    Board = `Board0 + `Board1 + `Board2 + `Board3 + `Board4 + `Board5
    Game = `Game0
    CellState = `Hidden0 + `Revealed0 + `Ignored0
    Hidden = `Hidden0
    Revealed = `Revealed0
    Ignored = `Ignored0

    -- set up the board so that indices and values are within allowable bounds
    cells in Board -> 
                (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8) -> 
                (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8) -> 
                (Hidden + Revealed + Ignored)
    mines in Board -> 
                (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8) -> 
                (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8) -> 
                (0 + 1)
    adjacentMines in Board -> 
                (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8) -> 
                (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8) -> 
                (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8)
}

run {game_trace} for 6 Board, 1 Game for optimizer, next is linear
