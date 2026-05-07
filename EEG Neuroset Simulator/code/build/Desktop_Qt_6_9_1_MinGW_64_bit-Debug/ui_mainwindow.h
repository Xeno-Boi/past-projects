/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QFrame>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QWidget>
#include "device.h"
#include "pcscreen.h"

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QPushButton *connect_button;
    QPushButton *disconnect_button;
    QPushButton *charge_battery_button;
    device *device_widget;
    QPushButton *print_computer_log_button;
    QPushButton *dataset_1_button;
    QPushButton *dataset_2_button;
    QPushButton *dataset_alpha_button;
    QLabel *label;
    QPushButton *dataset_beta_button;
    QPushButton *dataset_delta_button;
    QPushButton *dataset_gamma_button;
    QPushButton *dataset_theta_button;
    QFrame *frame;
    PCScreen *pc_screen;
    QLabel *label_2;
    QLabel *label_3;
    QMenuBar *menubar;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName("MainWindow");
        MainWindow->resize(1137, 564);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName("centralwidget");
        connect_button = new QPushButton(centralwidget);
        connect_button->setObjectName("connect_button");
        connect_button->setGeometry(QRect(30, 160, 83, 25));
        disconnect_button = new QPushButton(centralwidget);
        disconnect_button->setObjectName("disconnect_button");
        disconnect_button->setGeometry(QRect(30, 210, 83, 25));
        charge_battery_button = new QPushButton(centralwidget);
        charge_battery_button->setObjectName("charge_battery_button");
        charge_battery_button->setGeometry(QRect(30, 270, 101, 31));
        device_widget = new device(centralwidget);
        device_widget->setObjectName("device_widget");
        device_widget->setGeometry(QRect(210, 60, 331, 401));
        print_computer_log_button = new QPushButton(centralwidget);
        print_computer_log_button->setObjectName("print_computer_log_button");
        print_computer_log_button->setGeometry(QRect(30, 330, 141, 31));
        dataset_1_button = new QPushButton(centralwidget);
        dataset_1_button->setObjectName("dataset_1_button");
        dataset_1_button->setGeometry(QRect(580, 150, 83, 25));
        dataset_2_button = new QPushButton(centralwidget);
        dataset_2_button->setObjectName("dataset_2_button");
        dataset_2_button->setGeometry(QRect(580, 190, 83, 25));
        dataset_alpha_button = new QPushButton(centralwidget);
        dataset_alpha_button->setObjectName("dataset_alpha_button");
        dataset_alpha_button->setGeometry(QRect(580, 230, 83, 25));
        label = new QLabel(centralwidget);
        label->setObjectName("label");
        label->setGeometry(QRect(580, 120, 91, 17));
        dataset_beta_button = new QPushButton(centralwidget);
        dataset_beta_button->setObjectName("dataset_beta_button");
        dataset_beta_button->setGeometry(QRect(580, 270, 83, 25));
        dataset_delta_button = new QPushButton(centralwidget);
        dataset_delta_button->setObjectName("dataset_delta_button");
        dataset_delta_button->setGeometry(QRect(580, 310, 83, 25));
        dataset_gamma_button = new QPushButton(centralwidget);
        dataset_gamma_button->setObjectName("dataset_gamma_button");
        dataset_gamma_button->setGeometry(QRect(580, 390, 83, 25));
        dataset_theta_button = new QPushButton(centralwidget);
        dataset_theta_button->setObjectName("dataset_theta_button");
        dataset_theta_button->setGeometry(QRect(580, 350, 83, 25));
        frame = new QFrame(centralwidget);
        frame->setObjectName("frame");
        frame->setGeometry(QRect(700, 80, 361, 351));
        frame->setFrameShape(QFrame::StyledPanel);
        frame->setFrameShadow(QFrame::Raised);
        pc_screen = new PCScreen(frame);
        pc_screen->setObjectName("pc_screen");
        pc_screen->setGeometry(QRect(0, 0, 361, 351));
        label_2 = new QLabel(centralwidget);
        label_2->setObjectName("label_2");
        label_2->setGeometry(QRect(330, 20, 101, 31));
        QFont font;
        font.setPointSize(20);
        label_2->setFont(font);
        label_3 = new QLabel(centralwidget);
        label_3->setObjectName("label_3");
        label_3->setGeometry(QRect(870, 30, 101, 31));
        label_3->setFont(font);
        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName("menubar");
        menubar->setGeometry(QRect(0, 0, 1137, 22));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName("statusbar");
        MainWindow->setStatusBar(statusbar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "MainWindow", nullptr));
        connect_button->setText(QCoreApplication::translate("MainWindow", "connect", nullptr));
        disconnect_button->setText(QCoreApplication::translate("MainWindow", "disconnect", nullptr));
        charge_battery_button->setText(QCoreApplication::translate("MainWindow", "charge battery", nullptr));
        print_computer_log_button->setText(QCoreApplication::translate("MainWindow", "print computer logs", nullptr));
        dataset_1_button->setText(QCoreApplication::translate("MainWindow", "dataset 1", nullptr));
        dataset_2_button->setText(QCoreApplication::translate("MainWindow", "dataset 2", nullptr));
        dataset_alpha_button->setText(QCoreApplication::translate("MainWindow", "alpha", nullptr));
        label->setText(QCoreApplication::translate("MainWindow", "load dataset", nullptr));
        dataset_beta_button->setText(QCoreApplication::translate("MainWindow", "beta", nullptr));
        dataset_delta_button->setText(QCoreApplication::translate("MainWindow", "delta", nullptr));
        dataset_gamma_button->setText(QCoreApplication::translate("MainWindow", "gamma", nullptr));
        dataset_theta_button->setText(QCoreApplication::translate("MainWindow", "theta", nullptr));
        label_2->setText(QCoreApplication::translate("MainWindow", "Device", nullptr));
        label_3->setText(QCoreApplication::translate("MainWindow", "PC", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
