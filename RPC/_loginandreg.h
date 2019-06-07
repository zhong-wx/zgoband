#ifndef LOGINANDREG_H
#define LOGINANDREG_H

#include <QObject>
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>
#include <thrift/protocol/TMultiplexedProtocol.h>
#include <iostream>

#include "gen-cpp/LoginAndReg.h"
#include "recvclient.h"

using namespace apache::thrift;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;
using namespace std;

using namespace zgobandRPC;

class LoginAndReg : public QObject
{
    Q_OBJECT

    stdcxx::shared_ptr<LoginAndRegClient> client;
    stdcxx::shared_ptr<TTransport> transport;
    RecvServer recvServer;
public:
    explicit LoginAndReg(QObject *parent = nullptr);

    Q_INVOKABLE QJsonObject login(const QString &account, const QString &password);
    Q_INVOKABLE bool reg(const QString &account, const QString &password, const QString &nickname);
signals:

public slots:
};

#endif // LOGINANDREG_H
