#lang forge

option run_sterling "t1_backroom.js"

abstract sig CellState {}
one sig Hidden, Revealed, Flagged, Ignored extends CellState {}

sig Cell {
    curState: one CellState,
    -- 1 - has a mine, 0 - does not have a mine
    hasMine: one Int,
    -- number of adjacent mines
    adjacentMines: one Int
}

-- a board maps coordinates to cells
sig Board {
    cells: pfunc Int -> Int -> Cell
}

one sig Game {
    first: one Board, 
    next: pfunc Board -> Board
}

-- constants for rows and columns
fun MIN: one Int { 0 }
    //we can make board bigger but for now it is 4x4
fun MAXCOL: one Int { 3 }
fun MAXROW: one Int { 3 }

-- make sure that all boards are a certain size
pred wellformed[b: Board] {
    all row, col: Int | {
        let cell = b.cells[row][col] | {
            -- no cells exist beyond the defined boundaries
            (row < MIN or row > MAXROW or col < MIN or col > MAXCOL) implies cell.curState = Ignored
            -- cells within the boundaries are not in the Ignored state
            (row >= MIN and row <= MAXROW and col >= MIN and col <= MAXCOL) implies cell.curState != Ignored
        }
    }
    // all cells either have a mine (1) or do not have a mine (0)
    all cell: Cell | { cell.hasMine = 0 or cell.hasMine = 1 }
}


-- an intial board is one where no moves have been made
pred initial[b: Board] {
    all row, col: Int | {
        let cell = b.cells[row][col] | {
            -- no cells exist beyond the defined boundaries
            (row < MIN or row > MAXROW or col < MIN or col > MAXCOL) implies cell.curState = Ignored
            -- cells within the boundaries are not in the Ignored state
            (row >= MIN and row <= MAXROW and col >= MIN and col <= MAXCOL) implies cell.curState = Hidden
        }
    }
}

pred game_trace {
    all board: Board | wellformed[board]
    initial[Game.first]
}

run { game_trace } 



