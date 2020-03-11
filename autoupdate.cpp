#include "autoupdate.h"
#include "httpdownload.h"
#include "logged.h"
#include <QProcess>
#include <thread>

AutoUpdate::AutoUpdate(QObject* parent) :
    QObject(parent)
{

    downloader = new HttpDownload(this);
    QObject::connect(downloader, SIGNAL(valueChanged(qint64, qint64)),
                         this, SLOT(updateDownloadProgress(qint64, qint64)));
    QObject::connect(downloader, SIGNAL(fileDownloaded(QString)),
                         this, SLOT(onFileDownloaded(QString)));

    downloadTime.start();
    downloader->startDownloadFile(QString(DOWNLOAD_URL) + "tmp.bin");
}

AutoUpdate::~AutoUpdate()
{
    if (downloader)
        delete downloader;
}

QString inline getSpeed(qint64 read, qint64 /*total*/, QTime time)
{
    // calculate the download speed
    double speed = read * 1000.0 / time.elapsed();
    QString unit;
    if (speed < 1024) {
        unit = "bytes/sec";
    } else if (speed < 1024*1024) {
       speed /= 1024;
       unit = "kB/s";
    } else {
       speed /= 1024*1024;
       unit = "MB/s";
    }
    return QString(std::string(std::to_string((int)speed) + unit.toStdString()).c_str());
}

void AutoUpdate::updateDownloadProgress(qint64 read, qint64 total)
{
   // ui->updateBar->setMaximum(total);
   // ui->updateBar->setValue(read);
    long double kilobyteTotal, kilobyteCurrent;
    long double megabyteTotal, megabyteCurrent;

    kilobyteTotal = total / 1024;
    megabyteTotal = kilobyteTotal / 1024;

    kilobyteCurrent = read / 1024;
    megabyteCurrent = kilobyteCurrent / 1024;

    std::string downloadProgress = std::string(std::to_string((int)megabyteCurrent) + " MB / " + std::to_string((int)megabyteTotal) + " MB");
    downloadProgress.append("  " + getSpeed(read, total, downloadTime).toStdString());
   // ui->updateText->setText(downloadProgress.c_str());
}
void AutoUpdate::onFileDownloaded(QString /*file*/)
{
    system("start Updater.exe");
    qDebug("Starting autoupdater");
    std::this_thread::sleep_for(std::chrono::seconds(1));
    qApp->quit();
}
