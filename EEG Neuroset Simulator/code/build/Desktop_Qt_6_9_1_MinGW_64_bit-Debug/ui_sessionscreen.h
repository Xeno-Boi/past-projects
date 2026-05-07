/********************************************************************************
** Form generated from reading UI file 'sessionscreen.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_SESSIONSCREEN_H
#define UI_SESSIONSCREEN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLCDNumber>
#include <QtWidgets/QLabel>
#include <QtWidgets/QProgressBar>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_SessionScreen
{
public:
    QLabel *label;
    QLCDNumber *minute_display;
    QLCDNumber *second_display;
    QLabel *label_2;
    QTextBrowser *state_display;
    QLabel *pause_label;
    QProgressBar *progress_bar;

    void setupUi(QWidget *SessionScreen)
    {
        if (SessionScreen->objectName().isEmpty())
            SessionScreen->setObjectName("SessionScreen");
        SessionScreen->setEnabled(true);
        SessionScreen->resize(182, 141);
        QFont font;
        font.setKerning(true);
        SessionScreen->setFont(font);
        label = new QLabel(SessionScreen);
        label->setObjectName("label");
        label->setGeometry(QRect(40, 0, 101, 31));
        minute_display = new QLCDNumber(SessionScreen);
        minute_display->setObjectName("minute_display");
        minute_display->setGeometry(QRect(30, 70, 51, 31));
        QFont font1;
        font1.setPointSize(10);
        font1.setKerning(true);
        minute_display->setFont(font1);
        minute_display->setDigitCount(2);
        second_display = new QLCDNumber(SessionScreen);
        second_display->setObjectName("second_display");
        second_display->setGeometry(QRect(100, 70, 51, 31));
        second_display->setFont(font1);
        second_display->setDigitCount(2);
        label_2 = new QLabel(SessionScreen);
        label_2->setObjectName("label_2");
        label_2->setGeometry(QRect(80, 70, 16, 31));
        QFont font2;
        font2.setPointSize(20);
        font2.setKerning(true);
        label_2->setFont(font2);
        label_2->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);
        state_display = new QTextBrowser(SessionScreen);
        state_display->setObjectName("state_display");
        state_display->setGeometry(QRect(0, 30, 181, 31));
        pause_label = new QLabel(SessionScreen);
        pause_label->setObjectName("pause_label");
        pause_label->setGeometry(QRect(50, 110, 71, 21));
        QFont font3;
        font3.setPointSize(15);
        font3.setKerning(true);
        pause_label->setFont(font3);
        progress_bar = new QProgressBar(SessionScreen);
        progress_bar->setObjectName("progress_bar");
        progress_bar->setGeometry(QRect(20, 110, 141, 16));
        progress_bar->setMaximum(100);
        progress_bar->setValue(40);
        progress_bar->setTextVisible(true);
        progress_bar->setInvertedAppearance(false);

        retranslateUi(SessionScreen);

        QMetaObject::connectSlotsByName(SessionScreen);
    } // setupUi

    void retranslateUi(QWidget *SessionScreen)
    {
        SessionScreen->setWindowTitle(QCoreApplication::translate("SessionScreen", "Form", nullptr));
        label->setText(QCoreApplication::translate("SessionScreen", "Current State", nullptr));
        label_2->setText(QCoreApplication::translate("SessionScreen", ":", nullptr));
        state_display->setHtml(QCoreApplication::translate("SessionScreen", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'Sans'; font-size:10pt; font-weight:400; font-style:normal;\">\n"
"<p align=\"center\" style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br /></p></body></html>", nullptr));
        pause_label->setText(QCoreApplication::translate("SessionScreen", "Paused", nullptr));
        progress_bar->setFormat(QCoreApplication::translate("SessionScreen", "%p%", nullptr));
    } // retranslateUi

};

namespace Ui {
    class SessionScreen: public Ui_SessionScreen {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_SESSIONSCREEN_H
