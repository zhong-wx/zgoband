import QtQuick 2.7
import QtQuick.Window 2.2
import FlatUI 2.0
import QtQuick.Dialogs 1.1
import "./gameComponent"
import "qrc:/js/humanWithComputerAlgorithm.js" as Code

Rectangle {
    id: root
    width: 20 + chessboard.width + rightItem.width
    height: leftItem.height

    function showGetReadyBtn() {
        getReadyBtn.clickable = true
        getReadyBtn.type = FlatGlobal.typePrimary
    }

    property int gameType: 1
    // player in seat 1
    property var player1
    // player in seat 2
    property var player2


    property var me: {
        if (seatID == 1)
            return player1
        return player2
    }
    property var other: {
        if (seatID == 1)
            return player2
        return player1
    }


    property int deskID
    property int seatID

    // yourself
    property bool isReady1: false
    // the other side
    property bool isReady2: false

    property var gameProcess
    property int step: -1

    onVisibleChanged: {
        if(gameType === 3) {
            lastStep.visible = true
            nextStep.visible = true
            getReadyBtn.visible = false
            takeBackBtn.visible = false
            wantDrawBtn.visible = false
            giveUpBtn.visible = false
            quitBtn.visible = true
        } else if(gameType === 1) {
            getReadyBtn.visible = true
            quitBtn.visible = true
            lastStep.visible = false
            takeBackBtn.visible = false
            wantDrawBtn.visible = false
            saveGameBtn.visible = false
        }
    }

    onGameTypeChanged: {
        if(gameType === 3) {
            lastStep.visible = true
            nextStep.visible = true
            getReadyBtn.visible = false
            takeBackBtn.visible = false
            wantDrawBtn.visible = false
            giveUpBtn.visible = false
            quitBtn.visible = true
        } else if(gameType === 1) {
            getReadyBtn.visible = true
            quitBtn.visible = true
            lastStep.visible = false
            takeBackBtn.visible = false
            wantDrawBtn.visible = false
            saveGameBtn.visible = false
        } else if(gameType === 2) {
            lastStep.visible = false
            nextStep.visible = false

            giveUpBtn.visible = true
            getReadyBtn.visible = true
            quitBtn.visible = true
            takeBackBtn.visible = true
            wantDrawBtn.visible = true
            saveGameBtn.visible = true
        }
    }

    function showMessageDialog(text) {
        gameWindowMsgDialog.text = text
        gameWindowMsgDialog.visible = true
    }

    function resetGameWindow() {
        console.log("resetGameWindow")
        resetPlayerInfo()
        chessboard.reset()
        player1Timer.reset()
        player2Timer.reset()
        getReadyBtn.reset()
        player1Timer.reset()
        player2Timer.reset()
    }

    function resetPlayerInfo() {
        players.clear()
        playerInfoRec.reset()
        player1 = null
        player2 = null
        isReady1 = false
        console.log("set ready false")
        isReady2 = false
    }

    // 针对seatID==1的玩家,此类玩家为黑棋先手
    function checkIsBegin() {
        if (player1 === null || player2 === null)
            return
        if(isReady1===true && isReady2===true && root.seatID===1) {
            chessboard.inYourTurn = true
            player1Timer.timerStart()
        }
        if(isReady1===true && isReady2===true && root.seatID===2) {
            player2Timer.timerStart()
        }

        if(isReady1===true && isReady2===true) {
            getReadyBtn.disable()
        }
    }

    function gotoMainWindow() {
        root.visible = false
        rootRect.visible = true
    }
    function gotoGameHall() {
        if(isReady1 && isReady2) {
            quitMessageDialog.title = "退出提示"
            quitMessageDialog.text = "现在退出游戏将会扣除你5积分，是否退出？"
            quitMessageDialog.standardButtons = MessageDialog.Ok | MessageDialog.Cancel
            quitMessageDialog.visible = true
        } else {
            leaveSit()
        }
    }

    function setStatus(gameType, deskID, seatID, gameProcess) {
        root.gameType = gameType
        if(gameType === 2) {
            root.deskID = deskID
            root.seatID = seatID
        } else if (gameType === 3) {
            root.gameProcess = gameProcess
        }
    }
    // 从座位离开
    function removeTheOtherSide(deskID, seatID) {
        if(deskID !== root.deskID || seatID === root.seatID)
            return
        switch(seatID) {
        case 1:
            players.removePlayer(player1["account"])
            playerInfoRec.removePlayerInfo(player1["account"])
            player1 = null
            break;
        case 2:
            players.removePlayer(player2["account"])
            playerInfoRec.removePlayerInfo(player2["account"])
            player2 = null
            break;
        }
        if(isReady1 && isReady2)
            gameEnd(-1, 4)
        isReady2 = false
    }

    // 有对手玩家进入桌子
    function addTheOtherSide(deskID, seatID, playerInfo) {
        if(deskID !== root.deskID || seatID === root.seatID)
            return
        addPlayerInfo(seatID, playerInfo, false)
    }

    // 点击座位后添加玩家
    function addPlayerInfo(seatID, playerInfo, isReady){
        if(seatID === 1)
            player1 = playerInfo
        else if(seatID === 2) {
            player2 = playerInfo
        }
        if (seatID !== root.seatID)
            isReady2 = isReady
        playerInfoRec.addPlayerInfo(playerInfo["account"], playerInfo["nickname"]
                                       , playerInfo["score"], playerInfo["winRound"]
                                       , playerInfo["loseRound"], playerInfo["drawRound"]
                                       , playerInfo["escapeRound"])
        players.addPlayerInfo(playerInfo["nickname"], playerInfo["account"], isReady)
    }

    // 收到对方发送的聊天消息
    function addChatTextMessage(text) {
        chatRect.addChatData(other["nickname"], text)
    }

    function recvLoseReq() {
        gameEnd(-1, 5)
    }

    function putChess(row, column, result) {
        chessboard.player2PutAPiece(row, column, result)
        if(result === 0) {
            player1Timer.timerStart()
            chessboard.inYourTurn = true
        }

        player2Timer.timerStop()
    }

    // 接受请求悔棋
    function reqestTackBack() {
        takeBackRespDialog.open()
    }

    function recvDrawReq() {
        drawRespDialog.open()
    }

    // 和棋请求回复
    function recvDrawRespond(resp) {
        if(resp) {
            gameEnd(-1, 2)
        } else {
            gameWindowMsgDialog.text = "对方拒绝你的和棋请求"
            gameWindowMsgDialog.visible = true
        }
    }

    // 悔棋操作
    function takeBack(resp, whoReq, whoResp, lastSteps) {
        if(!resp) {
            if(me["account"] === whoReq) {
                gameWindowMsgDialog.text = "对方拒绝你悔棋"
                gameWindowMsgDialog.visible = true
            }
            return
        }
        for(var i=1; i<lastSteps.length; i++)
            chessboard.takeBack(lastSteps[i].Row, lastSteps[i].Column)
        chessboard.setLastPos(lastSteps[0].Row, lastSteps[0].Column)
        if(me["account"] === whoReq) {
            player1Timer.timerStart()
            player2Timer.timerStop()
            chessboard.inYourTurn = true
        } else {
            player1Timer.timerStop()
            player2Timer.timerStart()
            chessboard.inYourTurn = false
        }
    }

    // 另一方的准备状态发送变化
    function setOtherSideReady(deskID, seatID, isReady) {
        if(!root.visible || seatID===root.seatID)
            return
        isReady2 = isReady
        players.setReady(seatID===1?player1["account"]:player2["account"], isReady)
        checkIsBegin()
    }

    // 点击了准备按钮
    function setReady() {
        // 1 mean human with computor game, 2 mean human with human
        if(gameType == 1) {
            player1Timer.timerStart()
            chessboard.reset()
            chessboard.inYourTurn = true
            getReadyBtn.disable()
        } else if(gameType == 2) {
            var result = GameHallRPC.setReady(me["account"], deskID, seatID, !isReady1)
            if(result["failType"] !== 0) {
                switch (result["failType"]) {
                case -1:
                    gameWindowMsgDialog.text = "网络出现问题，详情：" + result["errInfo"]
                    break;
                case -2:
                    gameWindowMsgDialog.text = "服务器出现问题，详情：" + result["errInfo"]
                    break;
                }
                gameWindowMsgDialog.visible = true
                return
            }

            isReady1 = !isReady1

            if(isReady1) {
                getReadyBtn.text = "取消"
                players.setReady(me["account"], true)
                restart()
            } else {
                getReadyBtn.text = "准备"
                players.setReady(me["account"], false)
            }

            checkIsBegin()
        }
    }

    // player in seatID win
    // 弹出对话框，更新详细信息界面，回到未准备状态
    function gameEnd(seatID, result) {
        gameWindowMsgDialog.title = "本局游戏结束"
        if (result === 1) {
            // 更新详细信息，已决胜负
            playerInfoRec.updatePlayerInfo(1, seatID===1?player1["account"]:player2["account"])
            playerInfoRec.updatePlayerInfo(-1, seatID===2?player1["account"]:player2["account"])
            gameHall.updatePlayerInfo(seatID===root.seatID?1:-1, me["account"])

            if(seatID === 1) {
                gameWindowMsgDialog.text = "本局游戏" + player1["nickname"] + "胜出"
            }
            else if(seatID === 2){
                gameWindowMsgDialog.text = "本局游戏" + player2["nickname"] + "胜出"
            }
            else {
                gameWindowMsgDialog.text = "unkownPlayer" + " 胜出"
            }
        } else if(result === 2) {
            // 更新详细信息, 和棋
            playerInfoRec.updatePlayerInfo(0, player1["account"])
            playerInfoRec.updatePlayerInfo(0, player2["account"])
            gameHall.updatePlayerInfo(0, me["account"])

            gameWindowMsgDialog.text = "本局游戏和棋"
        } else if(result === 3) {
            // 更新详细信息, 逃跑
            gameHall.updatePlayerInfo(-2, me["account"])
            return
        } else if(result === 4) {
            // 更新详细信息, 对方逃跑
            playerInfoRec.updatePlayerInfo(1, me["account"])
            gameHall.updatePlayerInfo(1, me["account"])
            gameWindowMsgDialog.text = "对方逃跑，本局游戏你获得胜利"
        } else if(result === 5) {
            // 更新详细信息,对方认输
            playerInfoRec.updatePlayerInfo(1, me["account"])
            playerInfoRec.updatePlayerInfo(-1, other["account"])
            gameHall.updatePlayerInfo(1, me["account"])
            gameWindowMsgDialog.text = "对方认输，本局游戏你获得胜利"
        }

        gameWindowMsgDialog.visible = true

        getReadyBtn.reset()
        player1Timer.timerStop()
        player2Timer.timerStop()
        players.setAllNotReady()
        chessboard.inYourTurn = false
        root.isReady1 = false
        root.isReady2 = false
    }

    function restart() {
        chessboard.reset()
        player1Timer.reset()
        player2Timer.reset()
    }

    function showGameHall() {
        root.visible = false
        gameHall.visible = true
    }

    function leaveSit() {
        var result = GameHallRPC.leaveSeat(me["account"], deskID, seatID)
        if(result["failType"] !== 0) {
            switch(result["failType"]){
            case -1:
                gameWindowMsgDialog.text = "网络异常，离座失败，详情：" + result["errInfo"]
                break
            case -2:
                gameWindowMsgDialog.text = "服务器异常，离座失败，详情：" + result["errInfo"]
                break
            }
            gameWindowMsgDialog.visible = true
            return
        }
        // 逃跑
        if(isReady1 && isReady2)
            gameEnd(-1, 3)
        showGameHall()
    }

    function requestTackBack() {
        var ret = GameOperatorRPC.takeBackReq(me["account"], other["account"], root.seatID)
        if(ret["failType"] !== 0) {
            switch(ret["failType"]) {
            case -1:
                gameWindowMsgDialog.text = "网络出现异常，请求悔棋失败，详情："+ret["errInfo"]
                break
            case -2:
                gameWindowMsgDialog.text = "服务器出现异常，请求悔棋失败，详情："+ret["errInfo"]
                break
            }
            gameWindowMsgDialog.visible = true
            return
        }
        if(ret["result"] === false) {
            gameWindowMsgDialog.text = "当前不能悔棋"
            gameWindowMsgDialog.visible = true
        }
    }

    function requestDraw() {
        var ret = GameOperatorRPC.drawReq(me["account"], other["account"], root.seatID)
        if(ret["failType"] !== 0) {
            switch(ret["failType"]) {
            case -1:
                gameWindowMsgDialog.text = "网络出现异常，请求和棋失败，详情："+ret["errInfo"]
                break
            case -2:
                gameWindowMsgDialog.text = "服务器出现异常，请求和棋失败，详情："+ret["errInfo"]
                break
            }
            gameWindowMsgDialog.visible = true
            return
        }
    }

    function responseTackBack(agree) {
        var ret = GameOperatorRPC.takeBackResp(player1["account"], player2["account"], root.seatID, agree)
        if(ret["failType"] !== 0) {
            switch(ret["failType"]) {
            case -1:
                gameWindowMsgDialog.text = "网络出现异常，悔棋失败，详情："+ret["errInfo"]
                break
            case -2:
                gameWindowMsgDialog.text = "服务器出现异常，悔棋失败，详情："+ret["errInfo"]
                break
            }
            gameWindowMsgDialog.visible = true
            return
        }
    }

    function responseDraw(agree) {
        var ret = GameOperatorRPC.drawResponse(player1["account"], player2["account"], root.deskID, root.seatID, agree)
        if(ret["failType"] !== 0) {
            switch(ret["failType"]) {
            case -1:
                gameWindowMsgDialog.text = "网络出现异常，和棋失败，详情："+ret["errInfo"]
                break
            case -2:
                gameWindowMsgDialog.text = "服务器出现异常，和棋失败，详情："+ret["errInfo"]
                break
            }
            gameWindowMsgDialog.visible = true
            return
        }
        if(agree)
            gameEnd(-1, 2)
    }

    function saveGame(gameName) {
        var ret = GameOperatorRPC.saveLastGame(me["account"], root.seatID, gameName)
        if(ret["failType"] !== 0) {
            switch(ret["failType"]) {
            case -1:
                gameWindowMsgDialog.text = "网络出现异常，保存失败失败，详情："+ret["errInfo"]
                break
            case -2:
                gameWindowMsgDialog.text = "服务器出现异常，保存失败失败，详情："+ret["errInfo"]
                break
            }
            gameWindowMsgDialog.visible = true
            return
        }
        if(ret["ret"] === -1) {
            gameWindowMsgDialog.text = "还未进行一局游戏，保存失败"
            gameWindow.visible = true
            return
        }
        var date = new Date()
        var day = date.getDate()
        var month = date.getMonth()
        var hour = date.getHours()
        var minute = date.getMinutes()
        var savedTime = month.toString() + "月"+ day.toString() + "日 " + hour.toString() + ":" + minute.toString()
        gameHall.addSavedGame(ret["ret"], gameName, savedTime)
    }

    MessageDialog {
        id: gameWindowMsgDialog
        title: "游戏提示"
    }
    MessageDialog {
        id: takeBackRespDialog
        title: "请求悔棋提示"
        text: "对方请求悔棋，是否同意对方悔棋"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: root.responseTackBack(true)
        onNo: root.responseTackBack(false)
    }
    MessageDialog {
        id: drawRespDialog
        title: "请求和棋提示"
        text: "对方请求和棋，是否同意对方和棋"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: root.responseDraw(true)
        onNo: root.responseDraw(false)
    }
    MessageDialog {
        id: drawReqDialog
        title: "请求和棋提示"
        text: "是否请求和棋？"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: root.requestDraw()
    }

    MessageDialog {
        id: takeBackMsgDialog
        title: "悔棋提示"
        text: "是否请求悔棋？"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            requestTackBack()
        }
    }

    MessageDialog {
        id: quitMessageDialog
        title: "退出提示"
        onAccepted: {
            leaveSit()
        }
    }
    MessageDialog {
        id: saveGameMessageDialog
        title: "保存棋局"
        text: "输入棋局名字"
        width: 400
        height: 200
        FlatTextField {
            id: gameNameInput
            width: 200
            height: 25
            placeholderText: "请输入棋局名字"
        }
        standardButtons: StandardButton.OK | StandardButton.Cancel
        onAccepted: saveGame(gameNameInput.text)
    }

    MessageDialog {
        id: reqLoseMessageDialog
        title: "认输提示"
        text: "你确定认输？"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            var ret = GameOperatorRPC.reqLose(me["account"], other["account"], root.deskID, root.seatID)
            if(ret["failType"] !== 0) {
                switch(ret["failType"]) {
                case -1:
                    gameWindowMsgDialog.text = "网络出现异常，请求认输失败，详情："+ret["errInfo"]
                    break
                case -2:
                    gameWindowMsgDialog.text = "服务器出现异常，请求认输失败，详情："+ret["errInfo"]
                    break
                }
                gameWindowMsgDialog.visible = true
                return
            }
            gameHall.updatePlayerInfo(-1, me["account"])
            playerInfoRec.updatePlayerInfo(-1, me["account"])
            playerInfoRec.updatePlayerInfo(1, other["account"])
            gameEnd(root.seatID===1?2:1, 1)
        }
    }
    SaveGameDialog {
        id: saveGameDialog
        onSave: {
            saveGame(name)
        }
    }

    Item {
        id:leftItem
        height: timeShowRow.height + chessboard.height + buttonRow.height + 20
        width: chessboard.width+10
        Row {
            id: timeShowRow
            spacing: 100
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            TimerRect {
                id: player1Timer
                username: {
                    var player = null
                    if (seatID === 1) player = player1;
                    else if(seatID === 2) player = player2
                    if (player === null) return ""
                    return player["nickname"];
                }
                gameTimeMin: 10
                gameTimeSec: 0
            }
            TimerRect {
                id: player2Timer
                username: {
                    var player = null
                    if (seatID === 1) player = player2;
                    else if(seatID === 2) player = player1
                    if (player === null) return ""
                    return player["nickname"];
                }
                gameTimeMin: 10
                gameTimeSec: 0
            }
        }
        ChessBoard {
            id: chessboard
            anchors.top: timeShowRow.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            inYourTurn: false

            onClicked: {
                inYourTurn = false
                player1Timer.timerStop()
                if (gameType === 1) {
                    var strategy = Code.getComputerStrategy(chessboard.chessBoard, line, column)
                    chessboard.player2PutAPiece(strategy.line, strategy.column)
                    inYourTurn = true
                    player1Timer.timerStart()
                } else if(gameType === 2) {
                    player1Timer.timerStop()
                    var ret = GameOperatorRPC.putChess(root.player1["account"], root.player2["account"]
                                             , deskID, seatID, line, column)
                    if(ret["failType"] !== 0) {
                        switch(ret["failType"]) {
                        case -1:
                            gameWindowMsgDialog.text = "网络出现错误, 详细：" + ret["errInfo"]
                            break;
                        case -2:
                            gameWindowMsgDialog.text = "服务器出现错误, 详细：" + ret["errInfo"]
                            break;
                        case -3:
                            gameWindowMsgDialog.text = "该位置已有棋子"
                            break;
                        }
                        gameWindowMsgDialog.visible = true
                        return
                    }
                    takeBackBtn.canTakeBack = true
                    // if win
                    if(ret["result"] > 0) {
                        gameEnd(seatID, ret["result"])
                        return
                    }
                    player2Timer.timerStart()
                }
            }
        }
        Row {
            id: buttonRow
            anchors.top: chessboard.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 50
            FlatButton {
                id: lastStep
                text: "上一步"
                visible: false
                type: root.step>-1?FlatGlobal.typePrimary:FlatGlobal.typeDisabled
                onClicked: {
                    if (root.step>-1) {
                        var pos = root.gameProcess[root.step]
                        chessboard.takeBack(pos.Row, pos.Column)
                        root.step--

                        var lastPos
                        if(root.step > 0)
                            lastPos = root.gameProcess[root.step]
                        else {
                            lastPos = {"Row":-1, "Column":-1}
                        }


                        chessboard.setLastPos(lastPos.Row, lastPos.Column)
                    }
                }
            }
            FlatButton {
                id: nextStep
                text: "下一步"
                visible: false
                type: root.step+1<gameProcess.length?FlatGlobal.typePrimary:FlatGlobal.typeDisabled
                onClicked: {
                    if(step+1 < gameProcess.length) {
                        var pos = root.gameProcess[root.step+1]
                        chessboard.player2PutAPiece(pos.Row, pos.Column)
                        root.step++
                    }
                }
            }
            FlatButton {
                id: getReadyBtn
                text: "准备"
                property bool clickable: true
                function disable() {
                    type = FlatGlobal.typeDisabled
                    clickable = false
                }
                function reset() {
                    type = FlatGlobal.typePrimary
                    text = "准备"
                    clickable = true
                }
                onClicked: {
                    if(!clickable)
                        return
                    setReady()
                }
            }
            FlatButton {
                id: takeBackBtn
                text: "悔棋"
                type: canTakeBack?FlatGlobal.typePrimary:FlatGlobal.typeDisabled
                // can take back
                property bool canTakeBack: false
                onClicked: {
                    if(!canTakeBack) {
                        return
                    }
                    takeBackMsgDialog.open()
                }
            }
            FlatButton {
                id: wantDrawBtn
                text: "和棋"
                onClicked: {
                    requestDraw()
                }
            }
            FlatButton {
                id: giveUpBtn
                text: "认输"
                onClicked: {
                    if (isReady1 && isReady2) {
                        reqLoseMessageDialog.open()
                    }
                }
            }
            FlatButton {
                id: saveGameBtn
                text: "保存"
                type: isReady1&&isReady2?FlatGlobal.typeDisabled:FlatGlobal.typePrimary
                onClicked: {
                    if(isReady1&&isReady2) {
                        return
                    }
                    saveGameDialog.visible = true
                }
            }
            FlatButton {
                id: quitBtn
                text: "退出"
                onClicked: {
                    if(gameType === 1) {
                        gotoMainWindow()
                    } else if(gameType === 2){
                        gotoGameHall()
                    } else {
                        showGameHall()
                    }
                }
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
        DetailPlayerInfo {
            id: playerInfoRec
            width: 250
            height: 180
            anchors.top: parent.top
            anchors.left: parent.left
        }
        Players {
            id: players
            width: 250
            height: 180
            anchors.top: playerInfoRec.bottom
            anchors.left: playerInfoRec.left
            anchors.topMargin: 5
            onClickPlayer: {
                playerInfoRec.display(account)
            }
        }
        ChatRect {
            id: chatRect
            me: me["nickname"]
            opponent: other["nickname"]
            width: 250
            height: root.height - 480
            anchors.top: players.bottom
            anchors.left: players.left
            anchors.topMargin: 5
            globalX: root.x
            globalY: root.y
        }
    }
}
