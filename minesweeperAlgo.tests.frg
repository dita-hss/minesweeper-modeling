#lang forge

open "minesweeper.frg"

-- This file tests the algorithms and their helper predicates. The following test suites can be found: 
    -- adjacentHiddenChecker: tests the adjacentHiddenChecker predicate
    -- ableToGatherSpace: tests the ableToGatherSpace predicate
    -- dumbAlgo: tests the dumbAlgo predicate
    -- OneAdjacentHiddens: tests the OneAdjacentHiddens predicate
    -- definetlyAMineOneTile: tests the definetlyAMineOneTile predicate
    -- twoAdjacentHiddens: tests the twoAdjacentHiddens predicate
    -- definetlyAMineTwoTile: tests the definetlyAMineTwoTile predicate
    -- adjacentOneTile: tests the adjacentOneTile predicate
    -- adjacentToOneMineAndRevealedOneTile: tests the adjacentToOneMineAndRevealedOneTile predicate
    -- game_trace_perfectInfo: tests the game_trace_perfectInfo predicate
    -- game_trace_DumbAlgo: tests the game_trace_DumbAlgo predicate
    -- game_trace_kindaSmartAlgo: tests the game_trace_kindaSmartAlgo predicate  
    -- game_trace_relativelySmartestAlgo: tests the game_trace_relativelySmartestAlgo predicate  

