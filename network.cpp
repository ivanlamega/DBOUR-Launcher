#include "network.h"
#include "packet.h"
#include "logged.h"
#include "httpdownload.h"

char LAUNCHER_VERSION[8] = "1.1.0.0";

Network::Network(QObject *parent) : QObject(parent),
    _host{"217.146.81.120"},
    _port{50200},
    _socket{nullptr},
    _packetcount{0},
    _logged{nullptr},
    _connected{false}

{    
    this->connect();
}

void Network::checkForLauncherUpdate()
{

    downloader = new HttpDownload(this);
    QObject::connect(downloader, SIGNAL(fileDownloaded(QString)),
                         this, SLOT(onFileDownloaded(QString)));
    downloader->startDownloadFile(QString(DOWNLOAD_URL) + "launcher.txt");

/*
    if (file.fileName().contains("txt", Qt::CaseSensitivity::CaseInsensitive))
    {
        QFile file(filename);
        if(!file.open(QIODevice::ReadOnly))
        {
            QMessageBox::information(0, "error", file.errorString() + ": " + filename);
        }
        else
        {
            Version ver(file.readAll().toStdString());
            Version cur(LAUNCHER_VERSION);
            if (cur < ver)
            {
                if (QMessageBox::Yes == QMessageBox(QMessageBox::Information, "New update available", "A new update is available, do you want to download it now ?", QMessageBox::Yes|QMessageBox::No).exec())
                {
                    _autoupdater = new AutoUpdate(this);
                    hide();
                    _autoupdater->show();
                }
*/
}

void Network::onFileDownloaded(QString filename)
{
    QFile file(filename);

    if (file.fileName().contains("txt", Qt::CaseSensitivity::CaseInsensitive))
    {
        QFile file(filename);
        qDebug("launcher.txt Downloaded");
        if(!file.open(QIODevice::ReadOnly))
        {
            qDebug("Device is ReadOnly");
            //QMessageBox::information(0, "error", file.errorString() + ": " + filename);
        }
        else
        {
            Version ver(file.readAll().toStdString());
            qDebug("File Downloaded Checking Version String");
            Version cur(LAUNCHER_VERSION);
            if (cur < ver)
            {
                qDebug("Launcher Not up to date. Starting Update");
                startUpdate();
            }
            else
                qDebug("Launcher up to date.");

        }
    }
}
void Network::setValueChanged(bool b)
{
    _newUpdate = b;
    if(b == true)
        startUpdate();
}
void Network::startUpdate()
{
    qDebug("AutoUpdate Started");
        _autoupdater = new AutoUpdate(this);
}
void Network::connect()
{
    _socket = new QTcpSocket( this );
    _socket->connectToHost(_host, _port);
    checkForLauncherUpdate();
    if(!_socket->waitForConnected())
    {
        _connected = false;
        //NotifyMessageBox::showMessage("Connection to authentification server failed.", this);
    }
    else
    {
        _connected = true;
        //NotifyMessageBox::showMessage("Connection to authentification server sucess.", this);
        //_connectionThread->stopRunning();
    }

}

unsigned short Network::sendAuth(QString uname, QString pwd)
{
    if (!_connected)
        return 6969;

    if (uname == "" || pwd == "")
        return 420;

    std::string mac = getMacAddress().toStdString();
    std::wstring userName = uname.toStdWString();
    std::wstring passWord = pwd.toStdWString();

    QCryptographicHash hash(QCryptographicHash::Algorithm::Sha256);
    QString saltedPass =  uname.toLower() + pwd;

    QByteArray passData = saltedPass.toUtf8();
    hash.addData(passData);

    QString stdpwd = hash.result().toHex();
    passWord = stdpwd.toStdWString();


    // -- Login
    login* req = new login();
    QByteArray data;

    req->wOpcode = 100;
    req->wSize = sizeof(login) - 4;
    req->bySequence = _packetcount;
    req->wLVersion = 0;
    req->wRVersion = 70;
    req->dwCodePage = 421;
    memcpy(req->abyMacAddress, mac.c_str(), 6);
    memcpy(req->awchUserId, userName.c_str(), 32 + 1);
    memcpy(req->awchPasswd, passWord.c_str(), 128 + 1);

    // -- Send auth
    if (_socket->write((char*)req, sizeof(login)) == -1)
    {
        //Send a signal for Launcher unable to send packet.
    }
    _packetcount++;
    _socket->waitForReadyRead(1000);
    // -- Receive auth result
    login_res *res = new login_res;
    if (_socket->read((char*)res, sizeof(login_res)) == -1)
    {
        //Send a signal for Server Unable to Send Packet
        delete res;
        res = nullptr;
        return 0;
    }
    else if (res->wResultCode == 113 || res->wResultCode == 107 || res->wResultCode == 108 || res->wResultCode == 111)
    {
        //Set result codes for each one of these, Send a signal.
        ushort rCode = res->wResultCode;
        delete res;
        res = nullptr;
        return rCode;
    }
    else if (res->wResultCode == 100)
    {
        //_connectionThread->stopRunning();
        _socket->close();
        delete _socket;
        _socket = nullptr;
        _connected = false;
        delete req;
        req = nullptr;

        QString decodedCredential = uname + ":" + stdpwd;
        QString encoded = decodedCredential.toUtf8().toBase64();
        _logged->SetDataPacket(encoded);

        return 100;
    }

    return res->wResultCode;
}

QString Network::getMacAddress()
{
    foreach(QNetworkInterface netInterface, QNetworkInterface::allInterfaces())
    {
        // Return only the first non-loopback MAC Address
        if (!(netInterface.flags() & QNetworkInterface::IsLoopBack))
            return netInterface.hardwareAddress();
    }
    return QString();
}
