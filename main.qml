import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 1000
    height: 105 + chessboardImage.height
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
        Component.onCompleted: {
            console.log(timeModel.rowCount())
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
                anchors.horizontalCenter: parent.horizontalCenter

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
    }
    Item {
        id: rightItem
        anchors.top: parent.top
        anchors.left: leftItem.right
        anchors.topMargin: 105
        anchors.leftMargin: 5
        height: parent.height
        width: 300
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
