#ifndef WERGHT_SENSOR_H
#define WERGHT_SENSOR_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

// forward declaration
class Elevator;

class WeightSensor : public QObject{
    Q_OBJECT

public:
    WeightSensor();
    ~WeightSensor();

    inline bool isOverloaded(){ return overweight; };

signals:
    void Signal_Overload();
    void Signal_NormalLoad();

public slots:
    void overload();
    void normalLoad();

    private:
    bool overweight = false;    // keeps track of if the elevator is overloading

    // reference
    Elevator* elevator;
};

#endif
