import QtQuick 2.0

Item {
    id: root
    width: chessboardImage.width
    height: chessboardImage.height

    readonly property int player1: 1
    readonly property int player2: -1

    property bool inYourTurn: true
    // 第几个位置是否可以下棋，第二行第一个记为为第16个位置
    property var noClick: []
    // 上一步棋下的位置
    property var lastClickCellPoint: null
    // 上一此鼠标放置的位置
    property var lastMouseCellPoint: null
    readonly property int cellSize: 36

    property point computerStrategy

    property var chessBoard

    signal clicked(int line, int column)

    Component.onCompleted: {
        for(var i=0; i<226; i++) {
            noClick[i] = false
        }

        chessBoard = new Array
        for(var i=1; i<=15; i++) {
            chessBoard[i] = new Array
            for(var j=1; j<=15; j++) {
                chessBoard[i][j] = 0
            }
        }
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
        pieceCanvas.requestPaint()
        traceCanvas.requestPaint()
        noClick = []
        lastClickCellPoint = null
        lastMouseCellPoint = null
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
        columnIndex = columnIndex - 1
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

    function player2PutAPiece(line, column) {
        var y = (line-1) * cellSize
        var x = (column-1) * cellSize
        computerStrategy = Qt.point(x, y)
        t.start()

        chessBoard[line][column] = player2

        var number = (line-1)*15 + column
        noClick[number] = true

        if(checkWiner(line, column)) {
            var title = "本局游戏结束"
            var message = "本局"
            root.parent.showOkMessageDialog()
        }
    }

    function player1PutAPiece(p) {
        var number = getCellNumber(p)
        var point = getCellPoint(p)

        pieceCanvas.markDirty(Qt.rect(point.x, point.y, cellSize, cellSize))
        noClick[number] = true

        var line = parseInt(number/15) + 1
        var column = number%15

        chessBoard[line][column] = player1
        console.log("put a piece on " + line + "," +column)
        checkWiner(line, column)
        root.clicked(line, column)
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
        var line = parseInt(p.y / cellSize)
        var column = parseInt(p.x / cellSize)
        return line * 15 + column + 1
    }

    function getCellPoint(p) {
        var line = parseInt(p.x / cellSize)
        var column = parseInt(p.y / cellSize)
        return Qt.point(line*cellSize, column*cellSize)
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

        property bool isBlack
        property bool isFirstPaint: true

        onPaint: {
            if(isFirstPaint) {
                isFirstPaint = !isFirstPaint
                return
            }

            var ctx = getContext("2d")

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

            ctx.strokeStyle = "red"
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.moveTo(region.x + parseInt(cellSize/2), region.y + parseInt(3*cellSize/8))
            ctx.lineTo(region.x + parseInt(cellSize/2), region.y + parseInt(5*cellSize/8))
            ctx.moveTo(region.x + parseInt(3*cellSize/8), region.y + parseInt(cellSize/2))
            ctx.lineTo(region.x + parseInt(5*cellSize/8), region.y + parseInt(cellSize/2))
            ctx.stroke()

            lastClickCellPoint = Qt.point(region.x, region.y)
            isBlack = !isBlack
        }

        Component.onCompleted: {
            loadImage("qrc:/resouces/hq.png")
            loadImage("qrc:/resouces/bq.png")
        }
    }
    Canvas {
        id: traceCanvas
        anchors.fill: parent
        property bool isFirstPaint: true

        onPaint: {
            if (isFirstPaint) {
                isFirstPaint = !isFirstPaint
                return
            }

            var ctx = getContext("2d")
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
            var number = getCellNumber(Qt.point(mouse.x, mouse.y))

            var point = getCellPoint(Qt.point(mouse.x, mouse.y))
            if (lastMouseCellPoint === point)
                return
            if (noClick[number])
                return

            traceCanvas.markDirty(Qt.rect(point.x, point.y, cellSize, cellSize))
        }
    }
}
