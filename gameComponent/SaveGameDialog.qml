import QtQuick 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import FlatUI 2.0

Window {
    id: saveGameMessageDialog
    width: 400
    height: 170
    modality: Qt.ApplicationModal
    signal save(var name)
    Component.onCompleted: {
        close()
    }
    Row {
        spacing: 15
        anchors.centerIn: parent
        Text {
            text: "请输入保存棋局名字"
            height: 30
            verticalAlignment: TextInput.AlignVCenter
        }
        FlatTextField {
            id: nameInput
            width: 200
            height: 30
            placeholderText: "输入棋局名字"
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        spacing: 50
        FlatButton {
            text: "保存"
            onClicked : {
                save(nameInput.text)
                saveGameMessageDialog.close()
            }
        }
        FlatButton {
            text: "取消"
            onClicked : {
                saveGameMessageDialog.close()
            }
        }
    }
}
