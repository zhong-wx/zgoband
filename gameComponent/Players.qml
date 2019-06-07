import QtQuick 2.11
Item {
    id: playersItem

    signal clickPlayer(var name, var account)

    function addPlayerInfo(name, account, isReady) {

        playerData.append({"name":name, "account":account, "isReady":isReady?1:0})
    }

    function setReady(account, ready) {
        var count = playerData.count
        for(var i=1; i<count; i++) {
            if(playerData.get(i).account === account) {
                playerData.setProperty(i, "isReady", ready?1:0)
                return
            }
        }
    }

    function setAllNotReady() {
        var count = playerData.count
        for(var i=1; i<count; i++) {
            playerData.setProperty(i, "isReady", 0)
        }
    }

    function clear() {
        if(playerData.count > 1)
            playerData.remove(1, playerData.count-1)
    }

    function removePlayer(account) {
        var count = playerData.count
        for(var i=1; i<count; i++) {
            if(playerData.get(i).account === account) {
                playerData.remove(i)
                return
            }
        }
    }


    ListModel {
        id: playerData
        ListElement {
            name: "昵称"
            account: "账号"
            isReady: -1
        }
    }

    ListView {
        anchors.fill: parent
        flickDeceleration: Flickable.AutoFlickIfNeeded
        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        model: playerData
        Component.onCompleted: {
            currentIndex = 1
        }
        delegate: MouseArea {
            height: 25
            width: parent.width
            onClicked: {
               ListView.view.currentIndex = index
               if(index != 0) {
                   clickPlayer(name, account)
               }
            }
            Row {
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    height: 25
                    width: playersItem.width / 3
                    horizontalAlignment: Text.AlignVCenter
                    text: name
                }
                Text {
                    height: 25
                    width: playersItem.width / 3
                    horizontalAlignment: Text.AlignVCenter
                    text: account
                }
                Text {
                    height: 25
                    width: playersItem.width / 3
                    horizontalAlignment: Text.AlignVCenter
                    text: {
                        switch(isReady) {
                        case -1:return "状态"
                        case 0:return "未准备"
                        case 1:return "已准备"
                        }
                    }
                }
            }
        }
    }
}
