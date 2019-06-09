import QtQuick 2.0
import QtQuick.Window 2.0
import FlatUI 2.0
import QtQuick.Dialogs 1.3

Item {
    id: regItem
    width: 550
    height: 330

    function reset() {
        accountInput.text = ""
        passwdInput.text = ""
        passwdInputAgain.text = ""
        nicknameInput.text = ""
    }

    function check() {
        accountInput.text = accountInput.text.replace( /^\s*/, '')
        accountInput.text = accountInput.text.replace(/(\s*$)/g, "")
        passwdInput.text = passwdInput.text.replace( /^\s*/, '')
        passwdInput.text = passwdInput.text.replace(/(\s*$)/g, "")
        passwdInputAgain.text = passwdInputAgain.text.replace( /^\s*/, '')
        passwdInputAgain.text = passwdInputAgain.text.replace(/(\s*$)/g, "")
        nicknameInput.text = nicknameInput.text.replace( /^\s*/, '')
        nicknameInput.text = nicknameInput.text.replace(/(\s*$)/g, "")

        if(accountInput.text.length < 4 || accountInput.text.length > 12)
            return -1
        if(passwdInput.text.length < 4 || passwdInput.text.length > 12)
            return -2
        if(passwdInput.text === "" || passwdInputAgain.text === "" || nicknameInput.text === "")
            return -3
        if(passwdInput.text != passwdInputAgain.text)
            return -4

        return 0
    }

    function register() {
        var checkRet = regItem.check()
        if(checkRet !== 0) {
            switch(checkRet) {
            case -1:
                errInfoDialog.text = "账号长度应大于4小于12"
                break;
            case -2:
                errInfoDialog.text = "密码长度应大于4小于12"
                break;
            case -3:
                errInfoDialog.text = "输入信息都不能为空"
                break
            case -4:
                errInfoDialog.text = "密码再次确认失败"
                break
            }
            errInfoDialog.visible = true
            return
        }

        var regRet = LoginAndReg.reg(accountInput.text, passwdInput.text, nicknameInput.text)
        if(!regRet) {
            errInfoDialog.text = "账号已被注册"
            errInfoDialog.visible = true
            return
        }

        errInfoDialog.text = "注册成功"
        errInfoDialog.visible = true
    }

    MessageDialog {
        id: errInfoDialog
        title: "注册信息不正确"
    }

    Column {
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
        Row {
            Text{
                text: "密码"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            FlatTextField {
                id: passwdInputAgain
                echoMode: TextInput.Password
                placeholderText: "请再次输入密码"
            }
        }
        Row {
            Text{
                text: "昵称"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            FlatTextField {
                id: nicknameInput
                placeholderText: "请输入昵称"
            }
        }
        Row{
            spacing: parent.width - loginBtn.width - quitBtn.width
            FlatButton {
                id: loginBtn
                text: "注册"
                onClicked: {
                    register()
                }
            }
            FlatButton {
                id: quitBtn
                text: "退出"
                onClicked: {
                    reset()
                    regItem.visible = false
                    rootRect.visible = true
                }
            }
        }
    }
}
