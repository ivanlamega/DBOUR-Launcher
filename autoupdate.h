#ifndef AUTOUPDATE_H
#define AUTOUPDATE_H
#pragma once

#include <QObject>
#include <QTime>


class HttpDownload;
class AutoUpdate : public QObject
{
    Q_OBJECT

public:
    explicit AutoUpdate(QObject *parent = nullptr);
    ~AutoUpdate();
private slots:
    void updateDownloadProgress(qint64, qint64);
    void onFileDownloaded(QString);

private:
    HttpDownload* downloader;
    QTime downloadTime;
};

#endif // AUTOUPDATE_H
