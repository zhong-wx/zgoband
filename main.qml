import QtQuick 2.1
import QtQuick.Window 2.11
import FlatUI 2.0
import "./gameComponent"

Window {
    id: rootWindow
    width: gameWindow.width
    height: gameWindow.height
    visible: true

    property var selfInfo

    function recvJsonObj(jsonObj) {
        switch (jsonObj["messageType"]) {
        case 0:
            gameHall.addPlayer(jsonObj["deskID"], jsonObj["seatID"], jsonObj["account"])
            // account=="" mean leave seat
            if(jsonObj["account"]!=="")
                gameWindow.addTheOtherSide(jsonObj["deskID"], jsonObj["seatID"], jsonObj["playerInfo"])
            else
                gameWindow.removeTheOtherSide(jsonObj["deskID"], jsonObj["seatID"])
            break;
        case 1:
            gameHall.setReady(jsonObj["deskID"], jsonObj["seatID"], jsonObj["isReady"])
            gameWindow.setOtherSideReady(jsonObj["deskID"], jsonObj["seatID"], jsonObj["isReady"])
            break;
        case 2:
            gameWindow.putChess(jsonObj["row"], jsonObj["column"], jsonObj["result"])
            break;
        case 3:
            //接受到请求悔棋消息
            gameWindow.reqestTackBack()
            break;
        case 4:
            // 执行悔棋操作
            gameWindow.takeBack(jsonObj["resp"], jsonObj["whoReq"], jsonObj["whoResp"], jsonObj["lastSteps"])
            break
        case 5:
            // 收到对方认输消息
            gameWindow.recvLoseReq()
            break
        case 6:
            // 收到对方和棋请求
            gameWindow.recvDrawReq()
            break
        case 7:
            // 收到请求和棋的回复
            gameWindow.recvDrawRespond(jsonObj["resp"])
            break;
        case 8:
            //收到聊天消息
            gameWindow.addChatTextMessage(jsonObj["text"])
        }
    }

    function netWorkError(err) {
        console.log("call netWorkError")
        console.log(err)
    }

    GameWindow {
        id: gameWindow
        visible: false
    }
    GameHall {
        id: gameHall
        visible: false
        anchors.fill: parent
    }
    LoginWindow {
        id: loginWindow
        visible: false
        anchors.centerIn: parent
        onLogined: {
            detailPlayerInfo.addPlayerInfo(playerInfo["account"], playerInfo["nickname"]
                                           , playerInfo["score"], playerInfo["winRound"]
                                           , playerInfo["loseRound"], playerInfo["drawRound"]
                                           , playerInfo["escapeRound"])
            detailPlayerInfo.display(playerInfo["account"])
            selfInfo = playerInfo
            //detailPlayerInfo.visible = true
            gameHallBtn.type = FlatGlobal.typePrimary
        }
    }
    RegisterWindow {
        id: registerWindow
        visible: false
        anchors.centerIn: parent
    }
    DetailPlayerInfo {
        width: 130
        anchors.right: parent.right
        anchors.top: parent.top
        id: detailPlayerInfo
        visible: false
    }

    Item {
        id: rootRect
        anchors.fill: parent
        Column {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            anchors.bottomMargin: 25
            spacing: 25


            FlatButton {
                text: "登录"
                onClicked: {
                    rootRect.visible = false
                    loginWindow.visible = true
                }
            }
            FlatButton {
                text: "注册"
                onClicked: {
                    rootRect.visible = false
                    registerWindow.visible = true
                }
            }
            FlatButton {
                text: "人机对弈"
                onClicked: {
                    rootRect.visible = false
                    gameWindow.visible = true
                }
            }
            FlatButton {
                id: gameHallBtn
                text: "网络对弈"
                type: FlatGlobal.typeDisabled
                onClicked: {
                    rootRect.visible = false
                    gameHall.visible = true
                }
            }
        }
    }
}
