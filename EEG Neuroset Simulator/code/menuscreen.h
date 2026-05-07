#ifndef MENUSCREEN_H
#define MENUSCREEN_H

#include <QWidget>
#include <iostream>

#include "config.h"

using namespace std;

namespace Ui {
class MenuScreen;
}

class MenuScreen : public QWidget
{
    Q_OBJECT

public:
    explicit MenuScreen(QWidget *parent = nullptr);
    ~MenuScreen();

    // setters
    void setHighlightItem(int index);

    // getters
    int getCurrentItem();
    int getItemCount();

private:
    Ui::MenuScreen *ui;
};

#endif // MENUSCREEN_H
