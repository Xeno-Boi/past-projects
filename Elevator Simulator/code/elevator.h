#ifndef ELEVATOR_H
#define ELEVATOR_H

#include <QObject>
#include <QTimer>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>
#include <set>
#include <iterator>

#include "audio.h"
#include "bell.h"
#include "car.h"
#include "close_button.h"
#include "display.h"
#include "door.h"
#include "door_sensor.h"
#include "elevator_floor_button.h"
#include "floor_sensor.h"
#include "help_button.h"
#include "open_button.h"
#include "weight_sensor.h"

// constants
#define GOING_UP 10
#define GOING_DOWN 11
#define STOP 12

#define EMERGENCY 20
#define FIRE 21
#define POWER_OUT 22

using namespace std;

// elevator class
class Elevator : public QObject{
    Q_OBJECT

    public:
    Elevator(int id);
    ~Elevator();

    void setUp();

    void arrive();

    bool floorRequestUp(int floor);
    bool floorRequestDown(int floor);

    void display(string message);
    void playAudio(string message);

    void callEmergencyService();
    void callBuildingSafety();

    void start_moving();

    // getters
    inline Audio* getAudio(){ return audio_object; };
    inline Bell* getBell(){ return bell; };
    inline Car* getCar(){ return car; };
    inline CloseButton* getCloseButton(){ return close_button; };
    inline Display* getDisplay(){ return display_object; };
    inline Door* getDoor(){ return door; };
    inline DoorSensor* getDoorSensor(){ return door_sensor; };
    inline ElevatorFloorButton* getFloorButton(){ return elevator_floor_button; };
    inline FloorSensor* getFloorSensor(){ return floor_sensor; };
    inline HelpButton* getHelpButton(){ return help_button; };
    inline OpenButton* getOpenButton(){ return open_button; };
    inline WeightSensor* getWeightSensor(){ return weight_sensor; };

    // helper



    private:
    int id;
    int current_floor = 1;
    int destination = -1;    // current destination floor
    set<int> destination_floors;    // all destination floors
    int moving = STOP;      // movement direction of car
    int direction = GOING_UP;   // overall direction

    bool in_emergency = false;

    bool building_safety_replied = false;
    int building_safety_timeout_seconds = 5;

    // helper
    int findMin(set<int>);  // finds minimum value in an int set
    int findMax(set<int>);  // finds maximum value in an int set
    void printSet(set<int>);

    // references
    Audio* audio_object;
    Bell* bell;
    Car* car;
    CloseButton* close_button;
    Display* display_object;
    Door* door;
    DoorSensor* door_sensor;
    ElevatorFloorButton* elevator_floor_button;
    FloorSensor* floor_sensor;
    HelpButton* help_button;
    OpenButton* open_button;
    WeightSensor* weight_sensor;


signals:
    void Signal_MoveUp();
    void Signal_MoveDown();
    void Signal_MoveStop();
    void updateFloorDisplay(int);
    void Signal_OpenDoor();     // does not automatically close
    void Signal_OpenDoor(int seconds);      // automatically close
    void Signal_CloseDoor();
    void Signal_RingBell();
    void Signal_Display(string);
    void Signal_Audio(string);
    void Signal_Available(int id);
    void Signal_Arrive(int floor, int direction);

public slots:
    // floor request
    void selfFloorRequest(int floor);
    // floor sensor
    void newFloor();
    // door control
    void openDoor(bool auto_close);
    void closeDoor();
    // door
    //void door_opened();
    void door_closed();
    // building safety
    void help();
    void buildingSafetyReplied();
    void buildingSafetyTimeout();
    // door sensor
    void doorObstructs();
    void doorObstructTimeout();
    // weight sensor
    void overload();
    void normalLoad();
    // emergency
    void emergency(int);

    void debug();
};

#endif
