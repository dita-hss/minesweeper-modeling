#lang forge

option run_sterling "t2_backroom.js"

abstract sig CellState {}
one sig Hidden, Revealed, Flagged, Ignored extends CellState {}

one sig SolutionBoard {
    -- want to map mines to coords
    mines: pfunc Int -> Int -> Int,
    -- keep track of how many mines are adjacent to a cell
    adjacentMines: pfunc Int -> Int -> Int
}

sig Board {
    cells: pfunc Int -> Int -> CellState
}

one sig Game {
    first: one Board, 
    next: pfunc Board -> Board,
    solution: one SolutionBoard
}

-- constants for rows and columns
fun MIN: one Int { 0 }
-- TODO: we can make board bigger but for now it is 4x4
fun MAXCOL: one Int { 3 }
fun MAXROW: one Int { 3 }
-- TODO: come up with a good equation that determines the number of mines based on board dimensions
fun MAXBOMBS: one Int { 4 }

-- make sure that all boards are a certain size
pred wellformed[b: Board] {
    -- out of bounds
    all x: Int, y: Int | (x < MIN || x > MAXCOL || y < MIN || y > MAXROW) implies {b.cells[x][y] = Ignored
                                                                                    SolutionBoard.mines[x][y] = 0}
                                                                                    
    -- in bounds                                                                                
    all x: Int, y: Int | (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies{ b.cells[x][y] != Ignored 
                                                                                       SolutionBoard.mines[x][y] = 0 or SolutionBoard.mines[x][y] = 1}
    
    -- no more than 4 mines
    #{row, col: Int | SolutionBoard.mines[row][col] = 1} = MAXBOMBS
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

run {game_trace}