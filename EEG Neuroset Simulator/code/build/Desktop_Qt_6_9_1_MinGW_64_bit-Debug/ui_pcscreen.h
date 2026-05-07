/********************************************************************************
** Form generated from reading UI file 'pcscreen.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_PCSCREEN_H
#define UI_PCSCREEN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QListWidget>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_PCScreen
{
public:
    QLabel *label;
    QListWidget *log_list;
    QPushButton *upload_logs_button;

    void setupUi(QWidget *PCScreen)
    {
        if (PCScreen->objectName().isEmpty())
            PCScreen->setObjectName("PCScreen");
        PCScreen->resize(361, 329);
        label = new QLabel(PCScreen);
        label->setObjectName("label");
        label->setGeometry(QRect(90, 30, 191, 51));
        QFont font;
        font.setPointSize(20);
        label->setFont(font);
        log_list = new QListWidget(PCScreen);
        log_list->setObjectName("log_list");
        log_list->setGeometry(QRect(50, 90, 261, 181));
        upload_logs_button = new QPushButton(PCScreen);
        upload_logs_button->setObjectName("upload_logs_button");
        upload_logs_button->setGeometry(QRect(140, 290, 83, 25));

        retranslateUi(PCScreen);

        QMetaObject::connectSlotsByName(PCScreen);
    } // setupUi

    void retranslateUi(QWidget *PCScreen)
    {
        PCScreen->setWindowTitle(QCoreApplication::translate("PCScreen", "Form", nullptr));
        label->setText(QCoreApplication::translate("PCScreen", "Detailed Logs", nullptr));
        upload_logs_button->setText(QCoreApplication::translate("PCScreen", "Upload Logs", nullptr));
    } // retranslateUi

};

namespace Ui {
    class PCScreen: public Ui_PCScreen {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_PCSCREEN_H
