#include "logged.h"
#include "zipreader.h"
#include "zipwriter.h"
#include "patchwin.h"
#include <QRegExp>
#include <QtZlib/zlib.h>
#include <QMediaPlaylist>
#include <QMouseEvent>
UINT
    __declspec( dllimport )
    CALLBACK RTPatchApply32( LPSTR CmdLine,
                LPVOID (CALLBACK * CallBackFn)(UINT, LPVOID),
                BOOL WaitFlag);


Logged::Logged(QObject* parent) :
    QObject(parent),
    currentVersion{Version("0.0.0.0")},
    nextVersion{Version("0.0.0.0")},
    _canStart{false},
    _extractInfo{"Extracting"},
    _extractSize{0},
    _extractTotal{1000},
    isRTPFile{true}
{
//    ui->setupUi(this);
//    ui->downloadLabel->setStyleSheet("QLabel { color : white; font: 10pt;}");
//    ui->patchLabel->setStyleSheet("QLabel { color : white; font: 10pt;}");
//    ui->downloadLabel->setStyleSheet("QLabel { color : white; font: 10pt;}");
//    ui->GameVersion->setStyleSheet("QLabel { color : white; font: 10pt;}");
//    ui->downloadLabel->alignment() = Qt::AlignHCenter;
//    ui->downloadbar->setMinimum(0);
//    ui->patchbar->setMinimum(0);
//    ui->play->setEnabled(false);


//    setWindowFlags(Qt::Window | Qt::FramelessWindowHint);
//    this->setAttribute(Qt::WA_TranslucentBackground);
    _extractInfo = "Extracting";
    _extractSize = 1;
    _extractTotal = 1000;

}

void Logged::SetDataPacket(QString data)
{
    _res = data;
    qDebug(data.toStdString().c_str());
}

void Logged::cleanup()
{
    std::string cur = std::to_string(currentVersion.major) + "." + std::to_string(currentVersion.minor) + "." + std::to_string(currentVersion.revision) + std::to_string(currentVersion.type);
    std::string next = std::to_string(nextVersion.major) + "." + std::to_string(nextVersion.minor) + "." + std::to_string(nextVersion.revision) + "." + std::to_string(nextVersion.type);
    std::string version;
    if(isRTPFile == true)
        version = cur + "_" + next + ".rtp";
    else
        version = cur + "_" + next + ".zip";

    // -- Remove tmp update zip
    QString filename(version.c_str());
    QFile file(filename);
    if(file.open(QIODevice::ReadOnly))
    {
        file.close();
        file.remove();
    }

    // -- Remove update.txt
    filename = QString("update.txt");
    QFile file2(filename);
    if(file2.open(QIODevice::ReadOnly))
    {
        file2.close();
        file2.remove();
    }
}

QString inline getDownloadSpeed(qint64 read, qint64 /*total*/, QTime time)
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

void Logged::updateDownloadProgress(qint64 read, qint64 total)
{
    _downloadTotal = (total / 1024 / 1024);//Total Download Size in MB
    _downloadSize = ((total - read) /1024 /1024 ); // Remaining size
    _downloadSpeed = read * 1000 / downloadTime.elapsed(); //Download Speed in Bytes
    //qDebug("Logger Download Progress updated");
}