test suite for adjacentHiddenChecker{
    test expect{ basicSat:{
        some pre:Board|{
            pre.cells[1][1] = Revealed
            pre.cells[1][2] = Hidden
            pre.cells[1][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[0][1] = Revealed
            pre.cells[2][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[0][2] = Revealed
            pre.cells[0][0] = Revealed
            adjacentHiddenChecker[pre,1,1]
        }
    } is sat}
    test expect{ basicUnSat:{
        some pre:Board|{
            pre.cells[1][2] = Revealed
            pre.cells[1][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[0][1] = Revealed
            pre.cells[2][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[0][2] = Revealed
            pre.cells[0][0] = Revealed
            adjacentHiddenChecker[pre,1,1]
        }
    } is unsat}
    test expect{ allBasicSat:{
        some pre:Board|{
            pre.cells[1][2] = Hidden
            pre.cells[1][0] = Hidden
            pre.cells[2][1] = Hidden
            pre.cells[0][1] = Hidden
            pre.cells[2][2] = Hidden
            pre.cells[2][0] = Hidden
            pre.cells[0][2] = Hidden
            pre.cells[0][0] = Hidden
            adjacentHiddenChecker[pre,1,1]
        }
    } is sat}
}

test suite for ableToGatherSpace {  
    -- a board with one riskless position (0 adjacent mines) revealed
    test expect { testAbleToGatherSpaceExists: {
        some pre: Board | {
            -- board with one riskless position
            pre.cells[1][1] = Revealed
            pre.adjacentMines[1][1] = 0
            adjacentHiddenChecker[pre, 1, 1]
            ableToGatherSpace[pre]
        }
    } is sat }

    -- a board with multiple riskless positions
    test expect { testMultipleRisklessPositions: {
        some pre: Board | {
            -- board with riskless positions
            pre.cells[1][1] = Revealed
            pre.adjacentMines[1][1] = 0
            adjacentHiddenChecker[pre, 1, 1]
            pre.cells[2][2] = Revealed
            pre.adjacentMines[2][2] = 0
            adjacentHiddenChecker[pre, 2, 2]
            ableToGatherSpace[pre]
        }
    } is sat }
}

test suite for OneAdjacentHiddens {
    -- a tile with no adjacent hidden tiles
    test expect { testNoAdjacentHiddenTiles: {
        some pre: Board | {
            -- a board where (1, 1) has no adjacent hidden tiles
            pre.cells[1][1] = Revealed
            all x, y: Int | (x >= 0 and x <= 2 and y >= 0 and y <= 2) implies { pre.cells[x][y] != Hidden }
            not OneAdjacentHiddens[pre, 1, 1]
        }
    } is sat }

    -- a tile with multiple adjacent hidden tiles
    test expect { testMultipleAdjacentHiddenTiles: {
        some pre: Board | {
            -- a board where (1, 1) has multiple adjacent hidden tiles
            pre.cells[1][1] = Revealed
            pre.cells[0][0] = Hidden
            pre.cells[0][1] = Hidden
            pre.cells[0][2] = Revealed
            pre.cells[1][0] = Revealed
            pre.cells[1][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[2][2] = Revealed
            OneAdjacentHiddens[pre, 1, 1]
        }
    } is unsat }
}

pred testingfordefinetlyAMineOneTileSat{
    some pre: Board | { 
        -- cell at (1, 1) is a hidden mine tile 
        pre.mines[1][1] = 1
        pre.cells[1][1] = Hidden
        -- cell at (2, 2) has all but one tile hidden
        pre.cells[2][2] = Revealed
        pre.adjacentMines[2][2] = 1
        pre.cells[3][3] = Revealed
        pre.cells[2][3] = Revealed
        pre.cells[3][2] = Revealed
        pre.cells[1][2] = Revealed
        pre.cells[2][1] = Revealed
        pre.cells[1][3] = Revealed
        pre.cells[3][1] = Revealed
        --all other cells are hidden
        pre.cells[0][0] = Hidden
        pre.cells[1][0] = Hidden
        pre.cells[0][1] = Hidden
        pre.cells[0][2] = Hidden
        pre.cells[2][0] = Hidden
        definetlyAMineOneTile[pre,1,1]
    }
}

pred testingfordefinetlyAMineOneTileUnsat{
    some pre: Board | { 
        -- cell at (1, 1) is a hidden mine tile 
        pre.mines[1][1] = 1
        pre.cells[1][1] = Hidden
        -- cell at (2, 2) has all but one tile hidden
        pre.cells[2][2] = Revealed
        pre.adjacentMines[2][2] = 1
        pre.cells[3][3] = Revealed
        pre.cells[2][3] = Revealed
        pre.cells[3][2] = Hidden
        pre.cells[1][2] = Revealed
        pre.cells[2][1] = Revealed
        pre.cells[1][3] = Revealed
        pre.cells[3][1] = Revealed
        --all other cells are hidden
        pre.cells[0][0] = Hidden
        pre.cells[1][0] = Hidden
        pre.cells[0][1] = Hidden
        pre.cells[0][2] = Hidden
        pre.cells[2][0] = Hidden
        definetlyAMineOneTile[pre,1,1]
    }
}

pred backendEdgeCasemineTileIsAHiddenOneAdjMineTile {
    some pre: Board | { 
        -- cell at (1, 1) is a hidden mine tile 
        pre.mines[1][1] = 1
        pre.cells[1][1] = Hidden
        -- cell at (2, 2) has all but one tile hidden
        -- cell at (2, 2) is a hidden mine tile with one hidden mine tile (edge case)
        pre.cells[2][2] = Hidden
        pre.adjacentMines[2][2] = 1
        pre.mines[2][2] = 1
        pre.cells[3][3] = Revealed
        pre.cells[2][3] = Revealed
        pre.cells[3][2] = Revealed
        pre.cells[1][2] = Revealed
        pre.cells[2][1] = Revealed
        pre.cells[1][3] = Revealed
        pre.cells[3][1] = Revealed
        -- All Other Cells are Hidden
        pre.cells[0][0] = Hidden
        pre.cells[1][0] = Hidden
        pre.cells[0][1] = Hidden
        pre.cells[0][2] = Hidden
        pre.cells[2][0] = Hidden
        definetlyAMineOneTile[pre,1,1]
    }
}

--References definetlyAMineOneTile in predicates
test suite for definetlyAMineOneTile{
    test expect{ testingfordefinetlyAMineOneTilUnSat:{
        testingfordefinetlyAMineOneTileUnsat
    } is unsat }
    test expect{ testingbackendEdgeCasemineTileIsAHiddenOneAdjMineTile:{
        backendEdgeCasemineTileIsAHiddenOneAdjMineTile
    } is unsat }
}

test suite for twoAdjacentHiddens {
    --a tile with no adjacent hidden tiles
    test expect { testNoAdjacentHiddenTiles: {
        some pre: Board | {
            pre.cells[1][1] = Revealed
            all x, y: Int | (x >= 0 and x <= 2 and y >= 0 and y <= 2) implies { pre.cells[x][y] != Hidden }
            not twoAdjacentHiddens[pre, 1, 1]
        }
    } is sat }

    --a tile with one adjacent hidden tile
    test expect { testOneAdjacentHiddenTile: {
        some pre: Board | {
            pre.cells[1][1] = Revealed
            pre.cells[0][0] = Hidden
            pre.cells[0][1] = Revealed
            pre.cells[0][2] = Revealed
            pre.cells[1][0] = Revealed
            pre.cells[1][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[2][2] = Revealed
            not twoAdjacentHiddens[pre, 1, 1]
        }
    } is sat }

    --atile with multiple adjacent hidden tiles
    test expect { testMultipleAdjacentHiddenTiles: {
        some pre: Board | {
            pre.cells[1][1] = Revealed
            pre.cells[0][0] = Hidden
            pre.cells[0][1] = Hidden
            pre.cells[0][2] = Hidden
            pre.cells[1][0] = Revealed
            pre.cells[1][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[2][2] = Revealed
            not twoAdjacentHiddens[pre, 1, 1]
        }
    } is sat }
}

test suite for definetlyAMineTwoTile {
    -- a cell that is not definitely a mine
    test expect { testDefinetlyAMineTwoTileFalse: {
        some pre: Board | {
            pre.cells[1][1] = Hidden
            pre.cells[0][0] = Revealed
            pre.adjacentMines[0][0] != 2
            pre.cells[0][1] = Hidden
            pre.cells[0][2] = Hidden
            definetlyAMineTwoTile[pre, 1, 1]
        }
    } is unsat }
}

test suite for adjacentOneTile {
    --a tile that has at least one adjacent tile with such conditions in pred
    test expect { testAdjacentOneTileTrue: {
        some pre: Board | {
            pre.cells[1][1] = Hidden
            pre.cells[0][0] = Revealed
            pre.adjacentMines[0][0] = 1
            pre.cells[0][1] = Hidden
            OneTileAdjToAMineOneTile[pre, 0, 0]
            adjacentOneTile[pre, 1, 1]
        }
    } is sat }

    --a tile that has no adjacent tile with such conditions in pred
    test expect { testAdjacentOneTileFalse: {
        some pre: Board | {
            pre.cells[1][1] = Hidden
            pre.cells[0][0] = Revealed
            pre.adjacentMines[0][0] != 1
            pre.cells[0][1] = Hidden
            not OneTileAdjToAMineOneTile[pre, 0, 0]
            adjacentOneTile[pre, 1, 1]
        }
    } is unsat }

    -- a tile that has at least one adjacent tile
    test expect { testEdgeTileAdjacentOneTile: {
        some pre: Board | {
            pre.cells[0][1] = Hidden
            pre.cells[0][0] = Revealed
            pre.adjacentMines[0][0] = 1
            pre.cells[1][1] = Hidden
            OneTileAdjToAMineOneTile[pre, 0, 0]
            adjacentOneTile[pre, 0, 1]
        }
    } is sat }

    --a corner tile that has at least one adjacent tile meeting the conditions
    test expect { testCornerTileAdjacentOneTile: {
        some pre: Board | {
            pre.cells[0][0] = Hidden
            pre.cells[0][1] = Revealed
            pre.adjacentMines[0][1] = 1
            pre.cells[1][0] = Hidden
            OneTileAdjToAMineOneTile[pre, 0, 1]
            adjacentOneTile[pre, 0, 0]
        }
    } is sat }
}

test suite for adjacentToOneMineAndRevealedOneTile {
    -- a cell that is not adjacent to any mine tile
    test expect { testNotAdjacentToAnyMineTile: {
        some pre: Board | {
            all x, y: Int | not definetlyAMineOneTile[pre, x, y]
            pre.cells[2][2] = Revealed
            not adjacentToOneMineAndRevealedOneTile[pre]
            #{x, y: Int | (x >= 1 and x <= 3 and y >= 1 and y <= 3) and definetlyAMineOneTile[pre, x, y]} = 0
        }
    } is sat }

    -- a cell adjacent to multiple mine tiles
    test expect { testAdjacentToMultipleMineTiles: {
        some pre: Board | {
            definetlyAMineOneTile[pre, 1, 1]
            definetlyAMineOneTile[pre, 1, 2]
            pre.cells[2][2] = Revealed
            not adjacentToOneMineAndRevealedOneTile[pre]
            #{x, y: Int | (x >= 1 and x <= 3 and y >= 1 and y <= 3) and definetlyAMineOneTile[pre, x, y]} > 1
        }
    } is unsat }
}

-- the tests pass but they take a long time to run
test suite for game_trace_perfectInfo {

    -- valid game trace is sat
    test expect { validGameTrace: {
        game_trace_perfectInfo
    } is sat }

    -- initial board state
    test expect { testInitialBoardState: {
        some pre: Board | {
            initial[pre]
            game_trace_perfectInfo
            all row, col: Int | (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                pre.cells[row][col] = Hidden
            }
        }
    } is sat }

    -- the first move does not always click on a mine
    test expect { testFirstMoveNoMineClicked: {
        some pre, post: Board | {
            initial[pre]
            game_trace_perfectInfo
            no prev: Board | Game.next[prev] = pre
            Game.first = pre
            some row, col: Int | {
                noMine[pre, row, col]
                openTile[pre, post, row, col]
                pre.cells[row][col] = Hidden
                post.cells[row][col] = Revealed
            }
        }
    } is sat }

    -- subsequent moves do not always click on mines
    test expect { testSubsequentMovesNoMineClicked: {
        some pre, post: Board | {
            game_trace_perfectInfo
            some row, col: Int | {
                noMine[pre, row, col]
                openTile[pre, post, row, col]
                -- check that the move reveals a cell
                pre.cells[row][col] = Hidden
                post.cells[row][col] = Revealed
            }
        }
    } is sat }

    -- game win condition
    test expect { testGameWin: {
        some pre, post: Board | {
            game_trace_perfectInfo
            all row, col: Int | {
                (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                    pre.mines[row][col] = 1 implies { pre.cells[row][col] = Hidden }
                    pre.mines[row][col] = 0 implies { pre.cells[row][col] = Revealed }
                }
            }
            won[pre]
            -- check that no further moves are made
            doNothing[pre, post]
        }
    } is sat }
}

-- this test suite takes a few minutes to run but the tests do pass
test suite for game_trace_DumbAlgo {
    -- a first move exists
    test expect { testFirstMove: {
        some pre, post: Board | {
            initial[pre]
            game_trace_DumbAlgo
            no prev: Board | Game.next[prev] = pre
            Game.first = pre
            some row, col: Int | {
                dumbAlgo[pre, row, col]
                openTile[pre, post, row, col]
                -- check that the first move reveals a cell
                pre.cells[row][col] = Hidden
                post.cells[row][col] = Revealed
            }
        }
    } is sat }

    -- there exists games where the board reveals adjacent cells if no adjacent mines
    test expect { testRevealAdjacentCells: {
        some pre, post: Board | {
            game_trace_DumbAlgo
            pre.cells[1][1] = Hidden
            pre.adjacentMines[1][1] = 0
            openTile[pre, post, 1, 1]
            post.cells[1][1] = Revealed
            all x, y: Int | {
                ((x = 0 or x = 1 or x = 2) and (y = 0 or y = 1 or y = 2)) implies {
                    post.cells[x][y] = Revealed
                }
            }
        }
    } is sat }

    -- a win game exists
    test expect { testGameWin: {
        some pre, post: Board | {
            game_trace_DumbAlgo
            all row, col: Int | {
                (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                    pre.mines[row][col] = 1 implies { pre.cells[row][col] = Hidden }
                    pre.mines[row][col] = 0 implies { pre.cells[row][col] = Revealed }
                }
            }
            won[pre]
            -- check that no further moves are made
            doNothing[pre, post]
        }
    } is sat }

    -- a lost game exists
    test expect { testGameLoss: {
        some pre, post: Board | {
            game_trace_DumbAlgo
            pre.mines[1][1] = 1
            pre.cells[1][1] = Revealed
            lost[pre]
            -- check that no further moves are made
            doNothing[pre, post]
        }
    } is sat }
}

-- this test suite takes a few minutes to run but the tests do pass
test suite for game_trace_kindaSmartAlgo {

    -- test initial board state
    test expect { testInitialBoardState: {
        some pre: Board | {
            initial[pre]
            game_trace_kindaSmartAlgo
            -- check all cells are hidden
            all row, col: Int | {
                (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                    pre.cells[row][col] = Hidden
                }
            }
        }
    } is sat }

    --text the first move
    test expect { testFirstMove: {
        some pre, post: Board | {
            initial[pre]
            game_trace_kindaSmartAlgo
            no prev: Board | Game.next[prev] = pre
            Game.first = pre
            some row, col: Int | {
                kindaSmartAlgo[pre, row, col]
                openTile[pre, post, row, col]
                -- check that the first move reveals a cell
                pre.cells[row][col] = Hidden
                post.cells[row][col] = Revealed
            }
        }
    } is sat }

    -- test revealing adjacent cells if no adjacent mines
    test expect { testRevealAdjacentCells: {
        some pre, post: Board | {
            game_trace_kindaSmartAlgo
            -- set up a board state with a cell having no adjacent mines
            pre.cells[1][1] = Hidden
            pre.adjacentMines[1][1] = 0
            openTile[pre, post, 1, 1]
            -- check that the cell is revealed
            post.cells[1][1] = Revealed
            -- check that adjacent cells are revealed
            all x, y: Int | {
                ((x = 0 or x = 1 or x = 2) and (y = 0 or y = 1 or y = 2)) implies {
                    post.cells[x][y] = Revealed
                }
            }
        }
    } is sat }

    -- test game win condition
    test expect { testGameWin: {
        some pre, post: Board | {
            game_trace_kindaSmartAlgo
            -- set up a board state where the game is won
            all row, col: Int | {
                (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                    pre.mines[row][col] = 1 implies { pre.cells[row][col] = Hidden }
                    pre.mines[row][col] = 0 implies { pre.cells[row][col] = Revealed }
                }
            }
            won[pre]
            -- check that no further moves are made
            doNothing[pre, post]
        }
    } is sat }

    -- test game loss condition
    test expect { testGameLoss: {
        some pre, post: Board | {
            game_trace_kindaSmartAlgo
            -- set up a board state where the game is lost
            pre.mines[1][1] = 1
            pre.cells[1][1] = Revealed
            lost[pre]
            -- check that no further moves are made
            doNothing[pre, post]
        }
    } is sat }
}

--these tests take a quite a few minutes to run but they do pass
test suite for game_trace_relativelySmartestAlgo {
    --initial board state
    test expect { testInitialBoardState: {
        some pre: Board | {
            initial[pre]
            game_trace_relativelySmartestAlgo
            all row, col: Int | (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                pre.cells[row][col] = Hidden
            }
        }
    } is sat }

    -- the first move follows the relativelySmartestAlgo pred
    test expect { testFirstMoveRelativelySmartestAlgo: {
        some pre, post: Board | {
            initial[pre]
            game_trace_relativelySmartestAlgo
            no prev: Board | Game.next[prev] = pre
            Game.first = pre
            some row, col: Int | {
                relativelySmartestAlgo[pre, row, col]
                openTile[pre, post, row, col]
                pre.cells[row][col] = Hidden
                post.cells[row][col] = Revealed
            }
        }
    } is sat }

    -- exists a board where no mines are clickes
    test expect { testSubsequentMovesRelativelySmartestAlgo: {
        some pre, post: Board | {
            game_trace_relativelySmartestAlgo
            some row, col: Int | {
                relativelySmartestAlgo[pre, row, col]
                openTile[pre, post, row, col]
                pre.cells[row][col] = Hidden
                post.cells[row][col] = Revealed
            }
        }
    } is sat }

    -- win condition
    test expect { testGameWin: {
        some pre, post: Board | {
            game_trace_relativelySmartestAlgo
            all row, col: Int | {
                (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                    pre.mines[row][col] = 1 implies { pre.cells[row][col] = Hidden }
                    pre.mines[row][col] = 0 implies { pre.cells[row][col] = Revealed }
                }
            }
            won[pre]
            doNothing[pre, post]
        }
    } is sat }

    --loss condition
    test expect { testGameLoss: {
        some pre, post: Board | {
            game_trace_relativelySmartestAlgo
            pre.mines[1][1] = 1
            pre.cells[1][1] = Revealed
            lost[pre]
            doNothing[pre, post]
        }
    } is sat }
}


--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
/// amanda - john this was from your file, but im not sure if they work because i couldnt get them to run on my computer
    -- like they dont pass or fail, they just dont run
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


// pred leapInLogicBaseCaseSat{
//     some pre: Board | { 
//             -- cell at (1, 1) is a hidden tile 
//             pre.cells[1][1] = Hidden
//              -- cell at (2, 2) is a revealed 1 tile adjacent to a definetlyAMineOneTile
//             pre.cells[2][2] = Revealed
//             pre.adjacentMines[2][2] = 1
//             --cell at 3,3 is a hidden one mine tile
//             pre.cells[3][3] = Hidden
//             pre.mines[3][3] = 1
//             --cell at 4,4 is has 1 adjacent mine and all other adjacent tiles are open
//             pre.cells[4][4] = Revealed
//             pre.adjacentMines[4][4] = 1
//             pre.cells[5][5] = Revealed
//             pre.cells[5][4] = Revealed
//             pre.cells[4][5] = Revealed
//             pre.cells[5][3] = Revealed
//             pre.cells[4][3] = Revealed
//             pre.cells[3][4] = Revealed
//             abletoMakeLeapInLogic[pre,1,1]
//     }
// }

// pred leapInLogicBaseCaseUnSatFirstLayerFails{
//     some pre: Board | { 
//             -- cell at (1, 1) is a hidden tile 
//             pre.cells[1][1] = Hidden
//              -- cell at (2, 2) is a revealed 1 tile adjacent to a definetlyAMineOneTile
//             pre.cells[2][2] = Hidden
//             pre.adjacentMines[2][2] = 1
//             --cell at 3,3 is a hidden one mine tile
//             pre.cells[3][3] = Hidden
//             pre.mines[3][3] = 1
//             --cell at 4,4 is has 1 adjacent mine and all other adjacent tiles are open
//             pre.cells[4][4] = Revealed
//             pre.adjacentMines[4][4] = 1
//             pre.cells[5][5] = Revealed
//             pre.cells[5][4] = Hidden
//             pre.cells[4][5] = Revealed
//             pre.cells[5][3] = Revealed
//             pre.cells[4][3] = Revealed
//             pre.cells[3][4] = Revealed
//             abletoMakeLeapInLogic[pre,1,1]
//     }
// }

// pred leapInLogicUnSatNotAbleNotSecondLayerFails{
//     some pre: Board | { 
//             -- cell at (1, 1) is a hidden tile 
//             pre.cells[1][1] = Hidden
//              -- cell at (2, 2) is a revealed 1 tile adjacent to a definetlyAMineOneTile
//             pre.cells[2][2] = Revealed
//             pre.adjacentMines[2][2] = 1
//             --cell at 3,3 is a hidden one mine tile
//             pre.cells[3][3] = Hidden
//             pre.mines[3][3] = 1
//             --cell at 4,4 is has 1 adjacent mine and all other adjacent tiles are open
//             pre.cells[4][4] = Hidden
//             pre.adjacentMines[4][4] = 1
//             pre.cells[5][5] = Revealed
//             pre.cells[5][4] = Revealed
//             pre.cells[4][5] = Revealed
//             pre.cells[5][3] = Revealed
//             pre.cells[4][3] = Revealed
//             pre.cells[3][4] = Revealed
//             abletoMakeLeapInLogic[pre,1,1]
//     }
// }

// --References ableToMakeLeapInLogic in predicates
// test suite for abletoMakeLeapInLogic{
//     test expect{ basetestfo:{
//         leapInLogicBaseCaseSat
//     } is sat}
//     test expect{ FirstLayerFails:{
//         leapInLogicBaseCaseUnSatFirstLayerFails
//     } is unsat}
//     test expect{ SecondLayerFails:{
//         leapInLogicUnSatNotAbleNotSecondLayerFails
//     } is unsat}
// }