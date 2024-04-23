require("d3");
d3.selectAll("svg > *").remove();

const numRows = 4; // MAXROW + 1
const numCols = 4; // MAXCOL + 1
const cellSize = 20;
const boardsPerColumn = 5;

function printValue(row, col, xoffset, yoffset, value, fillColor) {
  let invertedRow = numRows - row - 1;

  d3.select(svg)
    .append("text")
    .style("fill", fillColor)
    .attr("x", xoffset + col * cellSize + cellSize / 2)
    .attr("y", yoffset + invertedRow * cellSize + cellSize / 2)
    .attr("text-anchor", "middle")
    .attr("dominant-baseline", "central")
    .text(value);
}

function drawLines(xoffset, yoffset) {
  for (let i = 0; i <= numRows; i++) {
    let invertedRow = numRows - i;

    d3.select(svg)
      .append("line")
      .attr("x1", xoffset)
      .attr("y1", yoffset + invertedRow * cellSize)
      .attr("x2", xoffset + numCols * cellSize)
      .attr("y2", yoffset + invertedRow * cellSize)
      .attr("stroke", "black")
      .attr("stroke-width", 1);
  }
  for (let i = 0; i <= numCols; i++) {
    d3.select(svg)
      .append("line")
      .attr("x1", xoffset + i * cellSize)
      .attr("y1", yoffset)
      .attr("x2", xoffset + i * cellSize)
      .attr("y2", yoffset + numRows * cellSize)
      .attr("stroke", "black")
      .attr("stroke-width", 1);
  }
}

function printBoard(board, xoffset, yoffset, showMines) {
  for (let row = 0; row < numRows; row++) {
    for (let col = 0; col < numCols; col++) {
      let cell = board.cells[row][col];
      console.log(cell);
      let value = "";
      let fillColor = "black";
      if (showMines) {
        if (cell.hasMine == "[0]") {
          value = "G";
          fillColor = "green";
        } else if (cell.hasMine == "[1]") {
          value = "M";
          fillColor = "red";
        }
      } else {
        if (cell.curState == "[Hidden0]") {
          value = "H";
          fillColor = "blue";
        } else if (cell.curState == "[Ignored0]") {
          value = "I";
          fillColor = "gray";
        }
      }
      printValue(row, col, xoffset, yoffset, value, fillColor);
    }
  }

  drawLines(xoffset, yoffset);
  d3.select(svg)
    .append("rect")
    .attr("x", xoffset)
    .attr("y", yoffset)
    .attr("width", numCols * cellSize)
    .attr("height", numRows * cellSize)
    .attr("stroke-width", 2)
    .attr("stroke", "black")
    .attr("fill", "transparent");
}

var yOffset = 5;
var xOffset = 5;

for (let b = 1; b <= 20; b++) {
  if (Board.atom("Board" + b) != null) {
    // Print gameplay board
    printBoard(Board.atom("Board" + b), xOffset, yOffset, false);
    yOffset += numRows * cellSize + 10;
    // Print mine visualization board
    printBoard(Board.atom("Board" + b), xOffset, yOffset, true);
    yOffset += numRows * cellSize + 10;

    if (b % boardsPerColumn === 0) {
      xOffset += numCols * cellSize + 10;
      yOffset = 1;
    }
  }
}