void Logged::updateDownloadBarLabel(QString str)
{
    //ui->downloadLabel->setText(str);
}
void Logged::updateExtractBarLabel(QString str)
{
    _extractInfo = str;
    emit extractLabelChanged(_extractInfo);

}
void Logged::updateExtractProgress(double cur, double total)
{
    _extractSize = cur;
    _extractTotal = total;
    emit extractValueChanged(_extractSize, _extractTotal);

}
void Logged::Unzip(QString filename)
{
    ZipReader cZip(filename);
    qDebug("Unzip, ZipReader init");
    int count = 1;
    if (!cZip.isReadable())
    {
       // QMessageBox::critical(0, "error", "Unexpected error, update file corrupted.");
        cZip.close();
        return;
    }
    qDebug("Unzip, is readable ok");

    foreach(ZipReader::FileInfo item, cZip.fileInfoList())
    {
//        updateExtractBarLabel(item.filePath);
//        updateExtractProgress(count, cZip.count());
        // -- If already exists, remove
        QFile file(item.filePath);
        if (file.exists())
        {
            file.remove();
        }
        // -- If folder not exist create
        QDir d = QFileInfo(item.filePath).absoluteDir();
        if (!d.exists())
        {
            qDebug(QFileInfo(item.filePath).absolutePath().toStdString().c_str());
            d.mkpath(QFileInfo(item.filePath).absolutePath());
        }
        // -- Write on file
        file.open(QIODevice::WriteOnly);
        file.write(cZip.fileData(item.filePath));
        file.close();
        count++;
        qDebug() << item.filePath;
    }
    cZip.close();
}
void Logged::onFileDownloaded(QString filename)
{
    QFile file(filename);
    if (!file.fileName().contains("txt", Qt::CaseSensitivity::CaseInsensitive))
    {
        QFile file(filename);
        if(!file.open(QIODevice::ReadOnly))
        {
           qDebug("onFileDownloaded error" + file.errorString().toLocal8Bit() );
        }
        else
        {
            // -- Unzip update
            qDebug("Applying RTPatch");
            qDebug(filename.toStdString().c_str());
            QString CmdLine;
            CmdLine = "\"";
            CmdLine += QDir::currentPath().replace("/", "\\");
            CmdLine += "\" \"";
            CmdLine += filename.replace("/", "\\");
            CmdLine += "\" ";

            qDebug("CommandLine Variable for RTPatch is");
            qDebug(CmdLine.toStdString().c_str());

            if(isRTPFile)
            {
                quint32 retCode = RTPatchApply32((LPSTR)CmdLine.toStdString().c_str(), NULL, TRUE);
                if(retCode != 0)
                {
                    qDebug("RTPatch returned %d FAILED", retCode);
                    emit patchFailed(true);
                }
                else
                {
                    std::string cur = std::to_string(nextVersion.major) + "." + std::to_string(nextVersion.minor) + "." + std::to_string(nextVersion.revision) + "." + std::to_string(nextVersion.type);
                    UpdateVersion(QString(cur.c_str()));
                    CheckVersion();
                    file.remove();
                    file.close();
                    qDebug("RTPatch returned %d SUCCESS", retCode);
                }
            }
            else
            {
                Unzip(file.fileName());
                file.remove();
                file.close();

                std::string cur = std::to_string(nextVersion.major) + "." + std::to_string(nextVersion.minor) + "." + std::to_string(nextVersion.revision) + "." + std::to_string(nextVersion.type);
                UpdateVersion(QString(cur.c_str()));
                CheckVersion();

            }
        }
    }
    else
    {
        qDebug("cant find update, and there is no update.txt We should check version" );
        CheckVersion();
    }

}
void Logged::UpdateVersion(QString to)
{
    QFile file("version.txt");
    file.remove();
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << to << "\n";
    file.close();
    currentVersion = Version(to.toStdString());
    qDebug("Version updated to: %d.%d.%d\n", currentVersion.major, currentVersion.minor, currentVersion.revision);
    QString nextVersion = GetNextVersion("update.txt");
    if (nextVersion == "")
    {
        _canStart = true;
    }
}
void Logged::CheckVersion()
{
    QString ver = GetCurVersion();
    currentVersion = ver.toStdString();
    qDebug(QString(QString("Check Version: Current Version: ") + ver).toStdString().c_str());
    QString nextVersion = GetNextVersion("update.txt");
    qDebug(QString(QString("Check Version: Next Version: ") + nextVersion).toStdString().c_str());
    if (nextVersion != "")
    {
        qDebug(QString(QString("download: ") + DOWNLOAD_URL + nextVersion).toStdString().c_str());
        downloader->startDownloadFile(QString(DOWNLOAD_URL) + nextVersion);
        qDebug("We are need to update the current version" );

    }
    else
    {
        QFile file("update.txt");
        file.remove();
        qDebug("We are on the current version. Enable the play button." );
        _canStart = true;
        emit allFilesDone(true);
    }

}
QString Logged::GetCurVersion()
{
    QFile file("version.txt");
    QString version = "0.0.0.0";
    // -- Version file doesn't exist
    if(!file.open(QIODevice::ReadOnly))
    {
        UpdateVersion("0.0.0.0");
    }
    else
    {
        QTextStream in(&file);
        version = in.readLine();
        file.close();
    }
    return version;
}
QString Logged::GetNextVersion(QString updatetxt)
{
    QRegExp rx("(.*)_(.*)");
    QFile updateTxt(updatetxt);
    // -- Version file doesn't exist
    if(!updateTxt.open(QIODevice::ReadOnly))
    {
       // QMessageBox::information(0, "error", updateTxt.errorString()  + ": " + updatetxt);
    }
    else
    {
        QTextStream in(&updateTxt);
        while(!in.atEnd())
        {
            QString line = in.readLine();
            // -- Version compare
            if (rx.indexIn(line) != -1)
            {
                const Version _curVersion(rx.cap(1).toStdString());
                if (currentVersion == _curVersion || currentVersion < _curVersion)
                {
                    qDebug("New version found, current: %d.%d.%d.%d new : %d.%d.%d.%d", currentVersion.major, currentVersion.minor, currentVersion.revision,currentVersion.type,
                           _curVersion.major, _curVersion.minor, _curVersion.revision, _curVersion.type);
                    nextVersion = Version(rx.cap(2).toStdString());
                    if(nextVersion.type == 0)
                    {
                        isRTPFile = false;
                        return line + "/" + line + ".zip";
                    }
                    else
                    {
                        isRTPFile = true;
                        return line + "/" + line + ".RTP";
                    }
                }
                else {
                    _canStart = true;
                }

            }
        }
        updateTxt.close();
    }
    return "";
}

