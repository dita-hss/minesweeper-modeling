#lang forge

open "t3.frg"

test suite for wellformed {

    -- ensure that a wellformed board has cells and mines are ignored and set to zero outside the defined board range
    test expect { testOutOfBounds: {
        some b: Board | {
            -- all cells outside the board range are ignored and have no mines
            all x: Int, y: Int | (x < MIN or x > MAXCOL or y < MIN or y > MAXROW) implies { b.cells[x][y] = Ignored and b.mines[x][y] = 0 }
            -- wellformed board
            wellformed[b]
        }
    } is sat }

    -- cells within the boundaries of the board are not ignored and have mines set to either 0 or 1
    test expect { testInBounds: {
        some b: Board | {
            -- all cells within the board range are not ignored and have mines set to either 0 or 1
            all x: Int, y: Int | (x >= MIN and x <= MAXCOL and y >= MIN and y <= MAXROW) implies { b.cells[x][y] != Ignored and (b.mines[x][y] = 0 or b.mines[x][y] = 1)}
            -- wellformed board
            wellformed[b]
        }
    } is sat }

    -- the number of mines in the board is less than or equal to the maximum number of mines
    test expect { testMaxMinesBound: {
        some b: Board | {
            -- the number of mines in the board is less than or equal to the maximum number of mines
            #{row, col: Int | b.mines[row][col] = 1} <= MAXMINES
            -- wellformed board
            wellformed[b]
        }
    } is sat }

    -- all cells within the board range have the correct number of adjacent mines
    test expect { testAdjacentMineCount: {
        some b: Board | {
            -- all cells within the board range have the correct number of adjacent mines
            all x: Int, y: Int | (x >= MIN and x <= MAXCOL and y >= MIN and y <= MAXROW) implies { adjacentMinesPopulate[b, x, y] }
            -- wellformed board
            wellformed[b]
        }
    } is sat }

    -- the out of bounds cells are not ignored and has no mines
    test expect { testOutOfBoundsNotSat: {
        some b: Board |{ 
            -- out of bounds
            some x: Int, y: Int | {
                (x < MIN or x > MAXCOL or y < MIN or y > MAXROW)
                -- not ignored
                b.cells[x][y] != Ignored
            }
            -- wellformed board
            wellformed[b]
        }
    } is unsat }

    -- cells within the boundaries of the board are not ignored
    test expect { testCellsInBounds: {
        some b: Board | {
            some x: Int, y: Int | { 
                -- in bounds
                (x >= MIN and x <= MAXCOL and y >= MIN and y <= MAXROW)  
                -- not ignored
                b.cells[x][y] = Ignored
            }
            -- wellformed board
            wellformed[b]
        }
    } is unsat }

    -- the number of adjacent mines for each cell is incorrect
    test expect { testIncorrectAdjacentMines: {
        some b: Board | {
            some x: Int, y: Int | {
                -- in bounds
                (x >= MIN and x <= MAXCOL and y >= MIN and y <= MAXROW) 
                -- incorrect adjacent mines / not populated
                not adjacentMinesPopulate[b, x, y]
            }
            -- wellformed board
            wellformed[b]
        }
    } is unsat }
}

test suite for initial {
    -- all cells are hidden initially
    test expect { testAllCellsHidden: {
        some b: Board | { 
            -- all cells are hidden initially
            all x: Int, y: Int | (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) implies { b.cells[x][y] = Hidden }
            -- initial board
            initial[b]
        }
    } is sat }

    -- there exists an unhidden cell in the board
    test expect { notAllCellsHidden: {
        some b: Board | {
            some x: Int, y: Int | {
                -- in bounds
                (x >= MIN && x <= MAXCOL && y >= MIN && y <= MAXROW) 
                -- not hidden
                b.cells[x][y] != Hidden
            }
            -- initial board
            initial[b]
        }
    } is unsat }
}

