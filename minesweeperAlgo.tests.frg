#lang forge

open "minesweeper_card.frg"

// test suite for adjacentHiddenChecker{
//     test expect{ basicSat:{
//         some pre:Board|{
//             pre.cells[1][1] = Revealed
//             pre.cells[1][2] = Hidden
//             pre.cells[1][0] = Revealed
//             pre.cells[2][1] = Revealed
//             pre.cells[0][1] = Revealed
//             pre.cells[2][2] = Revealed
//             pre.cells[2][0] = Revealed
//             pre.cells[0][2] = Revealed
//             pre.cells[0][0] = Revealed
//             adjacentHiddenChecker[pre,1,1]
//         }
//     } is sat}
//     test expect{ basicUnSat:{
//         some pre:Board|{
//             pre.cells[1][2] = Revealed
//             pre.cells[1][0] = Revealed
//             pre.cells[2][1] = Revealed
//             pre.cells[0][1] = Revealed
//             pre.cells[2][2] = Revealed
//             pre.cells[2][0] = Revealed
//             pre.cells[0][2] = Revealed
//             pre.cells[0][0] = Revealed
//             adjacentHiddenChecker[pre,1,1]
//         }
//     } is unsat}
//     test expect{ allBasicSat:{
//         some pre:Board|{
//             pre.cells[1][2] = Hidden
//             pre.cells[1][0] = Hidden
//             pre.cells[2][1] = Hidden
//             pre.cells[0][1] = Hidden
//             pre.cells[2][2] = Hidden
//             pre.cells[2][0] = Hidden
//             pre.cells[0][2] = Hidden
//             pre.cells[0][0] = Hidden
//             adjacentHiddenChecker[pre,1,1]
//         }
//     } is sat}
// }

// test suite for ableToGatherSpace {
    
//     -- a board with one riskless position (0 adjacent mines) revealed
//     test expect { testAbleToGatherSpaceExists: {
//         some pre: Board | {
//             -- set up the board with one riskless position
//             pre.cells[1][1] = Revealed
//             pre.adjacentMines[1][1] = 0
//             adjacentHiddenChecker[pre, 1, 1]
//             ableToGatherSpace[pre]
//         }
//     } is sat }

//     -- a board with multiple riskless positions
//     test expect { testMultipleRisklessPositions: {
//         some pre: Board | {
//             -- set up the board with riskless positions
//             pre.cells[1][1] = Revealed
//             pre.adjacentMines[1][1] = 0
//             adjacentHiddenChecker[pre, 1, 1]
//             pre.cells[2][2] = Revealed
//             pre.adjacentMines[2][2] = 0
//             adjacentHiddenChecker[pre, 2, 2]
//             ableToGatherSpace[pre]
//         }
//     } is sat }
// }


// pred testingforOneTileAdjHidden{
//     some pre: Board | { 
//             -- cell at (1, 1) has all but one tile hidden
//             pre.adjacentMines[1][1] = 1
//             pre.cells[1][2] = Hidden
//             pre.cells[1][0] = Revealed
//             pre.cells[2][1] = Revealed
//             pre.cells[0][1] = Revealed
//             pre.cells[2][2] = Revealed
//             pre.cells[2][0] = Revealed
//             pre.cells[0][2] = Revealed
//             pre.cells[0][0] = Revealed
//             -- everything else doesn't matter for this pred
//             OneAdjacentHiddens[pre,1,1]
//     }
// }

// pred testingforOneTileAdjHiddenUnsat{
//     some pre: Board | { 
//             -- cell at (1, 1) has all but one tile hidden
//             pre.adjacentMines[1][1] = 1
//             pre.cells[1][2] = Hidden
//             pre.cells[1][0] = Hidden
//             pre.cells[2][1] = Revealed
//             pre.cells[0][1] = Revealed
//             pre.cells[2][2] = Revealed
//             pre.cells[2][0] = Revealed
//             pre.cells[0][2] = Revealed
//             pre.cells[0][0] = Revealed
//             -- everything else doesn't matter for this pred
//             OneAdjacentHiddens[pre,1,1]
//     }
// }

