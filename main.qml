import QtQuick 2.7
import QtQuick.Window 2.2
import FlatUI 2.0
import "./gameComponent"

Window {
    visible: true
    width: 20 + chessboard.width + rightItem.width
    height: 120 + chessboard.height + takeBackBtn.height
    title: qsTr("zgoband")
    Component.onCompleted: {
        console.log("chessboard:"+chessboard.width)
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
                id: user1Timer
                username: "user1"
                gameTimeMin: 10
                gameTimeSec: 0
            }
            TimerRect {
                id: user2Timer
                username: "user2"
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
        }
        Row {
            id: buttonRow
            anchors.top: chessboard.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 50
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
}
