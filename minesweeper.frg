#lang forge

option run_sterling "t3_backroom.js"


--General Representation of MindSweeper
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
fun MAXCOL: one Int { 4 }
fun MAXROW: one Int { 4 }
-- TODO: come up with a good equation that determines the number of mines based on board dimensions (John or Amanda)
-- John commen: do not know how to do this (division), but usually for minesweeper, for every 5 to 7 squares there is a mine 
fun MAXMINES: one Int { 5 }

-- make sure that all boards are a certain size
pred wellformed[b: Board] {
    // -- out of bounds
    // all x: Int, y: Int | (x < MIN or x > MAXCOL or y < MIN or y > MAXROW) implies {b.cells[x][y] = Ignored
    //                                                                                 Board.mines[x][y] = 0}
                                                                                    
    -- in bounds                                                                                
    all x: Int, y: Int | (x >= MIN and x <= MAXCOL and y >= MIN and y <= MAXROW) implies{ b.cells[x][y] != Ignored 
                                                                                       Board.mines[x][y] = 0 or Board.mines[x][y] = 1}
    
    #{row, col: Int |  (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) and Board.mines[row][col] = 1} = MAXMINES
    -- no more than 4 mines
    //#{row, col: Int | Board.mines[row][col] = 1} = MAXMINES

     -- cells will show the adjacent Mines
    all x,y: Int|(x >= MIN and x <= MAXCOL and y >= MIN and y <= MAXROW) implies{ adjacentMinesPopulate[b,x,y] }
}

-- initial board has all cells hidden
pred initial[b: Board] {
    all x: Int, y: Int | (x >= MIN and x <= MAXCOL and y >= MIN and y <= MAXROW) implies { b.cells[x][y] = Hidden }
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
            post.cells[x][y] = Revealed 
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

pred adjacentHiddenChecker[b:Board,row: Int,col: Int]{
    b.cells[row][add[col,1]] = Hidden or
    b.cells[row][add[col,-1]] = Hidden or
    b.cells[add[row,1]][col] = Hidden or
    b.cells[add[row,-1]][col] = Hidden or
    b.cells[add[row,1]][add[col,1]] = Hidden or 
    b.cells[add[row,1]][add[col,-1]] = Hidden or
    b.cells[add[row,-1]][add[col,1]] = Hidden or
    b.cells[add[row,-1]][add[col,-1]] = Hidden
}

-- what should happen when a player makes a move
pred openTile[pre: Board, post: Board, row: Int, col: Int] {
    --the cell is hidden in the pre board state, it should be revealed in the post board state
    pre.cells[row][col] = Hidden or (pre.adjacentMines[row][col] = 0 and adjacentHiddenChecker[pre,row,col])
    post.cells[row][col] = Revealed 

    --if the cell has adjacent mines, then only the tile is revealed- else the adjacent cells are revealed
    pre.adjacentMines[row][col] = 0 implies { revealAdjacentCells[pre, post, row, col] }
    pre.adjacentMines[row][col] != 0 implies { 
        -- all other cells remains unchanged
        all r: Int, c: Int | not (r = row and c = col ) implies { post.cells[r][c] = pre.cells[r][c] }
        -- the state of the mines and adjacent mines should remain the same
        all r, c: Int | {
            post.mines[r][c] = pre.mines[r][c]
            post.adjacentMines[r][c] = pre.adjacentMines[r][c]
        }
    }
}

-- win condition
pred won[b: Board]{
    -- cells with mines are still hidden and cells without mines are revealed
    all row, col : Int | {
        (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies { 
            b.mines[row][col] = 1 implies { b.cells[row][col] = Hidden }
            b.mines[row][col] = 0 implies { b.cells[row][col] = Revealed }
        }       
    }
}

-- lose condition
pred lost[b: Board] {
    -- a loss is a trace where any mine is revealed
    some row, col : Int | (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW and b.mines[row][col] = 1 and b.cells[row][col] = Revealed )
}

-- do nothing condition - no cell state has changed. 
pred doNothing[pre, post: Board] {
  all row, col: Int | {
    post.cells[row][col] = pre.cells[row][col]
    post.mines[row][col] = pre.mines[row][col]
    post.adjacentMines[row][col] = pre.adjacentMines[row][col]
  }
}


-- cell does not have a mine
pred noMine[b: Board, row: Int, col: Int] {
    b.mines[row][col] = 0
}

-- : Algos, Algos, Algos: 
--Practically extra conditions for a valid move each one encapsulates the logic for the last 
-- checks if prestate board statifies a condition and if it does then it has to more there 
-- row col in bounds, represents a basic valid move
pred inBounds[x:Int,y:Int]{
    x >= MIN
    x <= MAXCOL
    y >= MIN
    y <= MAXROW
}

--checks if Board has some riskless position it can move to
--check if revelead as well
pred ableToGatherSpace[pre: Board]{
    some r,c: Int|{
        inBounds[r,c]
        pre.adjacentMines[r][c] = 0
        pre.cells[r][c] = Revealed
        adjacentHiddenChecker[pre,r,c]
    }
}

--if intial state any move works, then checks for the 0 adjacent mine tile riskless move
pred dumbAlgo[pre: Board, row: Int, col: Int]{
    --At first, due to optimizer there will be a move that is in bounds
    --if ableToGatherSpace, as in populate the part of the board for information, it implies that, that row,col move does not have adjacent Mines, 
    -- but has adjacent hidden tiles else it is just any move within the board
    ableToGatherSpace[pre] implies (pre.adjacentMines[row][col] = 0 and pre.cells[row][col] = Revealed and adjacentHiddenChecker[pre,row,col])
    --might seem counter intuitive but P -> Q when Q is always true is true
    not ableToGatherSpace[pre] implies inBounds[row,col]
}

--Checks a certain tile only has one adjacent hidden tile 
pred OneAdjacentHiddens[pre: Board, row: Int, col: Int]{
    #{x: Int, y: Int |
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
    ) implies pre.cells[x][y]=Hidden}=1
    --for every adjacent tile, count the amount of tiles that are hidden equals to 1
}


