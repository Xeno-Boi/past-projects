#ifndef HELP_BUTTON_H
#define HELP_BUTTON_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class HelpButton : public QObject{
    Q_OBJECT

public:
    HelpButton();
    ~HelpButton();

signals:
    void help();

public slots:
    void press();
};

#endif
