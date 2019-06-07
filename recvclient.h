#ifndef RECVSERVER_H
#define RECVSERVER_H
#include <QThread>
#include <QTcpSocket>
#include <QBuffer>
#include <QHostAddress>
#include <QAbstractSocket>
#include <QJsonObject>
#include <QJsonDocument>
#include <exception>

using namespace std;

class BufferError : public exception {
public:
    BufferError() throw() ;
    virtual const char* what()const throw();
};

class JsonBuffer : public QObject {
    Q_OBJECT
private:
    QByteArray buffer;
    uint expectMessageLength;

    void getMessageLength();
public:
    JsonBuffer();
    void append(QByteArray data);
signals:
    void collected(QJsonObject);
};

class RecvServer : public QThread
{
    Q_OBJECT
    QTcpSocket client;
    JsonBuffer buffer;
    std::string account;

    void run() override;

public:
    RecvServer();
    void setAccount(std::string);
    ~RecvServer();

private slots:
    void socketError(QAbstractSocket::SocketError socketError);
    void readData();
    void putJsonObj(QJsonObject jsonObj);
};

#endif // RECVSERVER_H
