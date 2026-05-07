#ifndef OPEN_BUTTON_H
#define OPEN_BUTTON_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>


using namespace std;

class OpenButton : public QObject{
    Q_OBJECT
    public:
    OpenButton();
    ~OpenButton();
    
signals:
    void pressed(bool auto_close);

public slots:
    void press();
};

#endif
