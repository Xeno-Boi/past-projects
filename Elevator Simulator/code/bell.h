#ifndef BELL_H
#define BELL_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class Bell : public QObject{
    Q_OBJECT

public:
    Bell();
    ~Bell();

public slots:
    void ring();
};

#endif
