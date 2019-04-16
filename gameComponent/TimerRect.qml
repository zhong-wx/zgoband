import QtQuick 2.0

Rectangle {
    color: "black"
    property string username
    property int gameTimeMin
    property int gameTimeSec
    property int min
    property int sec

    signal timeout

    width: 125
    height: 95

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
                sec = 0
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
            text: username
        }
        Text {
            id: gameTimeText
            text: "局时：\t" + gameTimeMin + ":" + gameTimeSec
        }
        Text {
            id: countDownText
            text: "倒计时：\t" + min + ":" + sec
        }
    }

    function timerStart() {
        countDownTimer.start()
    }

}
