/********************************************************************************
** Form generated from reading UI file 'menuscreen.ui'
**
** Created by: Qt User Interface Compiler version 6.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MENUSCREEN_H
#define UI_MENUSCREEN_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QListWidget>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MenuScreen
{
public:
    QLabel *label;
    QListWidget *menu_list;

    void setupUi(QWidget *MenuScreen)
    {
        if (MenuScreen->objectName().isEmpty())
            MenuScreen->setObjectName("MenuScreen");
        MenuScreen->resize(182, 141);
        label = new QLabel(MenuScreen);
        label->setObjectName("label");
        label->setGeometry(QRect(50, -10, 151, 61));
        QFont font;
        font.setPointSize(20);
        label->setFont(font);
        menu_list = new QListWidget(MenuScreen);
        menu_list->setObjectName("menu_list");
        menu_list->setGeometry(QRect(20, 40, 141, 91));
        QFont font1;
        font1.setPointSize(10);
        menu_list->setFont(font1);

        retranslateUi(MenuScreen);

        QMetaObject::connectSlotsByName(MenuScreen);
    } // setupUi

    void retranslateUi(QWidget *MenuScreen)
    {
        MenuScreen->setWindowTitle(QCoreApplication::translate("MenuScreen", "Form", nullptr));
        label->setText(QCoreApplication::translate("MenuScreen", "menu", nullptr));
    } // retranslateUi

};

namespace Ui {
    class MenuScreen: public Ui_MenuScreen {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MENUSCREEN_H