test suite for adjacentMinesPopulate {
    -- a cell with no adjacent mines should have the adjacentMines set to 0
    test expect { testNoAdjacentMines: {
        some b: Board | {
            -- cell at (1, 1) has no adjacent mines
            b.mines[1][1] = 0 
            -- all cells around (1, 1) have no mines
            all x: Int, y: Int |{ (x = 1 and y = 1) or b.mines[x][y] = 0 }
            -- adjacentMines should be 0
            b.adjacentMines[1][1] = 0
            -- predicate should be true
            adjacentMinesPopulate[b, 1, 1]
        }
    } is sat }

    -- random number of mines around board
    test expect { testRandomMines : {
        some b: Board | {
            -- all cells around (1, 1) have mines
            b.mines[1][1] = 0
            b.mines[0][0] = 0
            b.mines[0][1] = 1
            b.mines[0][2] = 1
            b.mines[1][0] = 1
            b.mines[1][2] = 1 
            b.mines[2][0] = 1
            b.mines[2][1] = 1
            b.mines[2][2] = 1
            -- total adjacent mines should be 7
            b.adjacentMines[1][1] = 7
            -- predicate should be true
            adjacentMinesPopulate[b, 1, 1]
        }
    } is sat }
}

test suite for revealAdjacentCells {
    -- make sure that all adjacent cells are revealed
    test expect { testRevealAllAdjacentCells: {
        some pre, post: Board |{ 
            -- set up the board
            pre.mines[0][0] = 0
            pre.cells[0][0] = Hidden
            pre.mines[0][1] = 0
            pre.cells[0][1] = Hidden
            pre.mines[1][0] = 0
            pre.cells[1][0] = Hidden
            -- reveal the cell
            revealAdjacentCells[pre, post, 1, 1]
            -- check that all adjacent cells are revealed
            post.cells[0][0] = Revealed
            post.cells[0][1] = Revealed
            post.cells[1][0] = Revealed
        }
    } is sat }

    -- make sure that cells that are not adjacent to the cell being revealed are not changed
    test expect { testUnchangedNonAdjacentCells: {
        some pre, post: Board | { 
            -- set up the board
            pre.cells[2][2] = Hidden
            -- reveal the cell
            revealAdjacentCells[pre, post, 0, 0]
            -- check that non adjacent cells are not changed
            post.cells[2][2] = Hidden
        }
    } is sat }

}

test suite for openTile {
    -- the tile at (1, 1) has no adjacent mines and should reveal all adjacent cells
    test expect { testOpenTileNoAdjacentMines: {
        some pre, post: Board | {
            -- set up the board
            pre.cells[1][1] = Hidden
            pre.adjacentMines[1][1] = 0
            openTile[pre, post, 1, 1]
            post.cells[1][1] = Revealed
            --  all adjacent cells should be revealed
            all x: Int, y: Int | {
                ((x = 0 or x = 1 or x = 2) and (y = 0 or y = 1 or y = 2)) implies { post.cells[x][y] = Revealed }
            }
        }
    } is sat }

    -- the tile at (1, 1) has adjacent mines and should only reveal itself
    test expect { testOpenTileWithAdjacentMines: {
        some pre, post: Board | {
            pre.cells[1][1] = Hidden
            pre.adjacentMines[1][1] != 0
            openTile[pre, post, 1, 1]
            post.cells[1][1] = Revealed
            -- Ensure only the specified tile is revealed
            (all r: Int, c: Int | not (r = 1 and c = 1) => post.cells[r][c] = pre.cells[r][c])
        }
    } is sat }

    -- the tile at (1, 1) is incorrectly set to Ignored
    test expect { testIncorrectTileStateChange: {
        some pre, post: Board | {
            -- set up the board
            pre.cells[1][1] = Hidden
            pre.adjacentMines[1][1] = 0
            openTile[pre, post, 1, 1]
            -- incorrect state for demonstration
            post.cells[1][1] = Ignored
        }
    } is unsat }

}

