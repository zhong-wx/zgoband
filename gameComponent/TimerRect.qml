import QtQuick 2.0

Rectangle {
    color: "black"
    property string username: "username"
    property int gameTimeMin
    property int gameTimeSec
    property int min
    property int sec

    signal timeout

    width: 125
    height: 95

    Component.onCompleted: {
        min = gameTimeMin
        sec = gameTimeSec
    }

    function timerStart() {
        countDownTimer.start()
    }

    function timerStop() {
        countDownTimer.stop()
    }

    function reset() {
        min = gameTimeMin
        sec = gameTimeSec
        timerStop()
    }

    Timer {
        id: countDownTimer
        interval: 1000
        repeat: true
        onTriggered: {
            if(sec <= 1 && min < 0) {
                stop()
                timeout()
            }
            sec--
            if(sec < 0) {
                sec = 59
                min--
            }
        }
    }
    Column {
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 3
        spacing: 5

        Text {
            id: usernameText
            font.bold: true
            color: "white"
            text: username
        }
        Text {
            id: gameTimeText
            font.bold: true
            color: "white"
            text: "局时：\t" + gameTimeMin + ":" + gameTimeSec
        }
        Text {
            id: countDownText
            font.bold: true
            color: "white"
            text: "倒计时：\t" + min + ":" + sec
        }
    }


}

