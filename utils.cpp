#include "utils.h"

int byteAraryToInt(QByteArray arr,  Endian endian)
{
    if (arr.size() < 4)
        return 0;

    int res = 0;

    // 小端模式
    if (endian == LittileEndian)
    {
        res = arr.at(0) & 0x000000FF;
        res |= (arr.at(1) << 8) & 0x0000FF00;
        res |= (arr.at(2) << 16) & 0x00FF0000;
        res |= (arr.at(3) << 24) & 0xFF000000;
    }

    // 大端模式
    else if (endian == BigEndian)
    {
        res = (arr.at(0) << 24) & 0xFF000000;
        res |= (arr.at(1) << 16) & 0x00FF0000;
        res |= arr.at(2) << 8 & 0x0000FF00;
        res |= arr.at(3) & 0x000000FF;
    }
    return res;
}
