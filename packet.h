#ifndef PACKET_H
#define PACKET_H
#pragma once

struct login
{
    unsigned short bEncrypt : 1; // specify packet header encryption
    unsigned short wSize : 15;
    unsigned char bySequence = 0;
    unsigned char byChecksum;
    unsigned short wOpcode;
    wchar_t awchUserId[32 + 1];
    wchar_t	awchPasswd[128 + 1];
    unsigned long dwCodePage;
    unsigned short wLVersion;
    unsigned short wRVersion;
    unsigned char abyMacAddress[6];
};
struct sSERVER_INFO // 71
{
    char szCharacterServerIP[64 + 1];
    unsigned short wCharacterServerPortForClient;
    unsigned long dwLoad;
};
struct login_res
{
    unsigned short bEncrypt : 1; // specify packet header encryption
    unsigned short wSize : 15;
    unsigned char bySequence = 0;
    unsigned char byChecksum;
    unsigned short wOpcode;
    unsigned short wResultCode;
    wchar_t	awchUserId[16 + 1];
    unsigned char abyAuthKey[16];
    unsigned int accountId;
    unsigned char lastServerFarmId;
    unsigned long dwAllowedFunctionForDeveloper;
    unsigned char byServerInfoCount;
    sSERVER_INFO	aServerInfo[10];
};

#endif // PACKET_H
