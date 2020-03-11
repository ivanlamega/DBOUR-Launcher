#include "dbosettings.h"

DboSettings::DboSettings(QObject *parent) : QObject(parent)
{
    QString configPath = "./User/SystemEnv.txt";
    QFile checkConfig(configPath);
        if(checkConfig.exists())
        {
        /*QSettings setting(configPath, QSettings::IniFormat);
            settings_ = setting; 
            settings_->beginGroup("/GRAPHIC");
            const QStringList childKeys = settings_->childKeys();
            QStringList gvalues;
            foreach (const QString &childKey, childKeys)
                gvalues << settings_->value(childKey).toString();
            settings_->endGroup();
            settings_->beginGroup("/SOUND");
            childKeys = settings_->childKeys();
            QStringList svalues;
            foreach (const QString &childKey, childKeys)
                gvalues << settings_->value(childKey).toString();
            settings_->endGroup();*/
            
            QString test = configPath;
            int a;
        }
}

void DboSettings::setValue(const QString &key, const QVariant &value) {
    settings_.setValue(key, value);
}

QVariant DboSettings::value(const QString &key, const QVariant &defaultValue) const {
    return settings_.value(key, defaultValue);
}
