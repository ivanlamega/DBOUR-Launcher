#ifndef HTTPDOWNLOAD_H
#define HTTPDOWNLOAD_H
#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QFile>
#include <QFileInfo>
#include <QDir>

class HttpDownload : public QObject
{
    Q_OBJECT

public:
    explicit HttpDownload(QObject *parent = nullptr);
    ~HttpDownload();

    Q_INVOKABLE QString getDownloadedFile() const { return labelValue; }

// -- Http downloader.
    void startDownloadFile(QString str);
    void cancel();
private:
    // This will be called download start
    void startRequest(QUrl url);
private slots:
    void httpReadyRead();
    void httpDownloadFinished();
    void updateDownloadProgress(qint64, qint64);
signals:
    void valueChanged(qint64, qint64);
    void labelChanged(QString);
    void fileDownloaded(QString);
private:
    QUrl url;
    QNetworkAccessManager *manager;
    QNetworkReply *reply;
    QFile *file;
    bool httpRequestAborted;
    QString labelValue;
};

#endif // HTTPDOWNLOAD_H
