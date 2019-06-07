#include "recvclient.h"
#include <iostream>

extern QObject* rootObject;

BufferError::BufferError()throw() {}

const char* BufferError::what()const throw(){
    return "recv length flag == 0";
}

JsonBuffer::JsonBuffer():expectMessageLength(0) {}

void JsonBuffer::append(QByteArray data) {
    int lastBufLength = buffer.length();
    buffer.append(data);
    if(expectMessageLength <= 0) {
        getMessageLength();
    }
    if(data.length() >= expectMessageLength) {
        if(expectMessageLength <= 0) {
            throw BufferError();
        }

        QByteArray message = buffer.left(expectMessageLength);
        qDebug() << message;
        QJsonDocument jd = QJsonDocument::fromJson(message.right(message.length()-4));
        QJsonObject jsonObj = jd.object();

        int wantRightLength = data.length() - (expectMessageLength - lastBufLength);
        buffer = data.right(wantRightLength);
        emit collected(jsonObj);

        // will be reset
        expectMessageLength = 0;
    }
}

void JsonBuffer::getMessageLength() {
    QByteArray lengthData = buffer.left(4);
    const int *pInt = (int*)lengthData.data();
    qDebug() << *pInt;
    expectMessageLength = *pInt;
}

RecvServer::RecvServer(): QThread() {
    QObject::connect(&buffer, &JsonBuffer::collected, this, &RecvServer::putJsonObj);
    client.moveToThread(this);
    buffer.moveToThread(this);
    qRegisterMetaType<QAbstractSocket::SocketError>("SocketError");
}

RecvServer::~RecvServer() {
    qDebug() << "client.close";
    client.close();
    this->exit();
}

void RecvServer::run() {
    QObject::connect(&client, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::error), this, &RecvServer::socketError);
    QObject::connect(&client, &QTcpSocket::readyRead, this, &RecvServer::readData);
    client.connectToHost(QHostAddress("127.0.0.1"), 9092);
    bool isConnected = client.waitForConnected();
    if(!isConnected) {
        socketError(client.error());
        return;
    }
    int ret = client.write(account.c_str(), strlen(account.c_str()));
    if(ret < 0) {
        qDebug() << "ret < 0";
        socketError(client.error());
    }
    qDebug() << "after send:" << ret;
    QThread::exec();
}

void RecvServer::readData() {
    QByteArray data = client.readAll();
    qDebug() << "readData is called";
    qDebug() << data;
    buffer.append(data);
}

void RecvServer::socketError(QAbstractSocket::SocketError socketError) {
    QString msg = client.errorString();
    QMetaObject::invokeMethod(rootObject, "netWorkError", Q_ARG(QVariant, msg));
    //this->exit(-1);
}

void RecvServer::putJsonObj(QJsonObject jsonObj) {
    QMetaObject::invokeMethod(rootObject, "recvJsonObj", Q_ARG(QVariant, jsonObj));
}

void RecvServer::setAccount(std::string account) {
    this->account = account;
}