test suite for won {
    -- winning condition met
    test expect { testWinningCondition: {
        some b: Board | {
            -- all non-mine cells are revealed
            all row, col: Int | {
                -- in bounds conditions for a win
                (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) implies {
                    b.mines[row][col] = 1 implies { b.cells[row][col] = Hidden }
                    b.mines[row][col] = 0 implies { b.cells[row][col] = Revealed }
                }
            }
            -- winning condition met
            won[b]
        }
    } is sat }

    -- winning condition is not met if a mine is revealed
    test expect { testRevealedMine: {
        some b: Board | {
            -- a mine is revealed
            b.mines[1][1] = 1
            b.cells[1][1] = Revealed

            all row, col: Int | {
                -- in bounds conditions for a win
                (row >= MIN and row <= MAXCOL and col >= MIN and col <= MAXROW) 
                -- everything else is fine
                not (row = 1 and col = 1) implies {
                    b.mines[row][col] = 1 implies { b.cells[row][col] = Hidden }
                    b.mines[row][col] = 0 implies { b.cells[row][col] = Revealed }
                }
            }
            -- winning condition met
            won[b]
        }
    } is unsat }

    -- winning condition is not met if a non-mine cell is not revealed
    test expect { testUnrevealedNonMineCell: {
        some b: Board | {
            -- a non-mine cell is not revealed
            b.mines[1][1] = 0
            b.cells[1][1] = Hidden

            all row, col: Int | {
                -- in bounds conditions for a win
                (row >= MIN && row <= MAXCOL && col >= MIN && col <= MAXROW) 
                -- everything else is fine
                not (row = 1 and col = 1) implies {
                    b.mines[row][col] = 1 implies { b.cells[row][col] = Hidden }
                    b.mines[row][col] = 0 implies { b.cells[row][col] = Revealed }
                }
            }
            -- winning condition met
            won[b]
        }
    } is unsat }
}

test suite for doNothing {
    -- two identical boards pre and post
    test expect { testIdenticalBoards: {
        some pre, post: Board | { 
            all row, col: Int | { 
                -- cells are the same
                post.cells[row][col] = pre.cells[row][col]
                -- mines are the same
                post.mines[row][col] = pre.mines[row][col]
                -- adjacent mines are the same
                post.adjacentMines[row][col] = pre.adjacentMines[row][col]
            }
            -- do nothing
            doNothing[pre, post]
        }
    } is sat }

    -- cell at (1, 1) changed from Hidden to Revealed
    test expect { testCellStateChanged: {
        some pre, post: Board | { 
            -- cell at (1, 1) changed from Hidden to Revealed
            pre.cells[1][1] = Hidden
            post.cells[1][1] = Revealed
            -- everything else is the same
            all row, col: Int | not (row = 1 and col = 1) implies {
                post.cells[row][col] = pre.cells[row][col]
                post.mines[row][col] = pre.mines[row][col]
                post.adjacentMines[row][col] = pre.adjacentMines[row][col]
            }
            -- do nothing
            doNothing[pre, post]
        }
    } is unsat }

    -- mine at (1, 1) changed from 0 to 1
    test expect { testMineStateChanged: {
        some pre, post: Board | { 
            -- mine at (1, 1) changed from 0 to 1
            pre.mines[1][1] = 0
            post.mines[1][1] = 1
            -- everything else is the same
            all row, col: Int | not (row = 1 and col = 1) implies {
                post.cells[row][col] = pre.cells[row][col]
                post.mines[row][col] = pre.mines[row][col]
                post.adjacentMines[row][col] = pre.adjacentMines[row][col]
            }
            -- do nothing
            doNothing[pre, post]
        }
    } is unsat }

    -- cell at (1, 1) has 3 adjacent mines and is changed to 4
    test expect { testAdjacentMinesCountChanged: {
        some pre, post: Board | { 
            -- cell at (1, 1) has 3 adjacent mines
            pre.adjacentMines[1][1] = 3
            post.adjacentMines[1][1] = 4
            -- everything else is the same
            all row, col: Int | not (row = 1 and col = 1) implies {
                post.cells[row][col] = pre.cells[row][col]
                post.mines[row][col] = pre.mines[row][col]
                post.adjacentMines[row][col] = pre.adjacentMines[row][col]
            }
            -- do nothing
            doNothing[pre, post]
        }
    } is unsat }
}

test suite for game_trace_dummy {
    -- valid game trace is sat
    test expect { validGameTrace: {
        game_trace_dummy
    } is sat }
}