// pred mineTileIsAHiddenOneAdjMineTile{
//     some pre: Board | { 
//         -- cell at (2, 2) is a hidden mine tile with one hidden mine tile (edge case)
//         pre.cells[2][2] = Hidden
//         pre.adjacentMines[2][2] = 1
//         pre.mines[2][2] = 1
//         pre.cells[3][3] = Revealed
//         pre.cells[2][3] = Revealed
//         pre.cells[3][2] = Hidden
//         pre.mines[3][2] = 1
//         pre.cells[1][2] = Revealed
//         pre.cells[2][1] = Revealed
//         pre.cells[1][3] = Revealed
//         pre.cells[3][1] = Revealed
//         OneAdjacentHiddens[pre,2,2]
//     }
// }


// --References OneAdjacentHiddens in Predicates
// test suite for OneAdjacentHiddens{
//     test expect{ testingforOneTileAdjHiddenSat:{
//         testingforOneTileAdjHidden
//     } is sat }
//     test expect{ testforOneTileAdjHiddenUnSat:{
//         testingforOneTileAdjHiddenUnsat
//     } is unsat }
//     test expect{ testingmineTileIsAHiddenOneAdjMineTile:{
//         mineTileIsAHiddenOneAdjMineTile
//     } is unsat }
// }

// pred testingfordefinetlyAMineOneTileSat{
//     some pre: Board | { 
//         -- cell at (1, 1) is a hidden mine tile 
//         pre.mines[1][1] = 1
//         pre.cells[1][1] = Hidden
//         -- cell at (2, 2) has all but one tile hidden
//         pre.cells[2][2] = Revealed
//         pre.adjacentMines[2][2] = 1
//         pre.cells[3][3] = Revealed
//         pre.cells[2][3] = Revealed
//         pre.cells[3][2] = Revealed
//         pre.cells[1][2] = Revealed
//         pre.cells[2][1] = Revealed
//         pre.cells[1][3] = Revealed
//         pre.cells[3][1] = Revealed
//         --all other cells are hidden
//         pre.cells[0][0] = Hidden
//         pre.cells[1][0] = Hidden
//         pre.cells[0][1] = Hidden
//         pre.cells[0][2] = Hidden
//         pre.cells[2][0] = Hidden
//         definetlyAMineOneTile[pre,1,1]
//     }
// }

// pred testingfordefinetlyAMineOneTileUnsat{
//     some pre: Board | { 
//         -- cell at (1, 1) is a hidden mine tile 
//         pre.mines[1][1] = 1
//         pre.cells[1][1] = Hidden
//         -- cell at (2, 2) has all but one tile hidden
//         pre.cells[2][2] = Revealed
//         pre.adjacentMines[2][2] = 1
//         pre.cells[3][3] = Revealed
//         pre.cells[2][3] = Revealed
//         pre.cells[3][2] = Hidden
//         pre.cells[1][2] = Revealed
//         pre.cells[2][1] = Revealed
//         pre.cells[1][3] = Revealed
//         pre.cells[3][1] = Revealed
//         --all other cells are hidden
//         pre.cells[0][0] = Hidden
//         pre.cells[1][0] = Hidden
//         pre.cells[0][1] = Hidden
//         pre.cells[0][2] = Hidden
//         pre.cells[2][0] = Hidden
//         definetlyAMineOneTile[pre,1,1]
//     }
// }

// pred backendEdgeCasemineTileIsAHiddenOneAdjMineTile {
//     some pre: Board | { 
//         -- cell at (1, 1) is a hidden mine tile 
//         pre.mines[1][1] = 1
//         pre.cells[1][1] = Hidden
//         -- cell at (2, 2) has all but one tile hidden
//         -- cell at (2, 2) is a hidden mine tile with one hidden mine tile (edge case)
//         pre.cells[2][2] = Hidden
//         pre.adjacentMines[2][2] = 1
//         pre.mines[2][2] = 1
//         pre.cells[3][3] = Revealed
//         pre.cells[2][3] = Revealed
//         pre.cells[3][2] = Revealed
//         pre.cells[1][2] = Revealed
//         pre.cells[2][1] = Revealed
//         pre.cells[1][3] = Revealed
//         pre.cells[3][1] = Revealed
//         -- All Other Cells are Hidden
//         pre.cells[0][0] = Hidden
//         pre.cells[1][0] = Hidden
//         pre.cells[0][1] = Hidden
//         pre.cells[0][2] = Hidden
//         pre.cells[2][0] = Hidden
//         definetlyAMineOneTile[pre,1,1]
//     }
// }

// --References definetlyAMineOneTile in predicates
// test suite for definetlyAMineOneTile{
//     test expect{ testingfordefinetlyAMineOneTilUnSat:{
//         testingfordefinetlyAMineOneTileUnsat
//     } is unsat }
//     test expect{ testingbackendEdgeCasemineTileIsAHiddenOneAdjMineTile:{
//         backendEdgeCasemineTileIsAHiddenOneAdjMineTile
//     } is unsat }
// }

