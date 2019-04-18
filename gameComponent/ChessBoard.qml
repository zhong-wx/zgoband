import QtQuick 2.0

Item {
    width: chessboardImage.width
    height: chessboardImage.height

    property bool inYourTurn
    // 第几个位置是否可以下棋，第二行第一个记为为第16个位置
    property var noClick: []
    // 上一步棋下的位置
    property int lastClickCell: null
    // 上一此鼠标放置的位置
    property var lastMouseCell: null
    readonly property int cellSize: 36

    Component.onCompleted: {
        for(var i=0; i<226; i++) {
            noClick[i] = true
        }
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

        onPaint: {
            ctx = getContext("2d")
            if(isBlack) {
                ctx.drawImage("", lastClickCell.x, lastClickCell.y, cellSize, cellSize)
                ctx.drawImage("", region.x, region.y, cellSize, cellSize)
            }
            else {
                ctx.drawImage("", lastClickCell.x, lastClickCell.y, cellSize, cellSize)
                ctx.drawImage("", region.x, region.y, cellSize, cellSize)
            }

            ctx.strokeStyle = "red"
            ctx.lineWidth = 2
            ctx.beginPath()
            ctx.moveTo(region.x + cellSize/2, region.y + 3*cellSize/8)
            ctx.lineTo(region.x + cellSize/2, region.y + 5*cellSize/8)
            ctx.moveTo(region.x + 3*cellSize/8, region.y + cellSize/2)
            ctx.lineTo(region.x + 5*cellSize/8, region.y + cellSize/2)
            ctx.stroke()
            ctx.clearRect(region.x + cellSize/2, region.y + cellSize/2, 2, 2)

            isBlack = !isBlack
        }
    }
    Canvas {
        id: traceCanvas
        anchors.fill: parent

        onPaint: {
            ctx = getContext("2d")
            if(lastMouseCell != null) {
                ctx.clearRect(lastMouseCell)
            }

            x = region.x + cellSize/4
            y = region.y + cellSize/4

            ctx.strokeStyle = "red"
            ctx.lineWidth = 1
            ctx.strokeRect(x, y, cellSize/2, cellSize/2)
            ctx.clearRect(x, y+cellSize/8, cellSize/2, cellSize/4)
            ctx.clearRect(x+cellSize/8, y, cellSize/2, cellSize/4)

            lastMouseCell = region
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            if (canClick(point(mouseX, mouseY)))
                return Qt.ArrowCursor
            return Qt.ForbiddenCursor
        }
        acceptedButtons: {
            if (canClick(point(mouseX, mouseY)))
                return Qt.LeftButton
            return Qt.NoButton
        }

        onClicked: {
            number = getCellNumber(point(mouse.x, mouse.y))
            var x = number%15 * cellSize
            var y = number/15 * cellSize
            pieceCanvas.markDirty(Qt.rect(x, y, cellSize, cellSize))
            noClick[number] = true
        }
        onPositionChanged: {
            number = getCellNumber(point(mouse.x, mouse.y))
            if (lastMousePosition == number)
                return
            if (noClick[number])
                return

            var x = number%15 * cellSize
            var y = number/15 * cellSize

            traceCanvas.fromMoveEvent = true
            traceCanvas.markDirty(Qt.rect(x, y, cellSize, cellSize))
        }

        function canClick(p) {
            if(!inYourTurn) {
                return false
            }

            number = getCellNumber(p)
            if (noClick[number]) {
                return false
            }
            return true
        }

        function getCellNumber(p) {
            var line = p.x / cellSize
            var column = p.y / cellSize
            return line * 15 + column + 1
        }
    }
}
