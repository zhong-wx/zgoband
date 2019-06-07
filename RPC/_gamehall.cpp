#include "_gamehall.h"
#include <QJsonArray>
#include <QJsonObject>
GameHall::GameHall(QObject *parent) : QObject(parent)
{
    stdcxx::shared_ptr<TTransport> socket(new TSocket("localhost", 9091));
    transport = stdcxx::make_shared<TBufferedTransport>(socket);
    stdcxx::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
    stdcxx::shared_ptr<TProtocol> protocol1(new TMultiplexedProtocol(protocol, "GameHall"));

    client = stdcxx::make_shared<GameHallClient>(protocol1);
}

QJsonObject GameHall::getDeskList() {
    vector<Desk> desks;
    int failType = 0;
    QString errInfo = "";
    try{
        transport->open();
        client->getDeskList(desks);
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e) {
        failType = -2;
        errInfo = e.what();
    }

    sort(desks.begin(), desks.end(), [](const Desk& desk1, const Desk& desk2){
            if(desk1.deskID > desk2.deskID) return false;
            return true;
        }
    );

    QJsonObject jsonObj;
    jsonObj["failType"] = failType;
    jsonObj["errInfo"] = errInfo;
    QJsonArray jsonArray;
    for(Desk &desk : desks) {
        QJsonObject jsonObj;
        jsonObj["deskID"] = desk.deskID;
        jsonObj["player1"] = desk.player1.c_str();
        jsonObj["player2"] = desk.player2.c_str();
        jsonObj["ready1"] = desk.ready1;
        jsonObj["ready2"] = desk.ready2;
        jsonArray.append(jsonObj);
    }
    jsonObj["deskList"] = jsonArray;
    return jsonObj;
}

QJsonObject GameHall::sitDown(const QString &account, int deskID, int seatID) {
    int failType = 0;
    QString errInfo = "";
    bool success = false;
    try{
        transport->open();
        success = client->sitDown(account.toStdString(), deskID, seatID);
        transport->close();
    } catch(TTransportException e) {
        failType = -2;
        errInfo = e.what();
    } catch (TApplicationException e) {
        failType = -1;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["success"] = success;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameHall::leaveSeat(const QString &account, int deskID, int seatID) {
    int failType = 0;
    QString errInfo = "";
    int ret = -1;
    try{
        transport->open();
        ret = client->leaveSeat(account.toStdString(), deskID, seatID);
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch (TApplicationException e) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    jo["ret"] = ret;
    return jo;
}

QJsonObject GameHall::setReady(const QString &account, int deskID, int seatID, bool isReady) {
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        client->setReady(account.toStdString(), deskID, seatID, isReady);
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameHall::getSeatInfo(int deskID, int seatID) {
    int failType = 0;
    QString errInfo = "";
    PlayerInfo playerInfo;
    try {
        transport->open();
        client->getSeatInfo(playerInfo, deskID, seatID);
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    if(failType == 0) {
        QJsonObject playerInfoJson;
        playerInfoJson["nickname"] = playerInfo.nickname.c_str();
        playerInfoJson["score"] = playerInfo.core;
        playerInfoJson["winRound"] = playerInfo.winRound;
        playerInfoJson["loseRound"] = playerInfo.loseRound;
        playerInfoJson["escapeRound"] = playerInfo.escapeRound;
        playerInfoJson["drawRound"] = playerInfo.drawRound;
        playerInfoJson["account"] = playerInfo.account.c_str();
        playerInfoJson["isReady"] = playerInfo.isReady;
        jo["playerInfo"] = playerInfoJson;
    }
    return jo;
}