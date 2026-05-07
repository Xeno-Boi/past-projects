#include "door_sensor.h"

DoorSensor::DoorSensor(){}

DoorSensor::~DoorSensor(){}

// slots
void DoorSensor::obstruct(){
    obstructed = true;
    emit(doorObstructs());
}

void DoorSensor::unobstruct()
{
    obstructed = false;
}
