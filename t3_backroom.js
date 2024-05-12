require("d3");
d3.selectAll("svg > *").remove();

const numRows = 5; // MAXROW + 1
const numCols = 5; // MAXCOL + 1
const cellSize = 20;
const boardsPerColumn = 5;

function printValue(row, col, xoffset, yoffset, value) {
  let invertedRow = numRows - row - 1;

  let fillColor;
  //mine
  if (value === "M") {
    fillColor = "red";
  //hidden
  } else if (value === "H") {
    fillColor = "blue";
  //ignored
  } else if (value === "I") {
    fillColor = "gray";
  //else revealed
  } else {
    switch (parseInt(value)) {
      case 1:
        fillColor = "orange";
        break;
      case 2:
        fillColor = "green";
        break;
      case 3:
        fillColor = "purple";
        break;
      case 4:
        fillColor = "red";
        break;
      default:
        fillColor = "black";
        break;
    }
  }

  d3.select(svg)
    .append("text")
    .style("fill", fillColor)
    .style("font-weight", "bold")
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

function printMinesBoard(xoffset, yoffset) {
  for (let row = 0; row < numRows; row++) {
    for (let col = 0; col < numCols; col++) {
      let hasMine = Board.atom("Board0").mines[row][col];
      //printValue(-10, 4, xoffset, yoffset, SolutionBoard.atom("SolutionBoard0").mines[row][col]);
      let displayChar =
        hasMine == "[1]"
          ? "M"
          : Board.atom("Board0").adjacentMines[row][col].toString();
      printValue(row, col, xoffset, yoffset, displayChar);
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

var minesXOffset = 5;
var minesYOffset = 5;

if (Board !== undefined) {
  printMinesBoard(minesXOffset, minesYOffset);
}

function printBoard(board, xoffset, yoffset) {
  for (let row = 0; row < numRows; row++) {
    for (let col = 0; col < numCols; col++) {
      let adjacentMines = board.adjacentMines[row][col];

      let state = board.cells[row][col];
      console.log(state);
      let value = "";
      if (state == "[Hidden0]") {
        value = "H";
      } else if (state == "[Ignored0]") {
        value = "I";
      } else if (state == "[Revealed0]") {
        if (adjacentMines != "[0]") {
          value = adjacentMines.toString();
        } else {
          value = "R";
        }
      } else {
        //place holder for now- add flagged and revealed states
        value = "";
      }
      printValue(row, col, xoffset, yoffset, value);
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

var yOffset = numRows * cellSize + 10;
var xOffset = 5;
var boardCount = 0;

for (let b = 0; b <= 20; b++) {
  if (Board.atom("Board" + b) != null) {
    printBoard(Board.atom("Board" + b), xOffset, yOffset);
    yOffset += numRows * cellSize + 5;
    boardCount++;

    if (boardCount % boardsPerColumn === 0) {
      xOffset += numCols * cellSize + 10;
      yOffset = 5;
    }
  }
}
