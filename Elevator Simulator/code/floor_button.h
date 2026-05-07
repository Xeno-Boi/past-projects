#ifndef FLOOR_BUTTON_H
#define FLOOR_BUTTON_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class FloorButton : public QObject{
    Q_OBJECT

    public:
    FloorButton();
    ~FloorButton();

    void press();

signals:
    void floorRequestUp(int floor);
    void floorRequestDown(int floor);

    void Signal_LightsUp(int floor, bool up);
    void Signal_LightsOff(int floor, bool up);

public slots:
    void press1Up();
    void press2Up();
    void press2Down();
    void press3Up();
    void press3Down();
    void press4Up();
    void press4Down();
    void press5Up();
    void press5Down();
    void press6Up();
    void press6Down();
    void press7Down();

    void lightsOff(int floor, bool up);
};

#endif
