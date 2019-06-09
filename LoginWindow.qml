import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.3
import FlatUI 2.0

Item {
    id: logingItem
    width: 550
    height: 330

    signal logined(var playerInfo)

    function goBack() {
        logingItem.visible = false
        rootRect.visible = true
    }
    function reset() {
        accountInput.text = ""
        passwdInput.text = ""
    }

    function check() {
        if(accountInput.text === "" || passwdInput.text === "") {
            return -1
        }
        if(accountInput.text.length < 4 || accountInput.text.length > 12) {
            return -2
        }
        if(passwdInput.text.length < 4 || passwdInput.text.length > 12) {
            return -3
        }
        return 0
    }

    function login() {
        var t1 = Date.now()
        var playerInfo = LoginAndReg.login(accountInput.text, passwdInput.text)
        var t2 = Date.now()

        var c = check()
        if(c !== 0) {
            switch(c) {
            case -1:
                loginMessageDialog.text = "登录信息不完整"
                break;
            case -2: case -3:
                loginMessageDialog.text = "账号密码输入不正确"
                break;
            }
            loginMessageDialog.visible = true
            return
        }

        switch(playerInfo["result"]) {
        case -1:
            loginMessageDialog.text = "网络异常"
            break;
        case -2:
            loginMessageDialog.text = "账号密码输入不正确"
            break;
        }

        if(playerInfo["result"] !== 0) {
            loginMessageDialog.visible = true
            return
        }

        if(tabPositionGroup.current === manager) {
            logingItem.visible = false
            managerWindow.visible = true
            return
        }

        playerInfo["playerInfo"]["account"] = accountInput.text
        logined(playerInfo["playerInfo"])
        reset()
        goBack()

    }

    MessageDialog {
        id: loginMessageDialog
        title: "登录提示"
    }
    Column {
        RowLayout {
            ExclusiveGroup { id: tabPositionGroup }
            FlatRadio {
                id: player
                text: qsTr("玩家")
                exclusiveGroup: tabPositionGroup
                checked: true
                Layout.minimumWidth: 100
            }
            FlatRadio {
                id: manager
                text: qsTr("管理员")
                exclusiveGroup: tabPositionGroup
                Layout.minimumWidth: 100
            }
        }
        anchors.centerIn: parent
        spacing: 15
        Row {
            Text{
                text: "账号"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            FlatTextField {
                id: accountInput
                placeholderText: "请输入账号"
            }
        }
        Row {
            Text{
                text: "密码"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            FlatTextField {
                id: passwdInput
                echoMode: TextInput.Password
                placeholderText: "请输入密码"
            }
        }
        Row{
            spacing: parent.width - loginBtn.width - quitBtn.width
            FlatButton {
                id: loginBtn
                text: "登录"
                onClicked: {
                    login()
                }
            }
            FlatButton {
                id: quitBtn
                text: "退出"
                onClicked: {
                    reset()
                    goBack()
                }
            }
        }
    }
}
