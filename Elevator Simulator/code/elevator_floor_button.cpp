#include "elevator_floor_button.h"

ElevatorFloorButton::ElevatorFloorButton(){}

ElevatorFloorButton::~ElevatorFloorButton(){}


// slots
void ElevatorFloorButton::buttonPressed1(){
    emit press(1);
}

void ElevatorFloorButton::buttonPressed2(){
    emit press(2);
}

void ElevatorFloorButton::buttonPressed3(){
    emit press(3);
}

void ElevatorFloorButton::buttonPressed4(){
    emit press(4);
}

void ElevatorFloorButton::buttonPressed5(){
    emit press(5);
}

void ElevatorFloorButton::buttonPressed6(){
    emit press(6);
}

void ElevatorFloorButton::buttonPressed7(){
    emit press(7);
}
