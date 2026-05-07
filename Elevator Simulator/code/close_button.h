#ifndef CLOSE_BUTTON_H
#define CLOSE_BUTTON_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class CloseButton  : public QObject{
    Q_OBJECT
public:
    CloseButton();
    ~CloseButton();
    
signals:
    void pressed();

public slots:
    void press();
};

#endif
