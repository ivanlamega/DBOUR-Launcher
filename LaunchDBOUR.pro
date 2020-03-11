TEMPLATE = app
TARGET = LaunchDBOUR

QT += quick qml quickcontrols2 multimedia
CONFIG += c++11 windows

SOURCES += main.cpp \
    network.cpp \
    httpdownload.cpp \
    autoupdate.cpp \
    logged.cpp \
    zip.cpp \
    dbosettings.cpp \
    registration.cpp
RESOURCES += modules.qrc
win32:RC_ICONS += DBOUR_LauncherIcon.ico
QT_AUTO_SCREEN_SCALE_FACTOR = 0
LIBS += -lopengl32 #msvc -opengl32.lib #mingw -lopengl32

COMPILER_MINGW = C:\Qt\5.11.0\mingw53_32\qml
COMPILER_MSVC = C:\Qt\5.11.0\msvc2015\qml

QML_IMPORT_PATH = $$COMPILER_MINGW
QML_DESIGNER_IMPORT_PATH = $$COMPILER_MINGW

DEFINES += QT_DEPRECATED_WARNINGS

# Default rules for deployment.
target.path = C:\QtProjects\LaunchDBOUR
INSTALLS += target

HEADERS += \
    packet.h \
    network.h \
    httpdownload.h \
    autoupdate.h \
    logged.h \
    patchwin.h \
    zipreader.h \
    zipwriter.h \
    dbosettings.h \
    registration.h

win32: LIBS += -L$$PWD/./ -lpatchw32

INCLUDEPATH += $$PWD/.
DEPENDPATH += $$PWD/.

DISTFILES += \
    patchw32.dll

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/./ -lpatchw32
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/./ -lpatchw32

INCLUDEPATH += $$PWD/.
DEPENDPATH += $$PWD/.
