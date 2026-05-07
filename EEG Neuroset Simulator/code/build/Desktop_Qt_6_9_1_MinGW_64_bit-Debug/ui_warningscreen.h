/********************************************************************************
** Form generated from reading UI file 'warningscreen.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_WARNINGSCREEN_H
#define UI_WARNINGSCREEN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_WarningScreen
{
public:
    QTextBrowser *textBrowser;

    void setupUi(QWidget *WarningScreen)
    {
        if (WarningScreen->objectName().isEmpty())
            WarningScreen->setObjectName("WarningScreen");
        WarningScreen->resize(182, 140);
        textBrowser = new QTextBrowser(WarningScreen);
        textBrowser->setObjectName("textBrowser");
        textBrowser->setGeometry(QRect(10, 40, 161, 51));

        retranslateUi(WarningScreen);

        QMetaObject::connectSlotsByName(WarningScreen);
    } // setupUi

    void retranslateUi(QWidget *WarningScreen)
    {
        WarningScreen->setWindowTitle(QCoreApplication::translate("WarningScreen", "Form", nullptr));
        textBrowser->setHtml(QCoreApplication::translate("WarningScreen", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'Sans'; font-size:10pt; font-weight:400; font-style:normal;\">\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Please Connect Sensor</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">to Continue</p></body></html>", nullptr));
    } // retranslateUi

};

namespace Ui {
    class WarningScreen: public Ui_WarningScreen {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_WARNINGSCREEN_H
