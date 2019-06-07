#ifndef _GAMEOPERATOR_H
#define _GAMEOPERATOR_H
#include <QObject>
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>
#include <thrift/protocol/TMultiplexedProtocol.h>
#include <iostream>
#include "../gen-cpp/GameOperator.h"
#include <QJsonObject>

using namespace apache::thrift;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;
using namespace std;

using namespace zgobandRPC;

class GameOperator: public QObject
{
    Q_OBJECT
    stdcxx::shared_ptr<GameOperatorClient> client;
    stdcxx::shared_ptr<TTransport> transport;
public:
    GameOperator();
    Q_INVOKABLE QJsonObject putChess(const QString& player1, const QString& player2, int deskID, int seatID, int row, int column);
    Q_INVOKABLE QJsonObject takeBackReq(const QString& account, const QString &otherSide, int seatID);
    Q_INVOKABLE QJsonObject takeBackResp(const QString &player1, const QString &player2, int seatID, bool resp);
    Q_INVOKABLE QJsonObject reqLose(const QString &player1, const QString &player2, int deskID, int seatID);
};

#endif // _GAMEOPERATOR_H
