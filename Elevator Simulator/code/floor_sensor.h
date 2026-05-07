#ifndef FLOOR_SENSOR_H
#define FLOOR_SENSOR_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class FloorSensor : public QObject{
    Q_OBJECT;

public:
    FloorSensor();
    ~FloorSensor();

signals:
    void newFloor();

private slots:
    void detectFloor();
};

#endif
