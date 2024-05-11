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
-- TODO: we can make board bigger but for now it is 4x4 (John or Amanda)
fun MAXCOL: one Int { 3 }
fun MAXROW: one Int { 3 }
-- TODO: come up with a good equation that determines the number of mines based on board dimensions (John or Amanda)
fun MAXMINES: one Int { 3 }

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

-- reveal adjacent cells if the adjacent cells do not have mines
pred revealAdjacentCells[pre: Board, post: Board, row: Int, col: Int] {
    pre.adjacentMines[row][col] = 0 implies{
        all x: Int, y: Int | {
            (
                -- northwest
                (x = add[row, -1] and y = add[col, -1]) or
                -- north
                (x = add[row, -1] and y = col) or
                -- northeast
                (x = add[row, -1] and y = add[col, 1]) or 
                -- west
                (x = row and y = add[col, -1]) or
                -- east
                (x = row and y = add[col, 1]) or
                -- southwest  
                (x = add[row, 1] and y = add[col, -1]) or
                -- south
                (x = add[row, 1] and y = col) or
                -- southeast
                (x = add[row, 1] and y = add[col, 1])
            ) 
            implies {
                -- if the cell is safe with no mines and it is hidden -> then it should be revealed
                (pre.mines[x][y] = 0 and pre.cells[x][y] = Hidden) implies { post.cells[x][y] = Revealed }
                -- otherwise, the cell should remain hidden
                else { post.cells[x][y] = pre.cells[x][y] }
            }
        }
    }
    -- all other cells remains unchanged
    all r: Int, c: Int | not ((r = add[row, -1] or r = row or r = add[row, 1]) and
                              (c = add[col, -1] or c = col or c = add[col, 1])) implies { post.cells[r][c] = pre.cells[r][c] }
    -- the state of the mines and adjacent mines should remain the same
    all r, c: Int | {
        post.mines[r][c] = pre.mines[r][c]
        post.adjacentMines[r][c] = pre.adjacentMines[r][c]
    }
}

-- win condition
pred won[b: Board]{
    -- cells with mines are still hidden and cells without mines are revealed
    all row, col : Int | {
        (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW) implies { 
            b.mines[row][col] = 1 implies { b.cells[row][col] = Hidden }
            b.mines[row][col] = 0 implies { b.cells[row][col] = Revealed }
        }       
    }
}


-- lose condition
pred lost[b: Board] {
    -- a loss is a trace where any mine is revealed
    some row, col : Int | (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW && b.mines[row][col] = 1) implies { b.cells[row][col] = Revealed }
}

-- do nothing condition - no cell state has changed. 
pred doNothing[pre, post: Board] {
  all row, col: Int | {
    post.cells[row][col] = pre.cells[row][col]
    post.mines[row][col] = pre.mines[row][col]
    post.adjacentMines[row][col] = pre.adjacentMines[row][col]
  }
}

-- what should happen when a player makes a move
pred openTile[pre: Board, post: Board, row: Int, col: Int] {
    --the cell is hidden in the pre board state, it should be revealed in the post board state
    pre.cells[row][col] = Hidden
    post.cells[row][col] = Revealed
}

-- maintain the boards previous state except for the cell that was 'clicked' on
pred maintainPreviousBoard[pre: Board, post: Board, row: Int, col: Int] {
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

-- row col in bounds 
pred inBounds[x:Int,y:Int]{
    x >= MIN
    x <= MAXCOL
    y >= MIN
    y <= MAXROW
}

-- so far : traces that follows basic rule of dont click on a mine
pred game_trace_dummy {
    -- all boards are wellformed
    all board: Board | { wellformed[board] }

    -- the first board is the initial board- all cells are hidden
    initial[Game.first]

    -- the first board is one with no previous board
    no prev: Board | Game.next[prev] = Game.first

    -- there exists some next board 
    all b: Board | some Game.next[b] implies {
        -- for some row, col
        some row, col: Int | {
            -- more conditions for a valid move, will not touch as I don't understand all this code
            -- if the game is won, do nothing
            -- check for lost as well
            won[b] => doNothing[b, Game.next[b]] else {
                --maintain the previous board state
                //maintainPreviousBoard[b, Game.next[b], row, col]
                --row and col does not have a mine
                noMine[b, row, col]
                --if the cell is hidden, it should be revealed
                openTile[b, Game.next[b], row, col]
                -- reveal adjacent cells if the adjacent cells do not have mines
                revealAdjacentCells[b, Game.next[b], row, col]
            }
        }
    }
}
-- TODO: optimizer for ints (John)

-- 

-- : Algos, Algos, Algos: Practically extra conditions for a valid move each one encapsulates the logic for the last 
-- checks if prestate board statifies a condition and if it does then it has to more there 

// pred adjacentHiddenChecker[b:Board,row,col:Int]{
//     b.cells[row][add[col,1]] = Hidden or
//     b.cells[row][add[col,-1]] = Hidden or
//     b.cells[add[row,1]][col] = Hidden or
//     b.cells[add[row,-1]][col] = Hidden or
//     b.cells[add[row,1]][add[col,1]] = Hidden or 
//     b.cells[add[row,1]][add[col,-1]] = Hidden or
//     b.cells[add[row,-1]][add[col,1]] = Hidden or
//     b.cells[add[row,-1]][add[col,-1]] = Hidden or
// }

// --checks if Board has some riskless position it can move to
// --check if revelead as well
// pred ableToGatherSpace[pre: Board]{
//     some r,c: Int|{
//         inBounds[r,c]
//         pre.adjacentMines[r][c] == 0
//         adjacentHiddenChecker[pre,r,c]
//     }
// }

// --checks for intial state, then checks for the 0 adjacent mine tile riskless move
// pred dumbAlgo[pre: Board, row: Int, col: Int]{
//     --if intial Board any row col 
//     intial[pre] implies inBounds[row,col]

//     ableToGatherSpace[pre] implies (pre.adjacentMines[row][col] == 0 and adjacentHiddenChecker[pre,row,col]) else {inBounds[row,col]}
// }



--Checks a certain tile only has one adjacent hidden tile 

--Checks adjacent tiles to see if there is one that adjacentMines = 1


-- Definition, one adjacent mine tile auto flag: a tile that is revealed and has only one adjacent mine around it and all but one tile that is around it is either hidden or ignored
--checks for intial state, then checks for the 0 adjacent mine tile riskless move, checks that there isn't an adjacent one mine tile auto flag
// pred kindaSmartAlgo[pre: Board, row: Int, col: Int]{
//     --if intial Board any row col 
//     intial[pre] implies inBounds[row,col]
//     -- if it is able to gather space then it has to move to that position
//     ableToGatherSpace[pre] implies (pre.adjacentMines[row][col] == 0 and adjacentHiddenChecker[pre,row,col] and pre.cells[row][col] = Revealed)
//     --Makes sure it is not a row,col pair that is garrenteed to be a mine

// }

// pred relativelySmartestAlgo[pre: Board, row: Int, col: Int]{
    
// }
-- TODO: begin testing (Amanda)

run { game_trace_dummy } for 7 Board, 1 Game for { next is linear }
