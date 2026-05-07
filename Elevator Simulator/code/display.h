#ifndef DISPLAY_H
#define DISPLAY_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class Display : public QObject{
    Q_OBJECT

public:
    Display();
    ~Display();

signals:
    void updateDisplay(string);

public slots:
    void display(string);
};

#endif
