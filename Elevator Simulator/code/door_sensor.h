#ifndef DOOR_SENSOR_H
#define DOOR_SENSOR_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class DoorSensor : public QObject{
    Q_OBJECT

    public:
    DoorSensor();
    ~DoorSensor();

    inline bool isObstructed(){ return obstructed; };

signals:
    void doorObstructs();

public slots:
    void obstruct();
    void unobstruct();

    private:
    bool obstructed = false;    // keeps track of if the sensor is obstructed
};

#endif
