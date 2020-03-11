#include "registration.h"

Registration::Registration(QObject *parent) :
    QObject(parent)
{
    manager = new QNetworkAccessManager(this);

}
Registration::~Registration()
{
    if (manager)
        delete manager;
}


void Registration::Register(QString username, QString password, QString email)
{
    QUrl url("http://104.216.111.66/register.php?usr="+username+"&pwd="+password+"&email="+email);
    //QDesktopServices::openUrl(url);


    //QNetworkRequest request(url);

    //request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    //QUrlQuery params;
    //params.addQueryItem("usr", username);
    //params.addQueryItem("pwd", password);
    //params.addQueryItem("email", email);

    //connect(manager, SIGNAL(finished(QNetworkReply *)), this, SLOT(replyFinished(QNetworkReply *)));

//    manager->post(request, params.query().toUtf8());
}
unsigned short Registration::replyfinished(QNetworkReply* reply)
{
    int i;
    QByteArray bytes = reply->readAll(); // bytes
    qDebug("reply received");

    for(i=0;i<=bytes.size();i++)
    qDebug() << bytes.at(i);

    QString Response = "";
    return 1;
    //emit labelChanged(Response);
}

