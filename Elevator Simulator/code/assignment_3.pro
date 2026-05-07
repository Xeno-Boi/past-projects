QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    audio.cpp \
    bell.cpp \
    car.cpp \
    close_button.cpp \
    display.cpp \
    door.cpp \
    door_sensor.cpp \
    ecs.cpp \
    elevator.cpp \
    elevator_floor_button.cpp \
    floor_button.cpp \
    floor_sensor.cpp \
    help_button.cpp \
    main.cpp \
    mainwindow.cpp \
    open_button.cpp \
    weight_sensor.cpp
HEADERS += \
    audio.h \
    bell.h \
    car.h \
    close_button.h \
    display.h \
    door.h \
    door_sensor.h \
    ecs.h \
    elevator.h \
    elevator_floor_button.h \
    floor_button.h \
    floor_sensor.h \
    help_button.h \
    mainwindow.h \
    open_button.h \
    weight_sensor.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
