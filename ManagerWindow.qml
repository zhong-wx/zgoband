import QtQuick 2.0
import QtQuick.Dialogs 1.1
import FlatUI 2.0

Item {
    id: managerWindow

    function displayPlayerInfo(playerInfo) {
        nicknameInput.text = playerInfo.nickname
        scoreInput.text = playerInfo.score
        winRoundInput.text = playerInfo.winRound
        loseRoundInput.text = playerInfo.loseRound
        escapeRoundInput.text = playerInfo.escapeRound
        drawRoundInput.text = playerInfo.drawRound
    }

    function checkInputEmpty() {
        if(nicknameInput.text==="" || scoreInput.text==="" || winRoundInput.text==="" || loseRoundInput.text===""
                || escapeRoundInput.text==="" || drawRoundInput.text==="")
            return true
        return false
    }

    MessageDialog {
        id: messageDialog
    }
    Column {
        anchors.centerIn: parent
        spacing: 10
        Row{
            spacing: 15
            FlatTextField {
                id: accountInput
                placeholderText: "请输入玩家账号"
            }
            FlatButton {
                text: "搜索"
                onClicked: {
                    if(accountInput.text === "") {
                        messageDialog.text = "请输入玩家账号"
                        messageDialog.visible = true
                        return
                    }
                    var ret = GameOperatorRPC.getPlayerInfo(accountInput.text)
                    if(ret["failType"] !== 0) {
                        switch(ret["failType"]) {
                        case -1:
                            gameHallMsgDialog.text = "网络出现异常，搜索失败，详情："+ret["errInfo"]
                            break
                        case -2:
                            gameHallMsgDialog.text = "找不到该账号，搜索失败，详情："+ret["errInfo"]
                            break
                        }
                        gameHallMsgDialog.visible = true
                        return
                    }
                    displayPlayerInfo(ret["playerInfo"])
                }
            }
        }
        Row {
            Text {
                text: "昵称"
                width: 90
                height: 40
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            FlatTextField {
                id: nicknameInput
            }
        }
        Row {
            Text {
                text: "积分"
                width: 90
                height: 40
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            FlatTextField {
                id: scoreInput
            }
        }
        Row {
            Text {
                text: "赢回合数"
                width: 90
                height: 40
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            FlatTextField {
                id: winRoundInput
            }
        }
        Row {
            Text {
                text: "输回合数"
                width: 90
                height: 40
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            FlatTextField {
                id: loseRoundInput
            }
        }
        Row {
            Text {
                text: "和棋回合数"
                width: 90
                height: 40
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            FlatTextField {
                id: drawRoundInput
            }
        }
        Row {
            Text {
                text: "逃跑回合数"
                width: 90
                height: 40
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            FlatTextField {
                id: escapeRoundInput
            }
        }
        Row {
            spacing: 40
            FlatButton {
                text: "封号"
                onClicked: {
                    if(accountInput.text === "") {
                        messageDialog.text = "请输入账号"
                        messageDialog.visible = true
                        return
                    }
                    var ret = GameOperatorRPC.blockAccount(accountInput.text)
                    if(ret["failType"] !== 0) {
                        switch(ret["failType"]) {
                        case -1:
                            gameHallMsgDialog.text = "网络出现异常，搜索失败，详情："+ret["errInfo"]
                            break
                        case -2:
                            gameHallMsgDialog.text = "找不到该账号，搜索失败，详情："+ret["errInfo"]
                            break
                        }
                        gameHallMsgDialog.visible = true
                        return
                    }
                    messageDialog.text = "封号成功"
                    messageDialog.visible = true
                }
            }
            FlatButton {
                text: "修改"
                onClicked: {
                    if(managerWindow.checkInputEmpty()) {
                        messageDialog.text = "输入不完整"
                        messageDialog.visible = true
                        return
                    }
                    var ret = GameOperatorRPC.blockAccount(accountInput.text, nicknameInput.text, parseInt(scoreInput.text), parseInt(winRoundInput.text), parseInt(loseRoundInput.text), parseInt(drawRoundInput.text), parseInt(escapeRoundInput.text))
                    if(ret["failType"] !== 0) {
                        switch(ret["failType"]) {
                        case -1:
                            gameHallMsgDialog.text = "网络出现异常，更新失败，详情："+ret["errInfo"]
                            break
                        case -2:
                            gameHallMsgDialog.text = "找不到该账号，更新失败，详情："+ret["errInfo"]
                            break
                        }
                        gameHallMsgDialog.visible = true
                        return
                    }
                    messageDialog.text = "修改成功"
                    messageDialog.visible = true
                }
            }
            //FlatButton {
            //    text: "返回"
            //    onClicked: {
            //        managerWindow.visible = false
            //        rootRect.visible = true
            //    }
            //}
        }
    }
}
