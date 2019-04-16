import QtQuick 2.9
import QtQuick.Window 2.2
import FlatUI 2.0

Window {
    visible: true
    width: 20 + chessboardImage.width + rightItem.width
    height: 120 + chessboardImage.height + takeBackBtn.height
    title: qsTr("zgoband")
    Item {
        id:leftItem
        height: parent.height
        width: chessboardImage.width+10
        ListModel {
            id: timeModel
            ListElement {text:"time1"}
            ListElement {text:"time2"}
        }
        Row {
            id: timeShowRow
            spacing: 100
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                id: timeShowRepeater
                model: timeModel
                anchors.top: parent.top

                Rectangle{
                    width: 125
                    height: 95
                    color: "red"
                    Text {
                        text: index
                    }
                }
            }
        }
        Item {
            id: chessboard
            anchors.top: timeShowRow.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            width: chessboardImage.width
            height: chessboardImage.height
            Image {
                id: chessboardImage
                anchors.centerIn: parent
                source: "qrc:/resouces/qpps.png"
            }
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
