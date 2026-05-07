QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    EEGSensor.cpp \
    Neureset.cpp \
    Sessions.cpp \
    TimeAndDate.cpp \
    dataset.cpp \
    device.cpp \
    logdisplayscreen.cpp \
    main.cpp \
    mainwindow.cpp \
    menuscreen.cpp \
    pcscreen.cpp \
    resumabletimer.cpp \
    sessionscreen.cpp \
    timeinputscreen.cpp \
    warningscreen.cpp

HEADERS += \
    EEGSensor.h \
    Neureset.h \
    Sessions.h \
    TimeAndDate.h \
    config.h \
    dataset.h \
    device.h \
    logdisplayscreen.h \
    mainwindow.h \
    menuscreen.h \
    pcscreen.h \
    resumabletimer.h \
    sessionscreen.h \
    timeinputscreen.h \
    warningscreen.h

FORMS += \
    device.ui \
    logdisplayscreen.ui \
    mainwindow.ui \
    menuscreen.ui \
    pcscreen.ui \
    sessionscreen.ui \
    timeinputscreen.ui \
    warningscreen.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
