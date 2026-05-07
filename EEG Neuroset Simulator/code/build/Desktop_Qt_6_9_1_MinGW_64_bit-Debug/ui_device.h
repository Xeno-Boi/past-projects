/********************************************************************************
** Form generated from reading UI file 'device.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_DEVICE_H
#define UI_DEVICE_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QFrame>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStackedWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_device
{
public:
    QFrame *device_frame;
    QFrame *screen_frame;
    QStackedWidget *stacked_screens;
    QWidget *page;
    QWidget *page_2;
    QPushButton *pause_button;
    QPushButton *resume_button;
    QPushButton *menu_button;
    QPushButton *power_button;
    QPushButton *up_button;
    QPushButton *down_button;
    QPushButton *select_button;
    QFrame *battery_light;
    QFrame *connect_light;
    QFrame *treatment_light;
    QFrame *disconnect_light;
    QPushButton *stop_button;

    void setupUi(QWidget *device)
    {
        if (device->objectName().isEmpty())
            device->setObjectName("device");
        device->resize(304, 394);
        device_frame = new QFrame(device);
        device_frame->setObjectName("device_frame");
        device_frame->setGeometry(QRect(0, 0, 301, 391));
        device_frame->setFrameShape(QFrame::StyledPanel);
        device_frame->setFrameShadow(QFrame::Raised);
        screen_frame = new QFrame(device_frame);
        screen_frame->setObjectName("screen_frame");
        screen_frame->setGeometry(QRect(50, 90, 201, 161));
        screen_frame->setFrameShape(QFrame::StyledPanel);
        screen_frame->setFrameShadow(QFrame::Raised);
        stacked_screens = new QStackedWidget(screen_frame);
        stacked_screens->setObjectName("stacked_screens");
        stacked_screens->setGeometry(QRect(10, 10, 181, 141));
        page = new QWidget();
        page->setObjectName("page");
        stacked_screens->addWidget(page);
        page_2 = new QWidget();
        page_2->setObjectName("page_2");
        stacked_screens->addWidget(page_2);
        pause_button = new QPushButton(device_frame);
        pause_button->setObjectName("pause_button");
        pause_button->setGeometry(QRect(50, 260, 61, 41));
        resume_button = new QPushButton(device_frame);
        resume_button->setObjectName("resume_button");
        resume_button->setGeometry(QRect(120, 260, 61, 41));
        menu_button = new QPushButton(device_frame);
        menu_button->setObjectName("menu_button");
        menu_button->setGeometry(QRect(50, 50, 51, 31));
        power_button = new QPushButton(device_frame);
        power_button->setObjectName("power_button");
        power_button->setGeometry(QRect(240, 10, 51, 41));
        up_button = new QPushButton(device_frame);
        up_button->setObjectName("up_button");
        up_button->setGeometry(QRect(260, 190, 21, 21));
        down_button = new QPushButton(device_frame);
        down_button->setObjectName("down_button");
        down_button->setGeometry(QRect(260, 220, 21, 21));
        select_button = new QPushButton(device_frame);
        select_button->setObjectName("select_button");
        select_button->setGeometry(QRect(250, 140, 41, 41));
        battery_light = new QFrame(device_frame);
        battery_light->setObjectName("battery_light");
        battery_light->setGeometry(QRect(240, 330, 31, 31));
        battery_light->setStyleSheet(QString::fromUtf8("background-color: green;"));
        battery_light->setFrameShape(QFrame::StyledPanel);
        battery_light->setFrameShadow(QFrame::Raised);
        connect_light = new QFrame(device_frame);
        connect_light->setObjectName("connect_light");
        connect_light->setGeometry(QRect(10, 10, 16, 21));
        connect_light->setFrameShape(QFrame::StyledPanel);
        connect_light->setFrameShadow(QFrame::Raised);
        treatment_light = new QFrame(device_frame);
        treatment_light->setObjectName("treatment_light");
        treatment_light->setGeometry(QRect(40, 10, 16, 21));
        treatment_light->setFrameShape(QFrame::StyledPanel);
        treatment_light->setFrameShadow(QFrame::Raised);
        disconnect_light = new QFrame(device_frame);
        disconnect_light->setObjectName("disconnect_light");
        disconnect_light->setGeometry(QRect(70, 10, 16, 21));
        disconnect_light->setFrameShape(QFrame::StyledPanel);
        disconnect_light->setFrameShadow(QFrame::Raised);
        stop_button = new QPushButton(device_frame);
        stop_button->setObjectName("stop_button");
        stop_button->setGeometry(QRect(190, 260, 61, 41));

        retranslateUi(device);

        stacked_screens->setCurrentIndex(0);


        QMetaObject::connectSlotsByName(device);
    } // setupUi

    void retranslateUi(QWidget *device)
    {
        device->setWindowTitle(QCoreApplication::translate("device", "Form", nullptr));
        pause_button->setText(QCoreApplication::translate("device", "pause", nullptr));
        resume_button->setText(QCoreApplication::translate("device", "resume", nullptr));
        menu_button->setText(QCoreApplication::translate("device", "menu", nullptr));
        power_button->setText(QCoreApplication::translate("device", "power", nullptr));
        up_button->setText(QCoreApplication::translate("device", "^", nullptr));
        down_button->setText(QCoreApplication::translate("device", "v", nullptr));
        select_button->setText(QCoreApplication::translate("device", "select", nullptr));
        stop_button->setText(QCoreApplication::translate("device", "stop", nullptr));
    } // retranslateUi

};

namespace Ui {
    class device: public Ui_device {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_DEVICE_H
