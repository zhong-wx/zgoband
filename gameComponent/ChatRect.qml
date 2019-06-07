import QtQuick 2.11
import FlatUI 2.0
import FlatUI.Private 2.0
import QtQuick.Window 2.2

Rectangle {
    property var me
    property var opponent
    property var globalX
    property var globalY
    property var textToSend
    id: chatItem

    function closeFaceChooseWindow() {
        faceChooseWindow.visible = false
    }
    function addChatData(name, txt) {
        if(txt !== "") {
            chatData.append({"name":name, "txt":txt})
            listView.positionViewAtEnd()
        }
    }
    Component.onCompleted: {
        addChatData("abc", "test1")
        addChatData("hcx", "test2")
    }

    ListModel {
        id: chatData
    }
    Rectangle {
        border.width: 1
        anchors.top: parent.top
        anchors.bottom: chatRow.top
        anchors.left: parent.left
        width: chatRow.width
        ListView {
            id: listView
            anchors.fill: parent
            delegate: TextEdit{
                width: parent.width
                text: name + ":" + txt
                wrapMode: Text.WrapAnywhere
                readOnly: true
                selectByKeyboard: true
                selectByMouse: true
                textFormat: TextEdit.AutoText
            }
            clip: true

            model: chatData
        }
    }

    Window {
        id: faceChooseWindow
        x: rootWindow.x + 555
        y: rootWindow.y + 686
        width: faceChooseRect.width
        height: faceChooseRect.height
        flags: Qt.FramelessWindowHint
        onActiveFocusItemChanged: {
            if(activeFocusItem === null) {
                faceChooseWindow.visible = false
            }
        }
        FaceChoose {
            id: faceChooseRect
            onChoosed:{
                faceChooseWindow.visible = false
                var imgText = "<img src=\"" + image + "\" alt=\"biaoqin\" height=\"26\" width=\"26\">"
                textEdit.text += imgText
            }
        }
    }

    Row {
        id: chatRow
        anchors.bottom: chatItem.bottom
        anchors.left: chatItem.left
        anchors.right: chatItem.right
        spacing: (parent.width - 240)/2
        FlatIcon {
            id: bqIconBtn
            anchors.verticalCenter: parent.verticalCenter
            height: 20
            width: 20
            icon: FlatIconName {
                defaultIcon: "qrc:/resouces/bqbtn.png"
                hoverIcon: "qrc:/resouces/bqbtnEnter.png"
                pressIcon: "qrc:/resouces/bqbtnEnter.png"
            }

            onClicked: {
                faceChooseWindow.visible = !faceChooseWindow.visible
            }
        }
        Rectangle {
            width: 180
            height: 30
            border.width: 1
            TextEdit {
                id: textEdit
                width: 180
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 5
                selectByKeyboard: true
                selectByMouse: true
                Keys.onEnterPressed: chatRow.addTextEditText()
                wrapMode: TextEdit.WrapAnywhere
                clip: true
                textFormat: TextEdit.AutoText
            }
        }
        FlatButton {
            width: 40
            height: 30
            text: "发送"
            size: 12
            onClicked: {
                chatRow.addTextEditText()
            }
        }
        function getPLableContent(html) {
            var regex = new RegExp("<p.*>.*</p>")
            var p = regex.exec(html)
            var regex1 = new RegExp("</?p.*?>", "g")
            var text = p[0].replace(regex1, "")
            return text
        }
        function addTextEditText() {
            addChatData(me, getPLableContent(textEdit.text))
            textEdit.text = ""
        }
    }
}