// test suite for game_trace_DumbAlgo {

//     -- test that a first move exists
//     test expect { testFirstMove: {
//         some pre, post: Board | {
//             initial[pre]
//             game_trace_DumbAlgo
//             no prev: Board | Game.next[prev] = pre
//             Game.first = pre
//             some row, col: Int | {
//                 dumbAlgo[pre, row, col]
//                 openTile[pre, post, row, col]
//                 -- check that the first move reveals a cell
//                 pre.cells[row][col] = Hidden
//                 post.cells[row][col] = Revealed
//             }
//         }
//     } is sat }

//     -- test that there exists games where the board reveals adjacent cells if no adjacent mines
//     test expect { testRevealAdjacentCells: {
//         some pre, post: Board | {
//             game_trace_DumbAlgo
//             -- set up a board state with a cell having no adjacent mines
//             pre.cells[1][1] = Hidden
//             pre.adjacentMines[1][1] = 0
//             openTile[pre, post, 1, 1]
//             -- check that the cell is revealed
//             post.cells[1][1] = Revealed
//             -- check that adjacent cells are revealed
//             all x, y: Int | {
//                 ((x = 0 or x = 1 or x = 2) and (y = 0 or y = 1 or y = 2)) implies {
//                     post.cells[x][y] = Revealed
//                 }
//             }
//         }
//     } is sat }

//     -- test that a win game exists
//     test expect { testGameWin: {
//         some pre, post: Board | {
//             game_trace_DumbAlgo
//             -- set up a board state where the game is won
//             all row, col: Int | {
//                 (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
//                     pre.mines[row][col] = 1 implies { pre.cells[row][col] = Hidden }
//                     pre.mines[row][col] = 0 implies { pre.cells[row][col] = Revealed }
//                 }
//             }
//             won[pre]
//             -- check that no further moves are made
//             doNothing[pre, post]
//         }
//     } is sat }

//     -- test that a lost game exists
//     test expect { testGameLoss: {
//         some pre, post: Board | {
//             game_trace_DumbAlgo
//             -- set up a board state where the game is lost
//             pre.mines[1][1] = 1
//             pre.cells[1][1] = Revealed
//             lost[pre]
//             -- check that no further moves are made
//             doNothing[pre, post]
//         }
//     } is sat }
// }


// test suite for kindaSmartAlgo {

//     -- test ableToGatherSpace condition
//     test expect { testAbleToGatherSpace: {
//         some pre: Board | {
//             -- set up a board state with a riskless position
//             ableToGatherSpace[pre]
//             some row, col: Int | {
//                 kindaSmartAlgo[pre, row, col]
//                 -- check that the chosen move has zero adjacent mines, is revealed, and has hidden adjacent tiles
//                 pre.adjacentMines[row][col] = 0
//                 pre.cells[row][col] = Revealed
//                 adjacentHiddenChecker[pre, row, col]
//             }
//         }
//     } is sat }

//     -- test not definetlyAMineOneTile condition
//     test expect { testNotDefinetlyAMineOneTile: {
//         some pre: Board | {
//             -- set up a board state where a tile is not guaranteed to be a mine
//             some row, col: Int | {
//                 kindaSmartAlgo[pre, row, col]
//                 -- check that the chosen move is not on a guaranteed mine tile
//                 not definetlyAMineOneTile[pre, row, col]
//             }
//         }
//     } is sat }

//     -- test valid move when neither ableToGatherSpace nor definetlyAMineOneTile applies
//     test expect { testValidMove: {
//         some pre: Board | {
//             -- set up a board state with no riskless positions and no guaranteed mine tiles
//             not ableToGatherSpace[pre]
//             all row, col: Int | not definetlyAMineOneTile[pre, row, col]
//             some row, col: Int | {
//                 kindaSmartAlgo[pre, row, col]
//                 -- check that the move is within bounds (valid move)
//                 inBounds[row, col]
//             }
//         }
//     } is sat }
// }

// test suite for adjacentToAMineOneTile {
//     -- a cell that is not adjacent to any mine tile
//     test expect { testNotAdjacentToAnyMineTile: {
//         some pre: Board | {
//             -- set up a board state with no mine tiles adjacent
//             all x, y: Int | not definetlyAMineOneTile[pre, x, y]
//             pre.cells[2][2] = Revealed
//             not adjacentToAMineOneTile[pre, 2, 2]
//             #{x, y: Int | (x >= 1 and x <= 3 and y >= 1 and y <= 3) and definetlyAMineOneTile[pre, x, y]} = 0
//         }
//     } is sat }

