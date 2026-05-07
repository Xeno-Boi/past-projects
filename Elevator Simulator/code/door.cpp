#include "door.h"

Door::Door(){
    timer.setSingleShot(true);
    connect(&timer, SIGNAL(timeout()), this, SLOT(doorTimerTimeout()));
}

Door::~Door(){
}

// slots
void Door::open(){
    door_open_time = -1;
    if (status != OPENED){
        status = OPENING;
        emit(updateDoorDisplay("opening"));
        QTimer::singleShot(door_movement_time * 1000, this, SLOT(doorOpened()));
    }
}

void Door::open(int seconds){
    door_open_time = seconds;
    if (status != OPENED){
        status = OPENING;
        emit(updateDoorDisplay("opening"));
        QTimer::singleShot(door_movement_time * 1000, this, SLOT(doorOpened()));
    } else {
        if (door_open_time > 0){
            timer.start(door_open_time * 1000);
        }
    }
}

void Door::close(){
    if (status != CLOSED){
        status = CLOSING;
        emit(updateDoorDisplay("closing"));
        QTimer::singleShot(door_movement_time * 1000, this, SLOT(doorClosed()));
    }
}

void Door::doorOpened(){
    if (status == OPENING){
        status = OPENED;
        emit(updateDoorDisplay("opened"));
        if (door_open_time > 0){
            timer.start(door_open_time * 1000);
        }
    }
}

void Door::doorClosed(){
    if (status == CLOSING){
        status = CLOSED;
        emit(updateDoorDisplay("closed"));
        emit(closed());
    }
}

void Door::doorTimerTimeout(){
    emit(closeDoor());
}
