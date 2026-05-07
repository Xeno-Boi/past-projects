/********************************************************************************
** Form generated from reading UI file 'logdisplayscreen.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_LOGDISPLAYSCREEN_H
#define UI_LOGDISPLAYSCREEN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QListWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_LogDisplayScreen
{
public:
    QLabel *label;
    QListWidget *log_list;

    void setupUi(QWidget *LogDisplayScreen)
    {
        if (LogDisplayScreen->objectName().isEmpty())
            LogDisplayScreen->setObjectName("LogDisplayScreen");
        LogDisplayScreen->resize(181, 142);
        label = new QLabel(LogDisplayScreen);
        label->setObjectName("label");
        label->setGeometry(QRect(60, 10, 71, 31));
        QFont font;
        font.setPointSize(20);
        label->setFont(font);
        log_list = new QListWidget(LogDisplayScreen);
        log_list->setObjectName("log_list");
        log_list->setGeometry(QRect(30, 50, 121, 81));

        retranslateUi(LogDisplayScreen);

        QMetaObject::connectSlotsByName(LogDisplayScreen);
    } // setupUi

    void retranslateUi(QWidget *LogDisplayScreen)
    {
        LogDisplayScreen->setWindowTitle(QCoreApplication::translate("LogDisplayScreen", "Form", nullptr));
        label->setText(QCoreApplication::translate("LogDisplayScreen", "Logs", nullptr));
    } // retranslateUi

};

namespace Ui {
    class LogDisplayScreen: public Ui_LogDisplayScreen {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_LOGDISPLAYSCREEN_H
