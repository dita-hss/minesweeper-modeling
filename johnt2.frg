#lang forge

option run_sterling "t2_backroom.js"

abstract sig CellState {}
one sig Hidden, Revealed, Ignored extends CellState {}

sig Board {
    cells: pfunc Int -> Int -> CellState,
    mines: pfunc Int -> Int -> Int,
    adjacentMines: pfunc Int -> Int -> Int
}

//For Trace
one sig MineSweeper{
    initial: one Board,
    next: pfunc Board -> Board
}

-- constants for rows and columns
fun MIN: one Int { 0 }
-- TODO: we can make board bigger but for now it is 4x4
fun MAXCOL: one Int { 3 }
fun MAXROW: one Int { 3 }
-- TODO: come up with a good equation that determines the number of mines based on board dimensions 
-- John comment do not know how to do this (division), but usually for minesweeper, for every 5 to 7 squares there is a mine 
fun MAXMINES: one Int { 7 }

-- make sure that all boards are a certain size

pred wellformedAfterInitial[b: Board] {
    -- out of bounds
    all x: Int, y: Int | (x < MIN || x > MAXCOL || y < MIN || y > MAXROW) implies {b.cells[x][y] = Ignored and b.mines[x][y] = 0}                                                     
    -- in bounds                                                                                
    all x: Int, y: Int | (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies{b.cells[x][y] != Ignored and b.mines[x][y] = 0 or b.mines[x][y] = 1}
    -- no more than 4 mines
    #{x, y: Int | b.mines[x][y] = 1} = MAXMINES
    -- cells will show the adjacent Mines
    all x,y: Int|(x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies{adjacentMinesPopulate[b,x,y]}
}

pred adjacentMinesPopulate[b:Board, row,col:Int]{
    b.adjacentMines[row][col] = #{b.mines[row][add[col,1]]=1 or
                                    b.mines[row][add[col,-1]]=1 or
                                    b.mines[add[row,1]][col]=1 or
                                    b.mines[add[row,-1]][col]=1 or
                                    b.mines[add[row,1]][add[col,1]]=1 or
                                    b.mines[add[row,1]][add[col,-1]]=1 or
                                    b.mines[add[row,-1]][add[col,1]]=1 or
                                    b.mines[add[row,-1]][add[col,-1]]=1}
}

-- initial board has all cells hidden
pred initial[b: Board] {
    all x: Int, y: Int | (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies { b.cells[x][y] = Hidden}
}


pred lost[b:Board,row,col:Int]{
    b.mines[row][col] = 1
}

pred won[b: Board]{
    all row,col : Int|{
        row >= MIN
        row <= MAXCOL
        col >= MIN
        col <= MAXROW
        b.mines[row][col] = 1 implies b.cells[row][col] = Hidden
        b.cells[row][col] = Revealed implies b.mines[row][col] = 0
    }
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

pred move[pre: Board, row, col: Int, post: Board]{
    not lost[pre,row,col] and not won[pre]
    pre.cells[row][col] = Hidden or pre.adjacentMines[row][col] = 0
    row >= MIN
    row <= MAXCOL
    col >= MIN
    col <= MAXROW
    wellformed
    post.cells[row][col] = Revealed 
    all row2:Int,col2:Int| (row!=row2 or col!=col2) implies {
        post.mines[row2][col2] = pre.mines[row2][col2]
        post.adjacentMines[row2][col2] = pre.adjacentMines[row2][col2]
    }
    pre.adjacentMines[row][col] = 0 implies post.openUpboardHelper[post,row,col]
}

pred doNothing[pre,post:Grid]{
    all row,col: Int|{
        post.mines[row][col] = post.mines[row][col]
        post.adjacentMines[row][col] = post.adjacentMines[row][col]
        post.adjacentMines[row][col] = post.cells[row][col]
    }
}


pred dumbAlgorithim[b:Board]{
    //if empty board random square, if 
    all row,col:Int{
        row >= MIN
        row <= MAXCOL
        col >= MIN
        col <= MAXROW
        
    }
    
}


//optimizer predicate constraints saying no 
// inst optimizer{

// }
-- so far : a trace involves the board being wellformed and the initial board
pred game_trace {
    // init[MineSweeper.initial]
    // all b:Board|{some MineSweeper.next[b] implies{
    //     (some row,col:Int|move[b,row,col,MineSweeper.next[b]])
    //     or 
    //     doNothing[b,MineSweeper.next[b]]
    //     }
    // }
    all board: Board | wellformed[board]
    initial[Game.first]
}

run {game_trace}