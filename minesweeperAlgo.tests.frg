#lang forge

open "minesweeper_card.frg"

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

// test suite for ableToGatherSpace{
//      test expect{ allButOneRevealed:{
//         some b: Board | {
//             -- a non-mine cell is revealed
//             b.adjacentMines[1][1] = 0
//             b.cells[1][1] = Revealed
//             all row, col: Int | {
//                 (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW) 
//                 (row != 1 and col != 1) implies {
//                     b.cells[row][col] = Hidden
//                     b.adjacentMines[row][col] = 0
//                 }
//             }
//             ableToGatherSpace[b]
//         }
//     } is sat}
// }


pred testingforOneTileAdjHidden{
    some pre: Board | { 
            -- cell at (1, 1) has all but one tile hidden
            pre.adjacentMines[1][1] = 1
            pre.cells[1][2] = Hidden
            pre.cells[1][0] = Revealed
            pre.cells[2][1] = Revealed
            pre.cells[0][1] = Revealed
            pre.cells[2][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[0][2] = Revealed
            pre.cells[0][0] = Revealed
            -- everything else doesn't matter for this pred
            OneAdjacentHiddens[pre,1,1]
    }
}

pred testingforOneTileAdjHiddenUnsat{
    some pre: Board | { 
            -- cell at (1, 1) has all but one tile hidden
            pre.adjacentMines[1][1] = 1
            pre.cells[1][2] = Hidden
            pre.cells[1][0] = Hidden
            pre.cells[2][1] = Revealed
            pre.cells[0][1] = Revealed
            pre.cells[2][2] = Revealed
            pre.cells[2][0] = Revealed
            pre.cells[0][2] = Revealed
            pre.cells[0][0] = Revealed
            -- everything else doesn't matter for this pred
            OneAdjacentHiddens[pre,1,1]
    }
}

pred mineTileIsAHiddenOneAdjMineTile{
    some pre: Board | { 
        -- cell at (2, 2) is a hidden mine tile with one hidden mine tile (edge case)
        pre.cells[2][2] = Hidden
        pre.adjacentMines[2][2] = 1
        pre.mines[2][2] = 1
        pre.cells[3][3] = Revealed
        pre.cells[2][3] = Revealed
        pre.cells[3][2] = Hidden
        pre.mines[3][2] = 1
        pre.cells[1][2] = Revealed
        pre.cells[2][1] = Revealed
        pre.cells[1][3] = Revealed
        pre.cells[3][1] = Revealed
        OneAdjacentHiddens[pre,2,2]
    }
}


--References OneAdjacentHiddens in Predicates
test suite for OneAdjacentHiddens{
    test expect{testingforOneTileAdjHiddenSat:{
        testingforOneTileAdjHidden
    } is sat }
    test expect{ testforOneTileAdjHiddenUnSat:{
        testingforOneTileAdjHiddenUnsat
    } is unsat }
    test expect{ testingmineTileIsAHiddenOneAdjMineTile:{
        mineTileIsAHiddenOneAdjMineTile
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
    test expect{testfordefinetlyAMineOneTileSat:{
        testingfordefinetlyAMineOneTileSat
    } is sat }
    test expect{ testingfordefinetlyAMineOneTilUnSat:{
        testingfordefinetlyAMineOneTileUnsat
    } is unsat }
    test expect{ testingbackendEdgeCasemineTileIsAHiddenOneAdjMineTile:{
        backendEdgeCasemineTileIsAHiddenOneAdjMineTile
    } is unsat }
}



pred leapInLogicBaseCaseSat{
    some pre: Board | { 
            -- cell at (1, 1) is a hidden tile 
            pre.cells[1][1] = Hidden
             -- cell at (2, 2) is a revealed 1 tile adjacent to a definetlyAMineOneTile
            pre.cells[2][2] = Revealed
            pre.adjacentMines[2][2] = 1
            --cell at 3,3 is a hidden one mine tile
            pre.cells[3][3] = Hidden
            pre.mines[3][3] = 1
            --cell at 4,4 is has 1 adjacent mine and all other adjacent tiles are open
            pre.cells[4][4] = Revealed
            pre.adjacentMines[4][4] = 1
            pre.cells[5][5] = Revealed
            pre.cells[5][4] = Revealed
            pre.cells[4][5] = Revealed
            pre.cells[5][3] = Revealed
            pre.cells[4][3] = Revealed
            pre.cells[3][4] = Revealed
            abletoMakeLeapInLogic[pre,1,1]
    }
}

pred leapInLogicBaseCaseUnSatFirstLayerFails{
    some pre: Board | { 
            -- cell at (1, 1) is a hidden tile 
            pre.cells[1][1] = Hidden
             -- cell at (2, 2) is a revealed 1 tile adjacent to a definetlyAMineOneTile
            pre.cells[2][2] = Hidden
            pre.adjacentMines[2][2] = 1
            --cell at 3,3 is a hidden one mine tile
            pre.cells[3][3] = Hidden
            pre.mines[3][3] = 1
            --cell at 4,4 is has 1 adjacent mine and all other adjacent tiles are open
            pre.cells[4][4] = Revealed
            pre.adjacentMines[4][4] = 1
            pre.cells[5][5] = Revealed
            pre.cells[5][4] = Hidden
            pre.cells[4][5] = Revealed
            pre.cells[5][3] = Revealed
            pre.cells[4][3] = Revealed
            pre.cells[3][4] = Revealed
            abletoMakeLeapInLogic[pre,1,1]
    }
}

pred leapInLogicUnSatNotAbleNotSecondLayerFails{
    some pre: Board | { 
            -- cell at (1, 1) is a hidden tile 
            pre.cells[1][1] = Hidden
             -- cell at (2, 2) is a revealed 1 tile adjacent to a definetlyAMineOneTile
            pre.cells[2][2] = Revealed
            pre.adjacentMines[2][2] = 1
            --cell at 3,3 is a hidden one mine tile
            pre.cells[3][3] = Hidden
            pre.mines[3][3] = 1
            --cell at 4,4 is has 1 adjacent mine and all other adjacent tiles are open
            pre.cells[4][4] = Hidden
            pre.adjacentMines[4][4] = 1
            pre.cells[5][5] = Revealed
            pre.cells[5][4] = Revealed
            pre.cells[4][5] = Revealed
            pre.cells[5][3] = Revealed
            pre.cells[4][3] = Revealed
            pre.cells[3][4] = Revealed
            abletoMakeLeapInLogic[pre,1,1]
    }
}

// --References ableToMakeLeapInLogic in predicates
test suite for abletoMakeLeapInLogic{
    test expect{ basetestfordefinetlyAMineOneTileSat:{
        leapInLogicBaseCaseSat
    } is sat}
    test expect{ FirstLayerFails:{
        leapInLogicBaseCaseUnSatFirstLayerFails
    } is unsat}
    test expect{ SecondLayerFails:{
        leapInLogicUnSatNotAbleNotSecondLayerFails
    } is unsat}
}

test suite for dumbAlgo{
    test expect{ passEasyTest:{
        some pre: Board,row :Int,col :Int|{
            ableToGatherSpace[pre]
            pre.adjacentMines[row][col] = 0
            pre.cells[row][col] = Revealed
            adjacentHiddenChecker[pre,row,col]
        }
    } is sat}
}




