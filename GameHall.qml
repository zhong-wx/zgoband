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
            updateSavedGameList()
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

    function updateSavedGameList() {
        if(gameSavedModel.count > 1)
            gameSavedModel.remove(1, gameSavedModel.count-1)
        var ret = GameHallRPC.getSavedGameList(rootWindow.selfInfo["account"])
        if(ret["failType"] !== 0) {
            switch(ret["failType"]) {
            case -1:
                gameHallMsgDialog.text = "网络出现异常，获取保存棋局列表失败，详情："+ret["errInfo"]
                break
            case -2:
                gameHallMsgDialog.text = "服务器出现异常，获取保存棋局列表失败，详情："+ret["errInfo"]
                break
            case -3:
                gameHallMsgDialog.text = "客户端出现异常，获取保存棋局列表失败，详情："+ret["errInfo"]
                break;
            }
            gameHallMsgDialog.visible = true
            return
        }

        var savedGameList = ret["savedGameList"];
        for(var i=0; i<savedGameList.length; i++) {
            var savedGame = savedGameList[i]
            gameSavedModel.append({"gameID":savedGame.id, "name":savedGame.name, "savedTime":savedGame.saveTime})
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

    function addSavedGame(id, name, savedTime) {
        console.log("addSavedGame:", JSON.stringify({"gameID":id, "name":name, "savedTime":savedTime}))
        gameSavedModel.append({"gameID":id, "name":name, "savedTime":savedTime})
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
            gameID: -1
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
            spacing: 30
            FlatButton {
                id: autoMatchBtn
                text: "匹配"
                onClicked: {
                    autoMatch()
                }
            }
            FlatButton {
                id: backtoHall
                text: "返回"
                onClicked: {
                    gameHallItem.visible = false
                    rootRect.visible = true
                }
            }
        }

        DetailPlayerInfo {
            id: detailPlayerInfo
            height: 200
            width: 150
        }


        ListView {
            id: gameSavedListView
            model: gameSavedModel
            height: 250
            width: 170//gameHallItem.width - deskListScrollView - 10
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            delegate: MouseArea {
                height: 25
                width: parent.width
                onClicked: {
                   ListView.view.currentIndex = index
                }
                Row {
                    spacing: 10
                    Text {
                        width: 80
                        height: 25
                        text: name
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        height: 25
                        text: savedTime
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
        Row {
            spacing: 30
            FlatButton {
                id: lookGameSavedBtn
                text: "查看"
                onClicked: {
                    //var gameProcess = {"process":[{"Row":8,"Column":9},{"Row":8,"Column":10},{"Row":8,"Column":11}]}
                    //gameWindow.setStatus(3, 0, 0, gameProcess)
                    //gameHallItem.visible = false
                    //gameWindow.visible = true
                    var id = gameSavedModel.get(gameSavedListView.currentIndex).gameID
                    var ret = GameHallRPC.getSavedGame(id)
                    if(ret["failType"] !== 0) {
                        switch(ret["failType"]) {
                        case -1:
                            gameHallMsgDialog.text = "网络出现异常，自动匹配失败，详情："+ret["errInfo"]
                            break
                        case -2:
                            gameHallMsgDialog.text = "服务器出现异常，自动匹配失败，详情："+ret["errInfo"]
                            break
                        case -3:
                            gameHallMsgDialog.text = "应用程序发生异常，详情："+ret["errInfo"]
                        }
                        gameHallMsgDialog.visible = true
                        return
                    }
                    gameWindow.resetGameWindow()
                    gameWindow.setStatus(3, 0, 0, ret["record"]["process"])
                    gameHallItem.visible = false
                    gameWindow.visible = true
                }
            }
            FlatButton {
                id: delGameSavedBtn
                text: "删除"
                onClicked: {
                    var index = gameSavedListView.currentIndex
                    var id = parseInt(gameSavedModel.get(index).gameID)
                    var ret = GameHallRPC.delSavedGame(id)
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
                    gameSavedModel.remove(index)
                }
            }
        }
    }
}
