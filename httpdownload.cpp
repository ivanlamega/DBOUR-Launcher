#include "httpdownload.h"

HttpDownload::HttpDownload(QObject *parent) :
    QObject(parent),
  labelValue{""}
{
    manager = new QNetworkAccessManager(this);
}

HttpDownload::~HttpDownload()
{
    if (manager)
        delete manager;
}

void HttpDownload::cancel()
{
    httpRequestAborted = true;
    if (reply)
        reply->abort();
}
void HttpDownload::startDownloadFile(QString str)
{
    url = str;
    QFileInfo fileInfo(url.path());
    QString fileName = fileInfo.fileName();

    // -- Remove old file
    if (QFile::exists(fileName))
    {
        QFile::remove(fileName);
    }
    file = new QFile(fileName);
    if (!file->open(QIODevice::WriteOnly))
    {
//        QMessageBox::information(this, tr("HTTP"),
//                      tr("Unable to save the file %1: %2.")
//                      .arg(fileName).arg(file->errorString()));
        delete file;
        file = nullptr;
        return;
    }
    httpRequestAborted = false;
    emit labelChanged(QString("Downloading: " + fileName));
    startRequest(url);
}
// This will be called download start
void HttpDownload::startRequest(QUrl url)
{
    reply = manager->get(QNetworkRequest(url));
    connect(reply, SIGNAL(readyRead()),
            this, SLOT(httpReadyRead()));
    connect(reply, SIGNAL(downloadProgress(qint64,qint64)),
            this, SLOT(updateDownloadProgress(qint64,qint64)));
    connect(reply, SIGNAL(finished()),
            this, SLOT(httpDownloadFinished()));

}
void HttpDownload::httpReadyRead()
{
    if (file->write(reply->readAll()) == -1) {
       // some error occurred
        qWarning("ERROR ERROR ERROR ON FILE WRITE");
    }
}

void HttpDownload::updateDownloadProgress(qint64 bytesRead, qint64 totalBytes)
{
    if (httpRequestAborted)
        return;
    // -- signal

    emit valueChanged(bytesRead, totalBytes);
}

void HttpDownload::httpDownloadFinished()
{
    // when canceled
    if (httpRequestAborted)
    {
        if (file)
        {
            file->close();
            file->remove();
            delete file;
            file = nullptr;
        }
        reply->deleteLater();
        return;
    }

    // download finished normally
    file->write(reply->readAll());
    file->flush();
    file->close();
    qDebug(std::string("File flush size: " + std::to_string(file->size())).c_str());
    if (reply->error())
    {
        file->remove();
//        QMessageBox::information(this, tr("HTTP"),
//                                 tr("Download failed: %1.")
//                                 .arg(reply->errorString()));
    }
    else
    {
        reply->deleteLater();
        reply = nullptr;
        QString fileName = QFileInfo(QUrl(file->fileName()).path()).fileName();
        emit labelChanged(tr("Downloaded %1 to %2.").arg(fileName).arg(QDir::currentPath()));
    }

    QString filename = file->fileName();
    delete file;
    qDebug("File Download Completed : " );
    labelValue = filename;
    emit fileDownloaded(QDir::currentPath() + "/" + filename);
}
