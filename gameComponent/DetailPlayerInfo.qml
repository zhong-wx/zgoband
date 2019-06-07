import QtQuick 2.0

Item {
    property var playerInfo: null
    property var whichToDisplay: ""
    property string account1: ""
    property string nickname1
    property int score1
    property int winRound1
    property int loseRound1
    property int drawRound1
    property int escapeRound1
    property string account2: ""
    property string nickname2
    property int score2
    property int winRound2
    property int loseRound2
    property int drawRound2
    property int escapeRound2

    property string account: {
        if(whichToDisplay===account1)
            return account1
        else if(whichToDisplay===account2)
            return account2
        return ""
    }
    property string nickname: {
        if(whichToDisplay===account1)
            return nickname1
        else if(whichToDisplay===account2)
            return nickname2
        return ""
    }
    property int score: {
        if(whichToDisplay===account1)
            return score1
        else if(whichToDisplay===account2)
            return score2
        return ""
    }
    property int winRound: {
        if(whichToDisplay===account1)
            return winRound1
        else if(whichToDisplay===account2)
            return winRound2
        return ""
    }
    property int loseRound: {
        if(whichToDisplay===account1)
            return loseRound1
        else if(whichToDisplay===account2)
            return loseRound2
        return ""
    }
    property int drawRound: {
        if(whichToDisplay===account1)
            return drawRound1
        else if(whichToDisplay===account2)
            return drawRound2
        return ""
    }
    property int escapeRound: {
        if(whichToDisplay===account1)
            return escapeRound1
        else if(whichToDisplay===account2)
            return escapeRound2
        return ""
    }

    function addPlayerInfo(account, name, score, winRound, loseRound, drawRound, escapeRound){
        if (account1 === "") {
            account1 = account
            nickname1 = name
            score1 = score
            winRound1 = winRound
            loseRound1 = loseRound
            drawRound1 = drawRound
            escapeRound1 = escapeRound
            return
        }
        if (account2 === "") {
            account2 = account
            nickname2 = name
            score2 = score
            winRound2 = winRound
            loseRound2 = loseRound
            drawRound2 = drawRound
            escapeRound2 = escapeRound
            return
        }
    }

    function removePlayerInfo(account) {
        if(account === account1) {
            account1 = ""
            nickname1 = ""
            score1 = ""
            winRound1 = ""
            loseRound1 = ""
            drawRound1 = ""
            escapeRound1 = ""
            return
        }
        if(account === account2) {
            account2 = ""
            nickname2 = ""
            score2 = ""
            winRound2 = ""
            loseRound2 = ""
            drawRound2 = ""
            escapeRound2 = ""
            return
        }
    }

    function display(account) {
        whichToDisplay = account
    }

    function reset() {
        account1 = ""
        nickname1 = ""
        score1 = ""
        winRound1 = ""
        loseRound1 = ""
        drawRound1 = ""
        escapeRound1 = ""

        account2 = ""
        nickname2 = ""
        score2 = ""
        winRound2 = ""
        loseRound2 = ""
        drawRound2 = ""
        escapeRound2 = ""
    }

    function updatePlayerInfo(result, account) {
        if(account === account1) {
            if (result === 0) {
                //和棋
                drawRound1++
            } else if(result === 1) {
                //赢
                winRound1++
                score1++
            } else if(result === -1) {
                //输
                loseRound1++
                score1--
            } else if(result === -2) {
                //逃跑
                score1 -= 5
                loseRound1--
                escapeRound1++

                //console.log(JSON.stringify(playerInfo))
                //playerInfo[whichToDisplay][5] = playerInfo[whichToDisplay][5]+1
                //playerInfo[whichToDisplay][1] = playerInfo[whichToDisplay][1] - 5
                //var t = new Object
                //var keys = Object.keys(playerInfo)
                //console.log("keys:",JSON.stringify(keys))
                //for(var i=0; i<keys.length; i++) {
                //    console.log("key:",keys[i])
                //    console.log("playerInfo:",JSON.stringify(playerInfo[keys[i]]))
                //    console.log("typeof:", typeof(playerInfo[keys[i]]))
                //    t[keys[i]] = playerInfo[keys[i]]
                //}
                //playerInfo = t
                //console.log(JSON.stringify(playerInfo))

            }
        } else if(account === account2) {
            if (result === 0) {
                //和棋
                drawRound2++
            } else if(result === 1) {
                //赢
                winRound2++
                score2++
            } else if(result === -1) {
                //输
                loseRound2++
                score2--
            } else if(result === -2) {
                //逃跑
                score2 -= 5
                loseRound2++
                escapeRound2++
            }
        }

        //if (result === 0) {
        //    //和棋
        //    playerInfo[account][4]++
        //} else if(result === 1) {
        //    //赢
        //    playerInfo[account][1]++
        //    playerInfo[account][2]++
        //} else if(result === -1) {
        //    //输
        //    playerInfo[account][1]--
        //    playerInfo[account][3]++
        //} else if(result === -2) {
        //    //逃跑
        //    console.log(JSON.stringify(playerInfo))
        //    playerInfo[whichToDisplay][5] = playerInfo[whichToDisplay][5]+1
        //    playerInfo[whichToDisplay][1] = playerInfo[whichToDisplay][1] - 5
        //    var t = new Object
        //    var keys = Object.keys(playerInfo)
        //    console.log("keys:",JSON.stringify(keys))
        //    for(var i=0; i<keys.length; i++) {
        //        console.log("key:",keys[i])
        //        console.log("playerInfo:",JSON.stringify(playerInfo[keys[i]]))
        //        console.log("typeof:", typeof(playerInfo[keys[i]]))
        //        t[keys[i]] = playerInfo[keys[i]]
        //    }
        //    playerInfo = t
        //    console.log(JSON.stringify(playerInfo))
        //}

    }


    Column {
        spacing: 15
        Text{
            text: {whichToDisplay==="" ? "账号：" : "账号：" + account}
        }
        Text{
            text: {whichToDisplay==="" ? "昵称：" : "昵称：" + nickname}
        }
        Text{
            text: {whichToDisplay==="" ? "积分：" : "积分：" + score}
        }
        Text{
            text: {whichToDisplay==="" ? "赢回合数：" : "赢回合数：" + winRound}
        }
        Text{
            text: {whichToDisplay==="" ? "输回合数：" : "输回合数：" + loseRound}
        }
        Text{
            text: {whichToDisplay==="" ? "和棋回合数：" : "和棋回合数：" + drawRound}
        }
        Text{
            text: {whichToDisplay==="" ? "逃跑回合数：" : "逃跑回合数：" + escapeRound}
        }
    }
}
