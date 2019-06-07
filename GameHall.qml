import QtQuick 2.0
import QtQuick.Controls 1.4
import "./gameComponent"
import FlatUI 2.0
import QtQuick.Dialogs 1.3

Item {
    id: gameHallItem

    onVisibleChanged: {
        if(visible) {
            updateDeskList()
            var playerInfo = rootWindow.selfInfo
            detailPlayerInfo.addPlayerInfo(playerInfo["account"], playerInfo["nickname"]
                                           , playerInfo["score"], playerInfo["winRound"]
                                           , playerInfo["loseRound"], playerInfo["drawRound"]
                                           , playerInfo["escapeRound"])
            detailPlayerInfo.display(playerInfo["account"])
        }
    }

    function updatePlayerInfo(result, account) {
        detailPlayerInfo.updatePlayerInfo(result, account)
    }

    function updateDeskList() {
        var result = GameHallRPC.getDeskList();
        if(result["failType"] !== 0) {
            return result["errInfo"];
        }
        deskListModel.clear()
        var lastDeskID = 0;
        for(var i=0; i<result["deskList"].length; i++) {
            var curDeskID = result["deskList"][i]["deskID"]
            if(curDeskID - lastDeskID > 1) {
                for(var j=lastDeskID+1; j<curDeskID; j++)
                    deskListModel.append({"deskID":j, "player1":"", "player2":"","isReady1":false,"isReady2":false})
            }
            deskListModel.append({"deskID":result["deskList"][i]["deskID"]
                                 , "player1":result["deskList"][i]["player1"]
                                 , "player2":result["deskList"][i]["player2"]
                                 , "isReady1":result["deskList"][i]["ready1"]
                                 , "isReady2":result["deskList"][i]["ready2"]
                                 })
            lastDeskID = curDeskID
        }


        for(var t=lastDeskID+1; t<=100; t++) {
            deskListModel.append({"deskID":t, "player1":"", "player2":"","isReady1":false,"isReady2":false})
        }
    }

    // 有人入座
    function addPlayer(deskID, seatID, account) {
        for(var i=0; i<deskListModel.count; i++) {
            if (deskListModel.get(i).deskID === deskID) {
                switch(seatID) {
                case 1:
                    deskListModel.setProperty(i, "player1", account)
                    if(account === "")
                        deskListModel.setProperty(i, "isReady1", false)
                    break;
                case 2:
                    deskListModel.setProperty(i, "player2", account)
                    if(account === "")
                        deskListModel.setProperty(i, "isReady2", false)
                    break;
                }
            }
        }
    }

    // 有人准备
    function setReady(deskID, seatID, isReady) {
        for(var i=0; i<deskListModel.count; i++) {
            if (deskListModel.get(i).deskID === deskID) {
                switch(seatID) {
                case 1:
                    deskListModel.setProperty(i, "isReady1", isReady)
                    break;
                case 2:
                    deskListModel.setProperty(i, "isReady2", isReady)
                    break;
                }
                return
            }
        }
    }

    function sitdown(deskID, seatID) {
        var result = GameHallRPC.sitDown(rootWindow.selfInfo["account"], deskID, seatID)
        if(result["success"])
            return true;
        switch(result["failType"]) {
        case -1:
            gameHallMsgDialog.text = "服务器出现错误, 详细：" + result["errInfo"]
            break
        case -2:
            gameHallMsgDialog.text = "网络出现错误, 详细：" + result["errInfo"]
            break
        case 0:
            gameHallMsgDialog.text = "已有人在该座位上"
        }
        gameHallMsgDialog.visible = true
        return false
    }

    function gotoGameWindow(deskID, seatID) {
        gameHallItem.visible = false
        gameWindow.visible = true
        gameWindow.resetGameWindow()

        gameWindow.setStatus(2, deskID, seatID)
        var seatInfo = GameHallRPC.getSeatInfo(deskID, seatID===1?2:1)
        gameWindow.addPlayerInfo(seatID, rootWindow.selfInfo, false)
        if(seatInfo["failType"] === 0) {
            gameWindow.addPlayerInfo(seatID===1?2:1, seatInfo["playerInfo"], seatInfo["playerInfo"]["isReady"])
        } else if(seatInfo["failType"] !== -2){
            gameHallMsgDialog.text = "failType="+seatInfo["failType"]+seatInfo["errInfo"]
            gameHallMsgDialog.visible = true
        }
    }

    function autoMatch() {
        var ret = GameHallRPC.autoMatch(rootWindow.selfInfo["account"])
        if(ret["failType"] !== 0) {
            switch(ret["failType"]) {
            case -1:
                gameHallMsgDialog.text = "网络出现异常，自动匹配失败，详情："+ret["errInfo"]
                break
            case -2:
                gameHallMsgDialog.text = "服务器出现异常，自动匹配失败，详情："+ret["errInfo"]
                break
            }
            gameHallMsgDialog.visible = true
            return
        }
        if(!ret["isFound"]) {
            gameHallMsgDialog.text = "自动匹配失败，请稍后再试"
            gameHallMsgDialog.visible = true
            return
        }
        gotoGameWindow(ret["deskID"], ret["seatID"])
    }

    MessageDialog {
        id: gameHallMsgDialog
        title: "大厅提示"
    }
    ListModel {
        id: deskListModel
        ListElement{
            deskID: 1
            player1: ""
            player2: ""
            isReady1: false
            isReady2: false
        }
    }

    ListModel {
        id: gameSavedModel
        ListElement {
            name: "棋局保存名字"
            savedTime: "棋局保存时间"
        }
    }

    Component {
        id: deskDelegate
        Item{
            width: 150
            height: 105
            Image {
                id: deskImage
                source: isReady1&&isReady2 ? "qrc:/resouces/tables.png" : "qrc:/resouces/tableh.png"
                anchors.centerIn: parent

                Image {
                    id: isReady1Image
                    anchors.left: deskImage.left
                    anchors.leftMargin: 55
                    anchors.verticalCenter: deskImage.verticalCenter
                    source: "qrc:/resouces/hand.png"
                    visible: isReady1 && !isReady2
                }
                Image {
                    id: isReady2Image
                    anchors.right: deskImage.right
                    anchors.rightMargin: 55
                    anchors.verticalCenter: deskImage.verticalCenter
                    source: "qrc:/resouces/hand.png"
                    visible: isReady2 && !isReady1
                }

                Image {
                    id: player1Image
                    source: player1==="" ? "qrc:/resouces/Seat.png" : "qrc:/resouces/person.png"
                    anchors.left: parent.left
                    anchors.leftMargin: 9
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(sitdown(deskID, 1)) {
                                gotoGameWindow(deskID, 1)
                            }
                        }
                    }
                }
                Text{
                    anchors.horizontalCenter: player1Image.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    visible: player1==="" ? false : true
                    text: player1
                }
                Image {
                    id: player2Image
                    source: player2==="" ? "qrc:/resouces/Seat.png" : "qrc:/resouces/person.png"
                    anchors.right: parent.right
                    anchors.rightMargin: 9
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(sitdown(deskID, 2)) {
                                gotoGameWindow(deskID, 2)
                            }
                        }
                    }
                }
                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 15
                    anchors.horizontalCenter: player2Image.horizontalCenter
                    visible: player2==="" ? false : true
                    text: player2
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    text: deskID
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    ScrollView {
        id: deskListScrollView
        width: 620
        height: parent.height

        GridView {
            id: deskGridView
            delegate: deskDelegate
            model: deskListModel
            width: parent.width
            height: parent.height
            cellHeight: 105
            cellWidth: 150
        }
    }

    Column {
        spacing: 5
        anchors.left: deskListScrollView.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 5

        Row {
            FlatButton {
                id: autoMatchBtn
                text: "自动匹配"
                onClicked: {
                    autoMatch()
                }
            }
            FlatButton {
                id: backtoHall
                text: "回到大厅"
                onClicked: {
                }
            }
        }

        DetailPlayerInfo {
            id: detailPlayerInfo
            height: 200
            width: 150
        }


        ListView {
            id: gameSavedBtn
            model: gameSavedModel
            height: 250
            width: 100//gameHallItem.width - deskListScrollView - 10
            delegate: Row {
                spacing: 10
                Text {
                    width: 90
                    text: name
                }
                Text {
                    width: 90
                    text: savedTime
                }
            }
        }
        FlatButton {
            id: viewGameSavedBtn
            text: "查看保存棋局"
        }
    }
}
