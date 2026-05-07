#ifndef CAR_H
#define CAR_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class Car : public QObject{
    Q_OBJECT

    public:
    Car();
    ~Car();

signals:
    void updateDirectionDisplay(string);

public slots:
    void moveUp();
    void moveDown();
    void moveStop();

};

#endif
