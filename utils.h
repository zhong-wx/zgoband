#ifndef UTILS_H
#define UTILS_H
#include <QByteArray>

enum Endian
{
    LittileEndian,
    BigEndian
};

int byteAraryToInt(QByteArray arr,  Endian endian = BigEndian);

#endif // UTILS_H
