#ifndef GAMEHALL_H
#define GAMEHALL_H
#include <QObject>
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>
#include <thrift/protocol/TMultiplexedProtocol.h>
#include <iostream>
#include <vector>
#include <QJsonObject>

#include "gen-cpp/GameHall.h"

using namespace apache::thrift;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;
using namespace std;

using namespace zgobandRPC;

class GameHall : public QObject
{
    Q_OBJECT

    stdcxx::shared_ptr<GameHallClient> client;
    stdcxx::shared_ptr<TTransport> transport;
public:
    explicit GameHall(QObject *parent = nullptr);
    Q_INVOKABLE QJsonObject getDeskList();
    Q_INVOKABLE QJsonObject sitDown(const QString &account, int deskID, int seatID);
    Q_INVOKABLE QJsonObject leaveSeat(const QString &account, int deskID, int seatID);
    Q_INVOKABLE QJsonObject setReady(const QString &account, int deskID, int seatID, bool isReady);
    Q_INVOKABLE QJsonObject getSeatInfo(int deskID, int seatID);
    Q_INVOKABLE QJsonObject autoMatch(const QString &account);
    Q_INVOKABLE QJsonObject getSavedGame(int id);
    Q_INVOKABLE QJsonObject getSavedGameList(const QString &account);
signals:

public slots:
};

#endif // GAMEHALL_H
