#include "_gameoperator.h"

GameOperator::GameOperator()
{
    stdcxx::shared_ptr<TTransport> socket(new TSocket("localhost", 9091));
    transport = stdcxx::make_shared<TBufferedTransport>(socket);
    stdcxx::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
    stdcxx::shared_ptr<TProtocol> protocol1(new TMultiplexedProtocol(protocol, "GameOperator"));

    client = stdcxx::make_shared<GameOperatorClient>(protocol1);
}

QJsonObject GameOperator::putChess(const QString& player1, const QString& player2, int deskID, int seatID, int row, int column) {
    int ret;
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        ret = client->putChess(player1.toStdString(), player2.toStdString(), deskID, int8_t(seatID), int8_t(row), int8_t(column));
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(InvalidOperation e) {
        failType = -3;
        errInfo = e.what();
    } catch(TApplicationException e ) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["result"] = ret;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameOperator::takeBackReq(const QString& account, const QString &otherSide, int seatID) {
    bool ret;
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        ret = client->takeBackReq(account.toStdString(), otherSide.toStdString(), int8_t(seatID));
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e ) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["result"] = ret;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameOperator::takeBackResp(const QString &player1, const QString &player2, int seatID, bool resp) {
    bool ret;
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        ret = client->takeBackRespond(player1.toStdString(), player2.toStdString(), int8_t(seatID), resp);
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e ) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["result"] = ret;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameOperator::reqLose(const QString &player1, const QString &player2, int deskID, int seatID) {
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        client->loseReq(player1.toStdString(), player2.toStdString(), deskID, int8_t(seatID));
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e ) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameOperator::drawReq(const QString &me, const QString &otherSide, int seatID) {
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        client->drawReq(me.toStdString(), otherSide.toStdString(), int8_t(seatID));
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e ) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameOperator::drawResponse(const QString &player1, const QString &player2, int deskID, int seatID, bool resp) {
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        client->drawResponse(player1.toStdString(), player2.toStdString(), deskID, int8_t(seatID), resp);
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e ) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    return jo;
}

QJsonObject GameOperator::sendChatText(const QString &toAccount, const QString &account, const QString &text) {
    int failType = 0;
    QString errInfo = "";
    try {
        transport->open();
        client->sendChatText(toAccount.toStdString(), account.toStdString(), text.toStdString());
        transport->close();
    } catch(TTransportException e) {
        failType = -1;
        errInfo = e.what();
    } catch(TApplicationException e ) {
        failType = -2;
        errInfo = e.what();
    }

    QJsonObject jo;
    jo["failType"] = failType;
    jo["errInfo"] = errInfo;
    return jo;
}
