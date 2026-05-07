/********************************************************************************
** Form generated from reading UI file 'timeinputscreen.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_TIMEINPUTSCREEN_H
#define UI_TIMEINPUTSCREEN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLCDNumber>
#include <QtWidgets/QLabel>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_TimeInputScreen
{
public:
    QLabel *label_2;
    QLabel *label_3;
    QLabel *label_4;
    QLCDNumber *day_display;
    QLCDNumber *month_display;
    QLCDNumber *year_display;
    QLabel *label_6;
    QLabel *label_7;
    QLCDNumber *hour_display;
    QLCDNumber *minute_display;

    void setupUi(QWidget *TimeInputScreen)
    {
        if (TimeInputScreen->objectName().isEmpty())
            TimeInputScreen->setObjectName("TimeInputScreen");
        TimeInputScreen->resize(183, 142);
        label_2 = new QLabel(TimeInputScreen);
        label_2->setObjectName("label_2");
        label_2->setGeometry(QRect(130, 20, 31, 21));
        QFont font;
        font.setPointSize(10);
        label_2->setFont(font);
        label_3 = new QLabel(TimeInputScreen);
        label_3->setObjectName("label_3");
        label_3->setGeometry(QRect(80, 20, 41, 21));
        label_3->setFont(font);
        label_4 = new QLabel(TimeInputScreen);
        label_4->setObjectName("label_4");
        label_4->setGeometry(QRect(30, 20, 31, 21));
        label_4->setFont(font);
        day_display = new QLCDNumber(TimeInputScreen);
        day_display->setObjectName("day_display");
        day_display->setGeometry(QRect(130, 40, 31, 23));
        day_display->setDigitCount(2);
        day_display->setProperty("intValue", QVariant(1));
        month_display = new QLCDNumber(TimeInputScreen);
        month_display->setObjectName("month_display");
        month_display->setGeometry(QRect(90, 40, 31, 23));
        month_display->setDigitCount(2);
        month_display->setProperty("intValue", QVariant(1));
        year_display = new QLCDNumber(TimeInputScreen);
        year_display->setObjectName("year_display");
        year_display->setGeometry(QRect(30, 40, 51, 23));
        year_display->setDigitCount(4);
        year_display->setProperty("intValue", QVariant(2020));
        label_6 = new QLabel(TimeInputScreen);
        label_6->setObjectName("label_6");
        label_6->setGeometry(QRect(50, 70, 31, 21));
        label_6->setFont(font);
        label_7 = new QLabel(TimeInputScreen);
        label_7->setObjectName("label_7");
        label_7->setGeometry(QRect(100, 70, 51, 21));
        label_7->setFont(font);
        hour_display = new QLCDNumber(TimeInputScreen);
        hour_display->setObjectName("hour_display");
        hour_display->setGeometry(QRect(50, 90, 31, 23));
        hour_display->setDigitCount(2);
        hour_display->setProperty("intValue", QVariant(0));
        minute_display = new QLCDNumber(TimeInputScreen);
        minute_display->setObjectName("minute_display");
        minute_display->setGeometry(QRect(100, 90, 31, 23));
        minute_display->setDigitCount(2);
        minute_display->setProperty("intValue", QVariant(0));

        retranslateUi(TimeInputScreen);

        QMetaObject::connectSlotsByName(TimeInputScreen);
    } // setupUi

    void retranslateUi(QWidget *TimeInputScreen)
    {
        TimeInputScreen->setWindowTitle(QCoreApplication::translate("TimeInputScreen", "Form", nullptr));
        label_2->setText(QCoreApplication::translate("TimeInputScreen", "Day", nullptr));
        label_3->setText(QCoreApplication::translate("TimeInputScreen", "Month", nullptr));
        label_4->setText(QCoreApplication::translate("TimeInputScreen", "Year", nullptr));
        label_6->setText(QCoreApplication::translate("TimeInputScreen", "Hour", nullptr));
        label_7->setText(QCoreApplication::translate("TimeInputScreen", "Minute", nullptr));
    } // retranslateUi

};

namespace Ui {
    class TimeInputScreen: public Ui_TimeInputScreen {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_TIMEINPUTSCREEN_H
