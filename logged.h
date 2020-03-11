#ifndef LOGGED_H
#define LOGGED_H
#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include "httpdownload.h"
#include "packet.h"
#include <QQuickItem>


#define DOWNLOAD_URL "http://104.216.111.66/update/"

struct Version
{
  int major = 0, minor = 0, revision = 0, type = 0;//type 1 zip, 0 rtp

        Version(std::string version)
        {
                std::sscanf(version.c_str(), "%d.%d.%d.%d", &major, &minor, &revision, &type);
        }

        bool operator < (const Version& other)
        {
            if (major < other.major)
                return true;
            if (minor < other.minor && major == other.major)
                return true;
            if (revision < other.revision && minor == other.minor)
                return true;
            return false;
        }

        bool operator == (const Version& other)
        {
                return major == other.major
                        && minor == other.minor
                        && revision == other.revision;
        }

        friend std::ostream& operator << (std::ostream& stream, const Version& ver)
        {
                stream << ver.major;
                stream << '.';
                stream << ver.minor;
                stream << '.';
                stream << ver.revision;
                stream << '.';
                stream << ver.type;
                return stream;
        }
};

class Logged : public QObject
{
    Q_OBJECT

public:
    explicit Logged(QObject *parent = nullptr);
    Q_INVOKABLE double getDownloadTotal() const { return _downloadTotal; }
    Q_INVOKABLE double getDownloadSize() const{return _downloadSize;}
    Q_INVOKABLE double getDownloadSpeed() const { return _downloadSpeed; }
    Q_INVOKABLE QString getExtractInfo() const { return _extractInfo; }
    Q_INVOKABLE double getExtractSize() const {return _extractSize;}
    Q_INVOKABLE double getExtractTotal() const {return _extractTotal;}

    Q_INVOKABLE HttpDownload* getDownloader() { return downloader; }
    Q_INVOKABLE void setDownloader(HttpDownload* dl) { downloader = dl; }
    Q_INVOKABLE void downloadStart();
    Q_INVOKABLE void connectSignals();
    Q_INVOKABLE bool isStartable() {return _canStart; }
    Q_INVOKABLE void onFileDownloaded(QString);
    Q_INVOKABLE void on_play_clicked();
    Q_INVOKABLE void cleanup();


    void SetDataPacket(QString);
private slots:
    void updateDownloadProgress(qint64, qint64);
    void updateDownloadBarLabel(QString);
    void on_exit_clicked();
    void on_minimize_clicked();
    void on_toggleSound_clicked();
    void CheckVersion();
    void updateExtractBarLabel(QString str);
    void updateExtractProgress(double, double);
   // void on_settings_clicked();

private:
    void UpdateVersion(QString to);
    QString GetCurVersion();
    QString GetNextVersion(QString updatetxt);
    void Unzip(QString file);

//    void mousePressEvent(QMouseEvent *event);
//    void mouseMoveEvent(QMouseEvent *event);
//    int m_nMouseClick_X_Coordinate;
//    int m_nMouseClick_Y_Coordinate;
signals:
    void allFilesDone(bool);
    void onClose();
    void extractLabelChanged(QString);
    void extractValueChanged(double, double);
    void valueChanged(bool);
    void patchFailed(bool);
private:
    HttpDownload* downloader;
    QTime downloadTime;
    Version currentVersion;
    Version nextVersion;
    bool isRTPFile = true;
    QString _res;
    double _downloadTotal;//Total Download Size in MB
    double  _downloadSize;
    double _downloadSpeed; //Download Speed in Bytes
    bool   _canStart;
    QString _extractInfo;
    double _extractSize;
    double _extractTotal;
};

#endif // LOGGED_H
