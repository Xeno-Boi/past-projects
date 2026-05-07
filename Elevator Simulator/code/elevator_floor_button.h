#ifndef ELEVATOR_FLOOR_BUTTON_H
#define ELEVATOR_FLOOR_BUTTON_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class ElevatorFloorButton : public QObject{
    Q_OBJECT

public:
    ElevatorFloorButton();
    ~ElevatorFloorButton();

signals:
    void press(int floor);

public slots:
    void buttonPressed1();
    void buttonPressed2();
    void buttonPressed3();
    void buttonPressed4();
    void buttonPressed5();
    void buttonPressed6();
    void buttonPressed7();
};

#endif