//     -- a cell adjacent to multiple mine tiles
//     test expect { testAdjacentToMultipleMineTiles: {
//         some pre: Board | {
//             -- set up a board state with multiple mine tiles adjacent
//             definetlyAMineOneTile[pre, 1, 1]
//             definetlyAMineOneTile[pre, 1, 2]
//             pre.cells[2][2] = Revealed
//             not adjacentToAMineOneTile[pre, 2, 2]
//             #{x, y: Int | (x >= 1 and x <= 3 and y >= 1 and y <= 3) and definetlyAMineOneTile[pre, x, y]} > 1
//         }
//     } is unsat }
// }

// test suite for game_trace_kindaSmartAlgo {

//     -- test initial board state
//     test expect { testInitialBoardState: {
//         some pre: Board | {
//             initial[pre]
//             game_trace_kindaSmartAlgo
//             -- check all cells are hidden
//             all row, col: Int | (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
//                 pre.cells[row][col] = Hidden
//             }
//         }
//     } is sat }

//     -- test the first move
//     test expect { testFirstMove: {
//         some pre, post: Board | {
//             initial[pre]
//             game_trace_kindaSmartAlgo
//             no prev: Board | Game.next[prev] = pre
//             Game.first = pre
//             some row, col: Int | {
//                 kindaSmartAlgo[pre, row, col]
//                 openTile[pre, post, row, col]
//                 -- check that the first move reveals a cell
//                 pre.cells[row][col] = Hidden
//                 post.cells[row][col] = Revealed
//             }
//         }
//     } is sat }

//     -- test revealing adjacent cells if no adjacent mines
//     test expect { testRevealAdjacentCells: {
//         some pre, post: Board | {
//             game_trace_kindaSmartAlgo
//             -- set up a board state with a cell having no adjacent mines
//             pre.cells[1][1] = Hidden
//             pre.adjacentMines[1][1] = 0
//             openTile[pre, post, 1, 1]
//             -- check that the cell is revealed
//             post.cells[1][1] = Revealed
//             -- check that adjacent cells are revealed
//             all x, y: Int | {
//                 ((x = 0 or x = 1 or x = 2) and (y = 0 or y = 1 or y = 2)) implies {
//                     post.cells[x][y] = Revealed
//                 }
//             }
//         }
//     } is sat }

//     -- test game win condition
//     test expect { testGameWin: {
//         some pre, post: Board | {
//             game_trace_kindaSmartAlgo
//             -- set up a board state where the game is won
//             all row, col: Int | {
//                 (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
//                     pre.mines[row][col] = 1 implies { pre.cells[row][col] = Hidden }
//                     pre.mines[row][col] = 0 implies { pre.cells[row][col] = Revealed }
//                 }
//             }
//             won[pre]
//             -- check that no further moves are made
//             doNothing[pre, post]
//         }
//     } is sat }

//     -- test game loss condition
//     test expect { testGameLoss: {
//         some pre, post: Board | {
//             game_trace_kindaSmartAlgo
//             -- set up a board state where the game is lost
//             pre.mines[1][1] = 1
//             pre.cells[1][1] = Revealed
//             lost[pre]
//             -- check that no further moves are made
//             doNothing[pre, post]
//         }
//     } is sat }
// }

// test suite for OneAdjacentHiddens {

//     -- test a tile with exactly one adjacent hidden tile
//     test expect { testOneAdjacentHiddenTile: {
//         all pre: Board | {
//             -- set up a board state with one adjacent hidden tile
//             pre.cells[1][1] = Revealed
//             pre.cells[0][0] = Hidden
//             pre.cells[0][1] != Hidden
//             pre.cells[0][2] != Hidden
//             pre.cells[1][0] != Hidden
//             pre.cells[1][2] != Hidden
//             pre.cells[2][0] != Hidden
//             pre.cells[2][1] != Hidden
//             pre.cells[2][2] != Hidden
//             OneAdjacentHiddens[pre, 1, 1]
//         }
//     } is sat }