void Logged::on_exit_clicked()
{
    if (downloader)
        downloader->cancel();
    emit onClose();
}

void Logged::on_minimize_clicked()
{
    //this->setWindowState(Qt::WindowMinimized);
}

void Logged::on_toggleSound_clicked()
{
    //audio->setMuted(!audio->isMuted());
}

void Logged::on_play_clicked()
{
    qDebug("Start game");
    system(std::string("start "" /D client dbo.exe -hstrh " + _res.toStdString()).c_str());
    cleanup();
    qApp->quit();
}

void Logged::downloadStart()
{
    downloadTime.start();
    downloader->startDownloadFile(QString(DOWNLOAD_URL) + "update.txt");
    _canStart = false;

}

void Logged::connectSignals()
{
    //this should run before anything else
    QObject::connect(downloader, SIGNAL(valueChanged(qint64, qint64)),
                         this, SLOT(updateDownloadProgress(qint64, qint64)));
    QObject::connect(downloader, SIGNAL(labelChanged(QString)),
                         this, SLOT(updateDownloadBarLabel(QString)));
    QObject::connect(downloader, SIGNAL(fileDownloaded(QString)),
                         this, SLOT(onFileDownloaded(QString)));
   QObject::connect(this, SIGNAL(valueChanged(bool)),
                     this, SLOT(allFilesDone(bool)));
 /*   QObject::connect(this, SIGNAL(extractValueChanged(double, double)),
                     this, SLOT(updateExtractProgress(double, double)));
    QObject::connect(this, SIGNAL(extractLabelChanged(QString)),
                     this, SLOT(updateExtractBarLabel(QString)));*/
}