--Checks adjacent tiles to see if there is one that adjacentMines = 1 and then uses a helper function to check if that one tile has all but one hidden tiles
--Uses the same logic a player would use rather than just taking the information of the board itself, example of imperfect information
pred definetlyAMineOneTile[pre: Board, row: Int, col: Int] {
    pre.cells[row][col] = Hidden
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
                -- if the adjacent cell is has 1 adjacent mine and it is revealed and that adjacent cell has only one hidden square that is adjacent, this statement is true 
                (pre.adjacentMines[x][y] = 1 and pre.cells[x][y] = Revealed and OneAdjacentHiddens[pre,x,y])
            }
    }
}

-- Definition, definetlyAMineOneTile: a tile that is revealed and has only one adjacent mine around it and all but one tile that is around it is either hidden or ignored
----At first, due to optimizer there will be a move that is in bounds, then checks for the 0 adjacent mine tile riskless move, checks that there isn't an adjacent one mine tile auto flag
pred kindaSmartAlgo[pre: Board, row: Int, col: Int] {
    --At first, due to optimizer there will be a move that is in bounds
    --if ableToGatherSpace, as in populate the part of the board for information, it implies that, that row,col move does not have adjacent Mines, 
    -- but has adjacent hidden tiles
   ableToGatherSpace[pre] implies (pre.adjacentMines[row][col] = 0 and pre.cells[row][col] = Revealed and adjacentHiddenChecker[pre,row,col])
   --Makes sure it is not a row,col pair that is garrenteed to be a mine in a simple case, the simple case is to check if it a one adjacent mine tile with all but one of its adjacent tiles hidden
   --(which is the tile that the row,col we don't want to be on) else it just makes a generally valid move
   not definetlyAMineOneTile[pre,row,col]
}

--Checks if adjacent to a cell that only is an 1 adjacent mine cell and is revealed
pred ableToMakeLeapInLogic[pre: Board, row: Int, col: Int]{
    pre.cells[row][col] = Hidden
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
                -- if the adjacent cell is has 1 adjacent mine and it is revealed and that adjacent cell has only one hidden square that is adjacent
                pre.adjacentMines[x][y] = 1 and pre.cells[x][y] = Revealed and definetlyAMineOneTile[pre,x,y]
            }
    }
}

--Makes the Same Logic Patterns as the last agorithim to start but adds a second layer of inference to the definetlyAMineOneTile predicate, as if there is a 
--move that is adjacent to a tile with a only one adjacent mine, where that cell is adjacent to a tile that you definetly know is a mine then it is a safe tile.