//     -- test a tile with no adjacent hidden tiles
//     test expect { testNoAdjacentHiddenTiles: {
//         all pre: Board | {
//             -- set up a board state with no adjacent hidden tiles
//             pre.cells[1][1] = Revealed
//             all x, y: Int | (x >= 0 and x <= 2 and y >= 0 and y <= 2) implies { pre.cells[x][y] != Hidden }
//             not OneAdjacentHiddens[pre, 1, 1]
//         }
//     } is sat }

//     -- test a tile with multiple adjacent hidden tiles
//     test expect { testMultipleAdjacentHiddenTiles: {
//         all pre: Board | {
//             -- set up a board state with multiple adjacent hidden tiles
//             pre.cells[1][1] = Revealed
//             pre.cells[0][0] = Hidden
//             pre.cells[0][2] = Hidden
//             pre.cells[1][0] != Hidden
//             pre.cells[1][2] != Hidden
//             pre.cells[2][0] != Hidden
//             pre.cells[2][1] != Hidden
//             pre.cells[2][2] != Hidden
//             not OneAdjacentHiddens[pre, 1, 1]
//         }
//     } is sat }

//     -- test invalid configuration yielding unsat
//     test expect { testInvalidAdjacentHiddenTileConfiguration: {
//         some pre: Board | {
//             -- set up a board state where the conditions cannot be met
//             pre.cells[1][1] = Revealed
//             pre.cells[0][0] = Revealed
//             pre.cells[0][1] = Revealed
//             pre.cells[0][2] = Revealed
//             pre.cells[1][0] = Revealed
//             pre.cells[1][2] = Revealed
//             pre.cells[2][0] = Revealed
//             pre.cells[2][1] = Revealed
//             pre.cells[2][2] = Revealed
//             OneAdjacentHiddens[pre, 1, 1]
//         }
//     } is unsat }

//     -- test more than one adjacent hidden tile yielding unsat
//     test expect { testMoreThanOneAdjacentHiddenTileConfiguration: {
//         some pre: Board | {
//             -- set up a board state where there are multiple adjacent hidden tiles
//             pre.cells[1][1] = Revealed
//             pre.cells[0][0] = Hidden
//             pre.cells[0][1] = Hidden
//             pre.cells[0][2] != Hidden
//             pre.cells[1][0] != Hidden
//             pre.cells[1][2] != Hidden
//             pre.cells[2][0] != Hidden
//             pre.cells[2][1] != Hidden
//             pre.cells[2][2] != Hidden
//             OneAdjacentHiddens[pre, 1, 1]
//         }
//     } is unsat }
// }

test suite for definetlyAMineOneTile {

    -- test a cell that is definitely a mine based on the adjacent cells
    test expect { testDefinetlyAMineOneTileTrue: {
        some pre: Board | {
            pre.cells[1][1] = Hidden
            pre.cells[0][0] = Revealed
            pre.adjacentMines[0][0] = 1
            pre.adjacentMines[0][1] = 1
            pre.adjacentMines[0][2] = 1
            pre.adjacentMines[1][0] = 1
            pre.adjacentMines[1][2] = 1
            pre.adjacentMines[2][0] = 1
            pre.adjacentMines[2][1] = 1
            pre.adjacentMines[2][2] = 1
            pre.cells[0][1] = Revealed
            pre.cells[0][2] = Revealed
            pre.cells[1][0] = Revealed
            pre.cells[1][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[2][2] = Revealed
            OneAdjacentHiddens[pre, 0, 0]
            definetlyAMineOneTile[pre, 1, 1]
        }
    } is sat }

    -- test a cell that is not definitely a mine
    test expect { testDefinetlyAMineOneTileFalse: {
        some pre: Board | {
            pre.cells[1][1] = Hidden
            pre.cells[0][0] = Revealed
            pre.adjacentMines[0][0] = 0
            pre.adjacentMines[0][1] = 0
            pre.adjacentMines[0][2] = 0
            pre.adjacentMines[1][0] = 0
            pre.adjacentMines[1][2] = 1
            pre.adjacentMines[2][0] = 0
            pre.adjacentMines[2][1] = 0
            pre.adjacentMines[2][2] = 0
            pre.cells[0][1] = Revealed
            pre.cells[0][2] = Revealed
            pre.cells[1][0] = Revealed
            pre.cells[1][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[2][2] = Revealed
            OneAdjacentHiddens[pre, 0, 0]
            definetlyAMineOneTile[pre, 1, 1]
        }
    } is unsat }

}


/// amanda - john this was from your file, but im not sure if they work because i couldnt get them to run on my computer
    -- like they dont pass or fail, they just dont run
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