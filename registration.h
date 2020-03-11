#ifndef REGISTRATION_H
#define REGISTRATION_H


#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QUrlQuery>
#include <QDesktopServices>
class Registration : public QObject
{
    Q_OBJECT
public:
    explicit Registration(QObject *parent = nullptr);
    ~Registration();
signals:

public slots:
    void Register(QString username, QString password, QString email);
    unsigned short replyfinished(QNetworkReply *reply);

private:
    QUrl url;
    QNetworkAccessManager *manager;
    QNetworkReply *reply;
    QFile *file;
    bool httpRequestAborted;
    QString labelValue;

};

#endif // REGISTRATION_H
