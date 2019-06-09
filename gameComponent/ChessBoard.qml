import QtQuick 2.0

Item {
    id: chessBoardRoot
    width: chessboardImage.width
    height: chessboardImage.height

    readonly property int player1: 1
    readonly property int player2: -1

    property bool inYourTurn: true
    // 棋盘
    property var chessBoard
    // 1 mean humanwithcomputor, 2 mean humanwithhuman

    property point computerStrategy
    // 上一步棋下的位置
    property var lastClickCellPoint: null
    // 上一此鼠标放置的位置
    property var lastMouseCellPoint: null
    // 第几个位置是否可以下棋，第二行第一个记为为第16个位置
    property var noClick: []
    readonly property int cellSize: 36



    signal clicked(int line, int column)

    function resetChessBoardDataStruct() {
        chessBoard = new Array
        for(var i=1; i<=15; i++) {
            chessBoard[i] = new Array
            for(var j=1; j<=15; j++) {
                chessBoard[i][j] = 0
            }
        }
    }

    Component.onCompleted: {
        for(var i=0; i<226; i++) {
            noClick[i] = false
        }

        resetChessBoardDataStruct()
    }

    Timer {
        id: t
        interval: 10
        repeat: false
        onTriggered: {
            pieceCanvas.markDirty(Qt.rect(computerStrategy.x, computerStrategy.y, cellSize, cellSize))
        }
    }

    function reset() {
        inYourTurn = false
        pieceCanvas.isFirstPaint = true
        traceCanvas.isFirstPaint = true
        pieceCanvas.markDirty(Qt.rect(0, 0, pieceCanvas.width, pieceCanvas.height))
        traceCanvas.markDirty(Qt.rect(0, 0, traceCanvas.width, traceCanvas.height))
        noClick = []
        lastClickCellPoint = null
        lastMouseCellPoint = null
        pieceCanvas.isBlack = true
        resetChessBoardDataStruct()
    }

    function checkWiner(line, column) {
        var which = chessBoard[line][column]

        var repeatCount = 1
        var columnIndex = column + 1
        while(columnIndex<=15 && chessBoard[line][columnIndex]===which) {
            repeatCount++
            columnIndex++
        }
        columnIndex = column - 1
        while(columnIndex>=1 && chessBoard[line][columnIndex]===which) {
            repeatCount++
            columnIndex--
        }
        if(repeatCount >= 5) {
            return true
        }

        repeatCount = 1
        var lineIndex = line + 1
        while(lineIndex<=15 && chessBoard[lineIndex][column]===which) {
            repeatCount++
            lineIndex++
        }
        lineIndex = line - 1
        while(lineIndex>=1 && chessBoard[lineIndex][column]===which) {
            repeatCount++
            lineIndex--
        }
        if(repeatCount >= 5) {
            return true
        }

        repeatCount = 1
        lineIndex = line + 1
        columnIndex = column + 1
        while(lineIndex<=15 && columnIndex<=15 && chessBoard[lineIndex][columnIndex]) {
            repeatCount++
            lineIndex++
            columnIndex++
        }
        lineIndex = line - 1
        columnIndex = column - 1
        while(lineIndex>=1 && columnIndex>=1 && chessBoard[lineIndex][columnIndex]===which) {
            repeatCount++
            lineIndex--
            columnIndex--
        }
        if(repeatCount >= 5) {
            return true
        }

        lineIndex = line - 1
        columnIndex = column + 1
        repeatCount = 1
        while(lineIndex>=1 && columnIndex<=15 && chessBoard[lineIndex][columnIndex]===which) {
            repeatCount++
            lineIndex--
            columnIndex++
        }
        lineIndex = line + 1
        columnIndex = column - 1
        while(lineIndex<=15 && columnIndex>=1 && chessBoard[lineIndex][columnIndex]===which) {
            repeatCount++
            lineIndex++
            columnIndex--
        }
        if(repeatCount >= 5) {
            return true
        }

        return false
    }

    function player2PutAPiece(row, column, result) {
        var y = (row-1) * cellSize
        var x = (column-1) * cellSize
        computerStrategy = Qt.point(x, y)
        t.start()

        chessBoard[row][column] = player2

        var number = (row-1)*15 + column
        noClick[number] = true

        if(root.gameType===1 && checkWiner(row, column)) {
            var text = "本局游戏电脑获得胜利"
            root.showMessageDialog(text)
            resetChessBoardDataStruct()
            root.showGetReadyBtn()
            return
        } else if(root.gameType===2 && result > 0) {
            root.gameEnd(root.seatID===1?2:1, result)
        }
    }

    function player1PutAPiece(p) {
        var number = getCellNumber(p)
        var point = getCellPoint(p)

        pieceCanvas.markDirty(Qt.rect(point.x, point.y, cellSize, cellSize))
        noClick[number] = true

        var row = parseInt(number/15) + 1
        var column = number%15

        chessBoard[row][column] = player1
        if(root.gameType===1 && checkWiner(row, column)) {
            var text = "本局游戏你获得胜利"
            root.showMessageDialog(text)
            root.showGetReadyBtn()
            reset()
            return
        } else if(root.gameType != 3) {
            chessBoardRoot.clicked(row, column)
        }
    }

    function takeBack(row, column) {
        var y = (row-1) * cellSize
        var x = (column-1) * cellSize
        pieceCanvas.toClear.push(Qt.point(x, y))
        pieceCanvas.requestPaint()
        var number = (row-1)*15 + column
        noClick[number] = false
        pieceCanvas.isBlack = !pieceCanvas.isBlack
    }

    function setLastPos(row, column) {
        if (row<0 || column<0) {
            lastClickCellPoint = null
            return
        }
        var y = (row-1) * cellSize
        var x = (column-1) * cellSize
        pieceCanvas.lastPos = Qt.point(x, y)
        pieceCanvas.requestPaint()
    }

    function canClick(p) {
        if(!inYourTurn) {
            return false
        }

        var number = getCellNumber(p)
        if (noClick[number]) {
            return false
        }
        return true
    }

    function getCellNumber(p) {
        var row = parseInt(p.y / cellSize)
        var column = parseInt(p.x / cellSize)
        return row * 15 + column + 1
    }

    function getCellPoint(p) {
        var row = parseInt(p.x / cellSize)
        var column = parseInt(p.y / cellSize)
        return Qt.point(row*cellSize, column*cellSize)
    }

    Image {
        id: chessboardImage
        width: 540
        height: 540
        anchors.centerIn: parent
        source: "qrc:/resouces/qpps.png"
    }
    Canvas {
        id: pieceCanvas
        anchors.fill: parent

        property bool isBlack: true
        property bool isFirstPaint: true
        property var toClear: []
        property var lastPos: null

        function drawLastClickPos(ctx, region) {
            ctx.strokeStyle = "red"
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.moveTo(region.x + parseInt(cellSize/2), region.y + parseInt(3*cellSize/8))
            ctx.lineTo(region.x + parseInt(cellSize/2), region.y + parseInt(5*cellSize/8))
            ctx.moveTo(region.x + parseInt(3*cellSize/8), region.y + parseInt(cellSize/2))
            ctx.lineTo(region.x + parseInt(5*cellSize/8), region.y + parseInt(cellSize/2))
            ctx.stroke()

            lastClickCellPoint = Qt.point(region.x, region.y)
        }

        onPaint: {
            console.log("pieceCanvas draw")
            var ctx = getContext("2d")
            if(isFirstPaint) {
                ctx.clearRect(region.x, region.y, region.width, region.height)
                isFirstPaint = !isFirstPaint
                return
            }
            if(toClear.length > 0 || lastPos !== null) {
                for(var i=0; i<toClear.length; i++)
                    ctx.clearRect(toClear[i].x, toClear[i].y, cellSize, cellSize)
                if(lastPos !== null) {
                    drawLastClickPos(ctx, lastPos)
                }
                lastPos = null
                toClear = []
                return
            }

            if(isBlack) {
                if(lastClickCellPoint != null) {
                    ctx.clearRect(lastClickCellPoint.x, lastClickCellPoint.y, cellSize, cellSize)
                    ctx.drawImage("qrc:/resouces/bq.png", lastClickCellPoint.x, lastClickCellPoint.y, cellSize, cellSize)
                }
                ctx.drawImage("qrc:/resouces/hq.png", region.x, region.y, cellSize, cellSize)
            }
            else {
                if(lastClickCellPoint != null) {
                    ctx.clearRect(lastClickCellPoint.x, lastClickCellPoint.y, cellSize, cellSize)
                    ctx.drawImage("qrc:/resouces/hq.png", lastClickCellPoint.x, lastClickCellPoint.y, cellSize, cellSize)
                }
                ctx.drawImage("qrc:/resouces/bq.png", region.x, region.y, cellSize, cellSize)
            }

            drawLastClickPos(ctx, region)
            isBlack = !isBlack
        }

        Component.onCompleted: {
            loadImage("qrc:/resouces/hq.png")
            loadImage("qrc:/resouces/bq.png")
        }
    }
    //画鼠标移动轨迹
    Canvas {
        id: traceCanvas
        anchors.fill: parent
        property bool isFirstPaint: true

        onPaint: {
            console.log("traceCanvas draw")
            var ctx = getContext("2d")
            if (isFirstPaint) {
                ctx.clearRect(region.x, region.y, region.width, region.height)
                isFirstPaint = !isFirstPaint
                return
            }


            if(lastMouseCellPoint != null) {
                ctx.clearRect(lastMouseCellPoint.x-1, lastMouseCellPoint.y-1, cellSize+2, cellSize+2)
            }

            if(!inYourTurn)
                return

            var x = region.x
            var y = region.y

            ctx.strokeStyle = "red"
            ctx.lineWidth = 1
            ctx.beginPath()
            ctx.strokeRect(x, y, cellSize, cellSize)
            ctx.stroke()
            ctx.clearRect(x-1, y+parseInt(cellSize/4), cellSize+2, parseInt(cellSize/2))
            ctx.clearRect(x+parseInt(cellSize/4), y-1, parseInt(cellSize/2), cellSize+2)

            lastMouseCellPoint = Qt.point(region.x, region.y)
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            if (canClick(Qt.point(mouseX, mouseY)))
                return Qt.ArrowCursor
            return Qt.ForbiddenCursor
        }
        acceptedButtons: {
            if (canClick(Qt.point(mouseX, mouseY)))
                return Qt.LeftButton
            return Qt.NoButton
        }

        onClicked: {
            if (!canClick(Qt.point(mouse.x, mouse.y)))
                return false

            player1PutAPiece(Qt.point(mouse.x, mouse.y))
        }
        onPositionChanged: {
            var point = getCellPoint(Qt.point(mouse.x, mouse.y))
            if (lastMouseCellPoint === point)
                return
            if (!canClick(Qt.point(mouse.x, mouse.y)))
                return

            traceCanvas.markDirty(Qt.rect(point.x, point.y, cellSize, cellSize))
        }
    }
}
