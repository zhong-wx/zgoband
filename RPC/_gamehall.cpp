#include "_gamehall.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
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

QJsonObject GameHall::autoMatch(const QString &account) {
    int failType = 0;
    QString errInfo = "";
    map<string, int> ret;
    try {
        transport->open();
        client->autoMatch(ret, account.toStdString());
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
    jo["isFound"] = ret["isFound"];
    jo["deskID"] = ret["deskID"];
    jo["seatID"] = ret["seatID"];
    return jo;
}

QJsonObject JsonStrToJson(const string &jsonStr) {
    QJsonDocument jd = QJsonDocument::fromJson(QString(jsonStr.c_str()).toUtf8().data());
    if(jd.isNull()) {
        qDebug() << "parse string fail";
        throw -1;
    }
    return jd.object();
}

QJsonObject GameHall::getSavedGame(int id) {
    int failType = 0;
    QString errInfo = "";
    string ret;
    try {
        transport->open();
        client->getSavedGame(ret, id);
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
    try {
        jo["record"] =  JsonStrToJson(ret);
    } catch(int e) {
        if(failType != 0) {
            jo["failType"] = -3;
            jo["errInfo"] = "解析json字符串出错";
        }
    }
    return jo;
}

QJsonObject GameHall::getSavedGameList(const QString &account) {
    int failType = 0;
    QString errInfo = "";
    vector<string> savedGameList;
    try {
        transport->open();
        client->getSavedGameList(savedGameList, account.toStdString());
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
    QJsonArray ja;
    for(const string &savedGameStr : savedGameList) {
        try {
            qDebug() << "savedGameStr: " << QString::fromStdString(savedGameStr);
            ja.append(JsonStrToJson(savedGameStr));
        } catch(int e) {
            if(failType != 0) {
                jo["failType"] = -3;
                jo["errInfo"] = "解析json字符串出错";
            }
            break;
        }
    }
    jo["savedGameList"] = ja;
    return jo;
}


QJsonObject GameHall::delSavedGame(int id) {
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        client->delSavedGame(id);
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
