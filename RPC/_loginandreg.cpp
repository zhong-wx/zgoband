#include "_loginandreg.h"
#include "gen-cpp/zgobandServerThrift_types.h"
#include <QDebug>
#include <QTime>
#include <QObject>
using namespace zgobandRPC;
extern QObject *rootObject;
LoginAndReg::LoginAndReg(QObject *parent) : QObject(parent)
{
      stdcxx::shared_ptr<TTransport> socket(new TSocket("localhost", 9091));
      transport = stdcxx::make_shared<TBufferedTransport>(socket);
      stdcxx::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
      stdcxx::shared_ptr<TProtocol> protocol1(new TMultiplexedProtocol(protocol, "LoginAndReg"));

      client = stdcxx::make_shared<LoginAndRegClient>(protocol1);
}

QJsonObject LoginAndReg::login(const QString &account, const QString &password) {
    PlayerInfo retPlayerInfo;
    QString errInfo;
    int loginResult = 0;

    try {
        transport->open();
        client->login(retPlayerInfo, account.toStdString(), password.toStdString());
        transport->close();
    } catch(TTransportException e) {
        errInfo = e.what();
        loginResult = -1;
    } catch(TApplicationException e) {
        errInfo = e.what();
        loginResult = -2;
    }

    if(loginResult == 0) {
        recvServer.setAccount(account.toStdString());
        recvServer.start();
    }

    QJsonObject jsonObj;
    jsonObj["result"] = loginResult;
    if(loginResult != 0) {
        jsonObj["errInfo"] = errInfo;
    } else {
        QJsonObject playerInfo;
        playerInfo["nickname"] = QString(retPlayerInfo.nickname.c_str());
        playerInfo["score"] = retPlayerInfo.core;
        playerInfo["winRound"] = retPlayerInfo.winRound;
        playerInfo["loseRound"] = retPlayerInfo.loseRound;
        playerInfo["drawRound"] = retPlayerInfo.drawRound;
        playerInfo["escapeRound"] = retPlayerInfo.escapeRound;
        jsonObj["playerInfo"] = playerInfo;
    }
    return jsonObj;
}

bool LoginAndReg::reg(const QString &account, const QString &password, const QString &nickname) {
    transport->open();
    bool ret = client->reg(account.toStdString(), password.toStdString(), nickname.toStdString());
    transport->close();
    return ret;
}
