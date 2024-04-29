#lang forge

option run_sterling "t3_backroom.js"

abstract sig CellState {}
one sig Hidden, Revealed, Flagged, Ignored extends CellState {}

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
fun MAXCOL: one Int { 7 }
fun MAXROW: one Int { 7 }
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
}

-- initial board has all cells hidden
pred initial[b: Board] {
    all x: Int, y: Int | (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies { b.cells[x][y] = Hidden }
}

-- so far : a trace involves the board being wellformed and the initial board
pred game_trace {
    all board: Board | wellformed[board]
    initial[Game.first]
}

run {game_trace} for 1 Board, 1 Game, 5 Int