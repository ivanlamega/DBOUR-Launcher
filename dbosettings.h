#ifndef DBOSETTINGS_H
#define DBOSETTINGS_H

#include <QObject>
#include <QSettings>
#include <QFile>
class DboSettings : public QObject
{
    Q_OBJECT
public:
    explicit DboSettings(QObject *parent = nullptr);
    Q_INVOKABLE void setValue(const QString & key, const QVariant & value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;

signals:

public slots:
private:
    QSettings settings_;
};
#endif // DBOSETTINGS_H
