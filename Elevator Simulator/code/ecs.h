#ifndef ECS_H
#define ECS_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <iostream>
#include <set>

#include "elevator.h"
#include "floor_button.h"

// constants
#define GOING_UP 10
#define GOING_DOWN 11
#define STOP 12

#define EMERGENCY 20
#define FIRE 21
#define POWER_OUT 22

using namespace std;

class ECS : public QObject{
    Q_OBJECT

public:
    ECS();
    ~ECS();

    void test();

    // getters
    inline Elevator* getElevator(int id){ return elevators[id]; };
    inline FloorButton* getFloorButton(){ return floor_button; };

private:
    int n = 3;
    vector<Elevator*> elevators;
    FloorButton* floor_button;

    set<int> requested_floors_up;   // floors to be assigned stored asc
    set<int, greater<int>> requested_floors_down;   // floors to be assigned stored desc

signals:
    void lightsOffFloorButton(int floor, bool up);

public slots:
    void floorRequestUp(int floor);
    void floorRequestDown(int floor);
    void elevatorAvailable(int id);
    void elevatorArrives(int floor, int direction);
    void emergency();
    void fire();
    void power_out();
    void debug();
};

#endif // ECS_H
