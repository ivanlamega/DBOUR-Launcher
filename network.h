#ifndef NETWORK_H
#define NETWORK_H

#include <QObject>
#include <QString>
#include <QTcpSocket>
#include <QDataStream>
#include <QTimer>
#include <QThread>
#include <QNetworkInterface>
#include "logged.h"
#include <QCryptographicHash>
#include "autoupdate.h"
class Logged;
class Network : public QObject
{
    Q_OBJECT
public:
    explicit Network(QObject *parent = nullptr);
    Q_INVOKABLE Logged* getLoggedPtr() const { return _logged; }
    Q_INVOKABLE void setLoggedPtr(Logged* log) {_logged = log;}
signals:
    bool ValueChanged(bool b);
    void changed(QString);
public slots:
    void connect();
    unsigned short sendAuth(QString uname, QString pwd);
    QString getMacAddress();
    void checkForLauncherUpdate();
    void onFileDownloaded(QString filename);
    void setValueChanged(bool b);
    void startUpdate();
private:
    QString _host;
    int _port;
    QTcpSocket *_socket;
    unsigned char _packetcount;
    Logged *_logged;
    bool _connected;
    bool _newUpdate;
    HttpDownload *downloader;
    AutoUpdate *_autoupdater;

};

#endif // NETWORK_H