pred relativelySmartestAlgo[pre: Board, row: Int, col: Int]{
    --At first, due to optimizer there will be a move that is in bounds
    --if ableToGatherSpace, as in populate the part of the board for information, it implies that, that row,col move does not have adjacent Mines, 
    -- but has adjacent hidden tiles
   ableToGatherSpace[pre] implies (pre.adjacentMines[row][col] = 0 and pre.cells[row][col] = Revealed and adjacentHiddenChecker[pre,row,col])
   --(which is the tile that the row,col we don't want to be on) else it just makes a generally valid move
   not ableToGatherSpace[pre] implies (not definetlyAMineOneTile[pre,row,col])
   ableToMakeLeapInLogic[pre,row,col] implies ((pre.cells[row][col] = Hidden) and (pre.mines[row][col]=0))
   --Makes sure it is not a row,col pair that is garrenteed to be a mine in a simple case, the simple case is to check if it a one adjacent mine tile with all but one of its adjacent tiles hidden
   --(which is the tile that the row,col we don't want to be on) else it just makes a generally valid move

}


--TRACES
-- so far :  Traces that follows basic rule of dont click on a mine, the perfect representation of knowing what the right move is
pred game_trace_perfectInfo {
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
            -- if the game is won, do nothing
            (won[b])=> doNothing[b, Game.next[b]] else {
                --maintain the previous board state
                //maintainPreviousBoard[b, Game.next[b], row, col]
                --dumbAlgo
                dumbAlgo[b, row, col]
                --if the cell is hidden, it should be revealed
                openTile[b, Game.next[b], row, col]
                -- reveal adjacent cells if the adjacent cells do not have mines
                //revealAdjacentCells[b, Game.next[b], row, col]
            }
        }
    }
}

-- so far : traces that follows basic algorithim of dumbAlgo, cares about gathering information
pred game_trace_DumbAlgo {
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
            -- if the game is won, do nothing
            (lost[b])=> doNothing[b, Game.next[b]] else {
                --maintain the previous board state
                //maintainPreviousBoard[b, Game.next[b], row, col]
                --dumbAlgo
                dumbAlgo[b, row, col]
                --if the cell is hidden, it should be revealed
                openTile[b, Game.next[b], row, col]
                -- reveal adjacent cells if the adjacent cells do not have mines
                //revealAdjacentCells[b, Game.next[b], row, col]
            }
        }
    }
}

-- so far : traces that follows basic algorithim of kindaSmartAlgo
pred game_trace_kindaSmartAlgo {
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
            -- if the game is won or lost, do nothing
            (won[b] or lost[b])=> doNothing[b, Game.next[b]] else {
                --maintain the previous board state
                //maintainPreviousBoard[b, Game.next[b], row, col]
                --kindaSmartAlgo
                kindaSmartAlgo[b, row, col] 
                --if the cell is hidden, it should be revealed
                openTile[b, Game.next[b], row, col]
            }
        }
    }
}

-- so far : traces that follows algorithim of dumbAlgo
pred game_trace_relativelySmartestAlgo {
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
            -- if the game is won, do nothing
            (won[b] or lost[b])=> doNothing[b, Game.next[b]] else {
                --maintain the previous board state
                //maintainPreviousBoard[b, Game.next[b], row, col]
                --relativelySmartestAlgo
                relativelySmartestAlgo[b, row, col] 
                --if the cell is hidden, it should be revealed
                openTile[b, Game.next[b], row, col]
                -- reveal adjacent cells if the adjacent cells do not have mines
                //revealAdjacentCells[b, Game.next[b], row, col]
            }
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
                (0 + 1 + 2 + 3 + 4) -> 
                (0 + 1 + 2 + 3 + 4) -> 
                (Hidden + Revealed + Ignored)
    mines in Board -> 
                (0 + 1 + 2 + 3 + 4 ) -> 
                (0 + 1 + 2 + 3 + 4 )-> 
                (0 + 1)
    adjacentMines in Board -> 
                (0 + 1 + 2 + 3 + 4 ) -> 
                (0 + 1 + 2 + 3 + 4 ) -> 
                (0 + 1 + 2)
}

--run { game_trace_perfectInfo } for 8 Board, 1 Game for {optimizer next is linear}

run { game_trace_DumbAlgo } for 6 Board, 1 Game for {optimizer next is linear}

--run { game_trace_kindaSmartAlgo } for 8 Board, 1 Game for {optimizer next is linear}

--run { game_trace_relativelySmartestAlgo } for 8 Board, 1 Game for {optimizer next is linear}



