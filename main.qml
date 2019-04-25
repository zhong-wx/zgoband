import QtQuick 2.7
import QtQuick.Window 2.2
import FlatUI 2.0
import QtQuick.Dialogs 1.1
import "./gameComponent"
import "qrc:/js/humanWithComputerAlgorithm.js" as Code

Window {
    visible: true
    width: 20 + chessboard.width + rightItem.width
    height: 120 + chessboard.height + takeBackBtn.height
    title: qsTr("zgoband")

    property string gameType: "humanWithComputer"
    property string player1: "player1"
    property string player2: "player2"

    MessageDialog {
        id: okMessageDialog
        title: ""
        text: ""
        standardButtons: StandardButton.Ok
    }

    Item {
        id:leftItem
        height: parent.height
        width: chessboard.width+10
        Row {
            id: timeShowRow
            spacing: 100
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            TimerRect {
                id: player1Timer
                username: "player1"
                gameTimeMin: 10
                gameTimeSec: 0
            }
            TimerRect {
                id: player2Timer
                username: "player2"
                gameTimeMin: 10
                gameTimeSec: 0
            }
        }
        ChessBoard {
            id: chessboard
            anchors.top: timeShowRow.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            inYourTurn: false

            onClicked: {
                inYourTurn = false
                player1Timer.timerStop()
                if (gameType === "humanWithComputer") {
                    var strategy = Code.getComputerStrategy(chessboard.chessBoard, line, column)
                    chessboard.player2PutAPiece(strategy.line, strategy.column)
                    inYourTurn = true
                    player1Timer.timerStart()
                }
            }
        }
        Row {
            id: buttonRow
            anchors.top: chessboard.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 50
            FlatButton {
                id: getReadyBtn
                text: "准备"
                checkable: false
                onClicked: {
                    getReadyBtn.checkable = false
                    getReady()
                }
            }
            FlatButton {
                id: takeBackBtn
                text: "悔棋"
            }
            FlatButton {
                id: wantDrawBtn
                text: "和棋"
            }
            FlatButton {
                id: giveUpBtn
                text: "认输"
            }
            FlatButton {
                id: quitBtn
                text: "退出"
            }
        }
    }
    Item {
        id: rightItem
        anchors.top: parent.top
        anchors.left: leftItem.right
        anchors.topMargin: 105
        anchors.leftMargin: 5
        height: parent.height
        width: 250
        Rectangle {
            id: playerInfoRec
            width: 250
            height: 180
            anchors.top: parent.top
            anchors.left: parent.left
            color: "blue"
            Text {
                text: "玩家详细信息"
                anchors.centerIn: parent.Center
            }
        }
        Rectangle {
            id: playersRec
            width: 250
            height: 180
            anchors.top: playerInfoRec.bottom
            anchors.left: playerInfoRec.left
            anchors.topMargin: 5
            color: "blue"
            Text {
                text: "桌上玩家"
                anchors.centerIn: parent.Center
            }
        }
        Rectangle {
            width: 250
            anchors.top: playersRec.bottom
            anchors.left: playersRec.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            color: "blue"
            Text {
                text: "对话框"
                anchors.centerIn: parent.Center
            }
        }
    }

    function getReady() {
        player1Timer.timerStart()
        chessboard.inYourTurn = true
    }

    function gameEnd(winner) {
        okMessageDialog.title = "本局游戏结束"
        if(winner === 0) {
            okMessageDialog.text = "本局游戏" + player1 + "胜出"
        }
        else if(winner === 1){
            okMessageDialog.text = "本局游戏" + player2 + "胜出"
        }
        else {
            okMessageDialog.text = "unkownPlayer" + " 胜出"
        }
        okMessageDialog.open()
        chessboard.reset()
    }
}
